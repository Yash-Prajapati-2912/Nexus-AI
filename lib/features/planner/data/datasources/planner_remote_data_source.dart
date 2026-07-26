import '../../../../config/constants/api_constants.dart';
import '../../../../core/network/base_remote_data_source.dart';
import '../models/assignment_model.dart';
import '../models/calendar_event_model.dart';
import '../models/goal_model.dart';
import '../models/study_session_model.dart';
import '../models/task_model.dart';

abstract class IPlannerRemoteDataSource {
  Future<List<TaskModel>> getTasks();
  Future<TaskModel> createTask(TaskModel model);
  Future<TaskModel> updateTask(TaskModel model);
  Future<void> deleteTask(String id);
  Future<TaskModel> completeTask(String id);

  Future<List<AssignmentModel>> getAssignments();
  Future<AssignmentModel> createAssignment(AssignmentModel model);
  Future<AssignmentModel> updateAssignment(AssignmentModel model);
  Future<void> deleteAssignment(String id);

  Future<List<StudySessionModel>> getStudySessions();
  Future<StudySessionModel> createStudySession(StudySessionModel model);

  Future<List<GoalModel>> getGoals();
  Future<List<CalendarEventModel>> getCalendarEvents();
  Future<List<TaskModel>> searchPlanner(String query);
}

class PlannerRemoteDataSourceImpl extends BaseRemoteDataSource implements IPlannerRemoteDataSource {
  PlannerRemoteDataSourceImpl(super.apiClient);

  @override
  Future<List<TaskModel>> getTasks() async {
    final response = await apiClient.get(ApiConstants.tasks);
    final list = (response.data is List) ? response.data as List : (response.data['data'] as List? ?? []);
    return list.map((e) => TaskModel.fromJson(e as Map<String, dynamic>)).toList();
  }

  @override
  Future<TaskModel> createTask(TaskModel model) async {
    final response = await apiClient.post(ApiConstants.tasks, data: model.toJson());
    final data = (response.data is Map<String, dynamic> && response.data['data'] != null)
        ? response.data['data']
        : response.data;
    return TaskModel.fromJson(data as Map<String, dynamic>);
  }

  @override
  Future<TaskModel> updateTask(TaskModel model) async {
    final response = await apiClient.put('${ApiConstants.tasks}/${model.id}', data: model.toJson());
    final data = (response.data is Map<String, dynamic> && response.data['data'] != null)
        ? response.data['data']
        : response.data;
    return TaskModel.fromJson(data as Map<String, dynamic>);
  }

  @override
  Future<void> deleteTask(String id) async {
    await apiClient.delete('${ApiConstants.tasks}/$id');
  }

  @override
  Future<TaskModel> completeTask(String id) async {
    final response = await apiClient.patch('${ApiConstants.tasks}/$id/complete');
    final data = (response.data is Map<String, dynamic> && response.data['data'] != null)
        ? response.data['data']
        : response.data;
    return TaskModel.fromJson(data as Map<String, dynamic>);
  }

  @override
  Future<List<AssignmentModel>> getAssignments() async {
    final response = await apiClient.get('/planner/assignments');
    final list = (response.data is List) ? response.data as List : (response.data['data'] as List? ?? []);
    return list.map((e) => AssignmentModel.fromJson(e as Map<String, dynamic>)).toList();
  }

  @override
  Future<AssignmentModel> createAssignment(AssignmentModel model) async {
    final response = await apiClient.post('/planner/assignments', data: model.toJson());
    final data = (response.data is Map<String, dynamic> && response.data['data'] != null)
        ? response.data['data']
        : response.data;
    return AssignmentModel.fromJson(data as Map<String, dynamic>);
  }

  @override
  Future<AssignmentModel> updateAssignment(AssignmentModel model) async {
    final response = await apiClient.put('/planner/assignments/${model.id}', data: model.toJson());
    final data = (response.data is Map<String, dynamic> && response.data['data'] != null)
        ? response.data['data']
        : response.data;
    return AssignmentModel.fromJson(data as Map<String, dynamic>);
  }

  @override
  Future<void> deleteAssignment(String id) async {
    await apiClient.delete('/planner/assignments/$id');
  }

  @override
  Future<List<StudySessionModel>> getStudySessions() async {
    final response = await apiClient.get('/planner/sessions');
    final list = (response.data is List) ? response.data as List : (response.data['data'] as List? ?? []);
    return list.map((e) => StudySessionModel.fromJson(e as Map<String, dynamic>)).toList();
  }

  @override
  Future<StudySessionModel> createStudySession(StudySessionModel model) async {
    final response = await apiClient.post('/planner/sessions', data: model.toJson());
    final data = (response.data is Map<String, dynamic> && response.data['data'] != null)
        ? response.data['data']
        : response.data;
    return StudySessionModel.fromJson(data as Map<String, dynamic>);
  }

  @override
  Future<List<GoalModel>> getGoals() async {
    final response = await apiClient.get('/planner/goals');
    final list = (response.data is List) ? response.data as List : (response.data['data'] as List? ?? []);
    return list.map((e) => GoalModel.fromJson(e as Map<String, dynamic>)).toList();
  }

  @override
  Future<List<CalendarEventModel>> getCalendarEvents() async {
    final response = await apiClient.get('/planner/calendar');
    final list = (response.data is List) ? response.data as List : (response.data['data'] as List? ?? []);
    return list.map((e) => CalendarEventModel.fromJson(e as Map<String, dynamic>)).toList();
  }

  @override
  Future<List<TaskModel>> searchPlanner(String query) async {
    final response = await apiClient.get('${ApiConstants.tasks}?search=$query');
    final list = (response.data is List) ? response.data as List : (response.data['data'] as List? ?? []);
    return list.map((e) => TaskModel.fromJson(e as Map<String, dynamic>)).toList();
  }
}
