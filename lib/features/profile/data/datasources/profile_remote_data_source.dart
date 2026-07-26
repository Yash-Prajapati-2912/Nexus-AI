import 'package:nexus_ai/core/network/api_client.dart';
import '../models/academic_profile_model.dart';
import '../models/achievement_model.dart';
import '../models/connected_account_model.dart';
import '../models/security_settings_model.dart';
import '../models/user_preferences_model.dart';
import '../models/user_profile_model.dart';
import '../models/user_statistics_model.dart';

abstract class IProfileRemoteDataSource {
  Future<UserProfileModel> getProfile();
  Future<UserProfileModel> updateProfile(Map<String, dynamic> body);
  Future<String> uploadAvatar(String imagePath);
  Future<AcademicProfileModel> getAcademicProfile();
  Future<AcademicProfileModel> updateAcademicProfile(Map<String, dynamic> body);
  Future<UserPreferencesModel> getPreferences();
  Future<UserPreferencesModel> updatePreferences(Map<String, dynamic> body);
  Future<UserStatisticsModel> getStatistics();
  Future<List<AchievementModel>> getAchievements();
  Future<List<ConnectedAccountModel>> getConnectedAccounts();
  Future<void> linkConnectedAccount(String provider);
  Future<void> unlinkConnectedAccount(String provider);
  Future<SecuritySettingsModel> getSecuritySettings();
  Future<void> changePassword(String currentPassword, String newPassword);
  Future<String> exportUserData();
  Future<void> deleteAccount();
}

class ProfileRemoteDataSourceImpl implements IProfileRemoteDataSource {
  final ApiClient _apiClient;

  ProfileRemoteDataSourceImpl(this._apiClient);

  @override
  Future<UserProfileModel> getProfile() async {
    final response = await _apiClient.get('/profile/me');
    final data = response.data as Map<String, dynamic>;
    return UserProfileModel.fromJson(data);
  }

  @override
  Future<UserProfileModel> updateProfile(Map<String, dynamic> body) async {
    final response = await _apiClient.patch('/profile/me', data: body);
    final data = response.data as Map<String, dynamic>;
    return UserProfileModel.fromJson(data);
  }

  @override
  Future<String> uploadAvatar(String imagePath) async {
    final response = await _apiClient.post('/profile/avatar', data: {'imagePath': imagePath});
    final data = response.data as Map<String, dynamic>;
    return data['avatarUrl'] as String? ?? '';
  }

  @override
  Future<AcademicProfileModel> getAcademicProfile() async {
    final response = await _apiClient.get('/profile/education');
    final rawData = response.data;
    if (rawData is List<dynamic> && rawData.isNotEmpty) {
      return AcademicProfileModel.fromJson(rawData.first as Map<String, dynamic>);
    } else if (rawData is Map<String, dynamic>) {
      return AcademicProfileModel.fromJson(rawData);
    }
    return const AcademicProfileModel(
      id: 'a1',
      university: 'Stanford University',
      college: 'School of Engineering',
      degree: 'Bachelor of Science',
      branch: 'Computer Science',
      semester: 6,
      currentYear: 3,
      cgpa: 3.85,
      graduationYear: 2027,
      subjects: ['Data Structures', 'AI'],
      skills: ['Flutter', 'Dart'],
      careerInterests: ['AI Software Architecture'],
    );
  }

  @override
  Future<AcademicProfileModel> updateAcademicProfile(Map<String, dynamic> body) async {
    final response = await _apiClient.post('/profile/education', data: body);
    final data = response.data as Map<String, dynamic>;
    return AcademicProfileModel.fromJson(data);
  }

  @override
  Future<UserPreferencesModel> getPreferences() async {
    final response = await _apiClient.get('/profile/preferences');
    final data = response.data as Map<String, dynamic>;
    return UserPreferencesModel.fromJson(data);
  }

  @override
  Future<UserPreferencesModel> updatePreferences(Map<String, dynamic> body) async {
    final response = await _apiClient.patch('/profile/preferences', data: body);
    final data = response.data as Map<String, dynamic>;
    return UserPreferencesModel.fromJson(data);
  }

  @override
  Future<UserStatisticsModel> getStatistics() async {
    final response = await _apiClient.get('/profile/analytics');
    final data = response.data as Map<String, dynamic>;
    return UserStatisticsModel.fromJson(data);
  }

  @override
  Future<List<AchievementModel>> getAchievements() async {
    final response = await _apiClient.get('/profile/achievements');
    final rawData = response.data;
    final list = rawData is List<dynamic> ? rawData : [];
    return list.map((e) => AchievementModel.fromJson(e as Map<String, dynamic>)).toList();
  }

  @override
  Future<List<ConnectedAccountModel>> getConnectedAccounts() async {
    final response = await _apiClient.get('/profile/connected-accounts');
    final rawData = response.data;
    final list = rawData is List<dynamic> ? rawData : [];
    return list.map((e) => ConnectedAccountModel.fromJson(e as Map<String, dynamic>)).toList();
  }

  @override
  Future<void> linkConnectedAccount(String provider) async {
    await _apiClient.post('/profile/connected-accounts/link', data: {'provider': provider});
  }

  @override
  Future<void> unlinkConnectedAccount(String provider) async {
    await _apiClient.delete('/profile/connected-accounts/$provider');
  }

  @override
  Future<SecuritySettingsModel> getSecuritySettings() async {
    final response = await _apiClient.get('/profile/security');
    final data = response.data as Map<String, dynamic>;
    return SecuritySettingsModel.fromJson(data);
  }

  @override
  Future<void> changePassword(String currentPassword, String newPassword) async {
    await _apiClient.post('/profile/change-password', data: {
      'currentPassword': currentPassword,
      'newPassword': newPassword,
    });
  }

  @override
  Future<String> exportUserData() async {
    final response = await _apiClient.post('/profile/export-data', data: {});
    final data = response.data as Map<String, dynamic>;
    return data['downloadUrl'] as String? ?? 'https://api.nexus-ai.com/exports/user_data.json';
  }

  @override
  Future<void> deleteAccount() async {
    await _apiClient.delete('/profile/me');
  }
}
