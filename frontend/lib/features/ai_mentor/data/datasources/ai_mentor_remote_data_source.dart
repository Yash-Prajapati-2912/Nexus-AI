import 'package:nexus_ai/core/network/api_client.dart';
import '../models/chat_message_model.dart';
import '../models/conversation_model.dart';
import '../models/mentor_feedback_model.dart';
import '../models/prompt_template_model.dart';
import '../models/student_wellness_model.dart';

abstract class IAIMentorRemoteDataSource {
  Future<ChatMessageModel> sendMessage(String conversationId, String content, {String? topic});
  Future<List<ConversationModel>> getConversations({int page = 1, int limit = 20});
  Future<ConversationModel> getConversationById(String conversationId);
  Future<ConversationModel> updateConversation(String conversationId, {String? title, bool? isPinned, bool? isArchived});
  Future<void> deleteConversation(String conversationId);
  Future<List<ChatMessageModel>> getMessages(String conversationId);
  Future<void> submitFeedback(MentorFeedbackModel feedback);
  Future<StudentWellnessModel> getWellnessScores();
  Future<List<PromptTemplateModel>> getSuggestedPrompts();
  Future<List<ConversationModel>> searchConversations(String query);
}

class AIMentorRemoteDataSourceImpl implements IAIMentorRemoteDataSource {
  final ApiClient _apiClient;

  AIMentorRemoteDataSourceImpl(this._apiClient);

  @override
  Future<ChatMessageModel> sendMessage(String conversationId, String content, {String? topic}) async {
    final endpoint = _getEndpointForTopic(topic);
    final body = <String, dynamic>{
      'message': content,
      'prompt': content,
    };
    if (conversationId.isNotEmpty && conversationId != 'c_new') {
      body['conversationId'] = conversationId;
    }
    final response = await _apiClient.post(
      endpoint,
      data: body,
    );
    final data = _unwrapPayload(response.data);
    return ChatMessageModel.fromJson(data);
  }

  @override
  Future<List<ConversationModel>> getConversations({int page = 1, int limit = 20}) async {
    final response = await _apiClient.get('/mentor/conversations', queryParameters: {'page': page, 'limit': limit});
    final rawData = response.data;
    final list = rawData is List<dynamic>
        ? rawData
        : (rawData is Map<String, dynamic> && rawData['data'] is List
            ? rawData['data'] as List<dynamic>
            : (rawData is Map<String, dynamic> && rawData['data'] is Map<String, dynamic> && rawData['data']['items'] is List
                ? rawData['data']['items'] as List<dynamic>
                : []));
    return list.map((e) => ConversationModel.fromJson(e as Map<String, dynamic>)).toList();
  }

  @override
  Future<ConversationModel> getConversationById(String conversationId) async {
    final response = await _apiClient.get('/mentor/conversations/$conversationId');
    final data = _unwrapPayload(response.data);
    return ConversationModel.fromJson(data);
  }

  @override
  Future<ConversationModel> updateConversation(String conversationId, {String? title, bool? isPinned, bool? isArchived}) async {
    final body = <String, dynamic>{};
    if (title != null) body['title'] = title;
    if (isPinned != null) body['isPinned'] = isPinned;
    if (isArchived != null) body['isArchived'] = isArchived;

    final response = await _apiClient.patch('/mentor/conversations/$conversationId', data: body);
    final data = _unwrapPayload(response.data);
    return ConversationModel.fromJson(data);
  }

  @override
  Future<void> deleteConversation(String conversationId) async {
    await _apiClient.delete('/mentor/conversations/$conversationId');
  }

  @override
  Future<List<ChatMessageModel>> getMessages(String conversationId) async {
    final response = await _apiClient.get('/mentor/conversations/$conversationId');
    final data = _unwrapPayload(response.data);
    final rawMessages = data['messages'] as List<dynamic>? ?? [];
    return rawMessages.map((e) => ChatMessageModel.fromJson(e as Map<String, dynamic>)).toList();
  }

  @override
  Future<void> submitFeedback(MentorFeedbackModel feedback) async {
    final endpoint = feedback.messageId.isNotEmpty
        ? '/mentor/messages/${feedback.messageId}/feedback'
        : '/mentor/chat/feedback';
    await _apiClient.post(endpoint, data: feedback.toJson());
  }

  @override
  Future<StudentWellnessModel> getWellnessScores() async {
    final response = await _apiClient.get('/mentor/wellness-scores');
    final data = _unwrapPayload(response.data);
    return StudentWellnessModel.fromJson(data);
  }

  Map<String, dynamic> _unwrapPayload(dynamic rawData) {
    if (rawData is Map<String, dynamic>) {
      if (rawData['data'] is Map<String, dynamic>) {
        return rawData['data'] as Map<String, dynamic>;
      }
      return rawData;
    }
    return <String, dynamic>{};
  }

  @override
  Future<List<PromptTemplateModel>> getSuggestedPrompts() async {
    return const [
      PromptTemplateModel(id: 'p1', title: 'Exam Prep Strategy', category: 'STUDY', promptText: 'How should I structure my revision for upcoming midterms?'),
      PromptTemplateModel(id: 'p2', title: 'Monthly Budget Audit', category: 'FINANCE', promptText: 'Help me analyze my dining expenses and save \$50/month.'),
      PromptTemplateModel(id: 'p3', title: 'Placement Readiness', category: 'CAREER', promptText: 'What technical skills should I highlight on my software engineering resume?'),
      PromptTemplateModel(id: 'p4', title: 'Burnout Prevention', category: 'PRODUCTIVITY', promptText: 'Give me a 15-minute daily mindfulness & study break framework.'),
    ];
  }

  @override
  Future<List<ConversationModel>> searchConversations(String query) async {
    final response = await _apiClient.get('/mentor/conversations', queryParameters: {'search': query});
    final rawData = response.data;
    final list = rawData is List<dynamic>
        ? rawData
        : (rawData is Map<String, dynamic> && rawData['data'] is List
            ? rawData['data'] as List<dynamic>
            : (rawData is Map<String, dynamic> && rawData['data'] is Map<String, dynamic> && rawData['data']['items'] is List
                ? rawData['data']['items'] as List<dynamic>
                : []));
    return list.map((e) => ConversationModel.fromJson(e as Map<String, dynamic>)).toList();
  }

  String _getEndpointForTopic(String? topic) {
    switch (topic?.toUpperCase()) {
      case 'CAREER':
        return '/mentor/career';
      case 'STUDY':
        return '/mentor/study';
      case 'DECISION':
        return '/mentor/decision';
      case 'PRODUCTIVITY':
        return '/mentor/productivity';
      case 'FINANCE':
        return '/mentor/finance';
      default:
        return '/mentor/chat';
    }
  }
}
