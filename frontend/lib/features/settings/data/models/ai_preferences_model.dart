import '../../domain/entities/ai_preferences_entity.dart';

class AIPreferencesModel extends AIPreferencesEntity {
  const AIPreferencesModel({
    required super.personality,
    required super.responseStyle,
    required super.responseLength,
    required super.preferredLanguage,
    required super.streamingResponses,
    required super.contextMemoryEnabled,
    required super.suggestionsEnabled,
  });

  factory AIPreferencesModel.fromJson(Map<String, dynamic> json) {
    return AIPreferencesModel(
      personality: json['personality'] as String? ?? 'Professional',
      responseStyle: json['responseStyle'] as String? ?? 'BALANCED',
      responseLength: json['responseLength'] as String? ?? 'Medium',
      preferredLanguage: json['preferredLanguage'] as String? ?? 'English',
      streamingResponses: json['streamingResponses'] as bool? ?? true,
      contextMemoryEnabled: json['contextMemoryEnabled'] as bool? ?? true,
      suggestionsEnabled: json['suggestionsEnabled'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'personality': personality,
      'responseStyle': responseStyle,
      'responseLength': responseLength,
      'preferredLanguage': preferredLanguage,
      'streamingResponses': streamingResponses,
      'contextMemoryEnabled': contextMemoryEnabled,
      'suggestionsEnabled': suggestionsEnabled,
    };
  }

  factory AIPreferencesModel.fromEntity(AIPreferencesEntity entity) {
    return AIPreferencesModel(
      personality: entity.personality,
      responseStyle: entity.responseStyle,
      responseLength: entity.responseLength,
      preferredLanguage: entity.preferredLanguage,
      streamingResponses: entity.streamingResponses,
      contextMemoryEnabled: entity.contextMemoryEnabled,
      suggestionsEnabled: entity.suggestionsEnabled,
    );
  }
}
