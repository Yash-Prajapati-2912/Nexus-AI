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

  dynamic _unpackData(dynamic raw) {
    if (raw is Map<String, dynamic> && raw.containsKey('data') && raw['data'] != null) {
      return raw['data'];
    }
    return raw;
  }

  @override
  Future<UserProfileModel> getProfile() async {
    final response = await _apiClient.get('/profile/me');
    final data = _unpackData(response.data);
    return UserProfileModel.fromJson(data as Map<String, dynamic>);
  }

  @override
  Future<UserProfileModel> updateProfile(Map<String, dynamic> body) async {
    final response = await _apiClient.patch('/profile/me', data: body);
    final data = _unpackData(response.data);
    return UserProfileModel.fromJson(data as Map<String, dynamic>);
  }

  @override
  Future<String> uploadAvatar(String imagePath) async {
    final response = await _apiClient.post('/profile/avatar', data: {'imagePath': imagePath});
    final data = _unpackData(response.data);
    if (data is Map<String, dynamic>) {
      return data['avatarUrl'] as String? ?? data['avatar'] as String? ?? '';
    }
    return '';
  }

  @override
  Future<AcademicProfileModel> getAcademicProfile() async {
    final response = await _apiClient.get('/profile/me');
    final rawData = _unpackData(response.data);
    if (rawData is Map<String, dynamic>) {
      return AcademicProfileModel.fromJson(rawData);
    }
    return const AcademicProfileModel(
      id: '',
      university: '',
      college: '',
      degree: '',
      branch: '',
      semester: 0,
      currentYear: 0,
      cgpa: 0.0,
      graduationYear: 0,
      subjects: [],
      skills: [],
      careerInterests: [],
    );
  }

  @override
  Future<AcademicProfileModel> updateAcademicProfile(Map<String, dynamic> body) async {
    final payload = Map<String, dynamic>.from(body);
    if (payload.containsKey('branch') && (!payload.containsKey('department') || payload['department'] == null)) {
      payload['department'] = payload['branch'];
    }
    payload.remove('branch');
    payload.remove('username');

    if (payload['semester'] == 0 || payload['semester'] == '0') {
      payload.remove('semester');
    }
    if (payload['graduationYear'] == 0 || payload['graduationYear'] == '0') {
      payload.remove('graduationYear');
    }

    final response = await _apiClient.patch('/profile/me', data: payload);
    final data = _unpackData(response.data);
    if (data is Map<String, dynamic>) {
      return AcademicProfileModel.fromJson(data);
    }
    return AcademicProfileModel.fromJson(body);
  }

  @override
  Future<UserPreferencesModel> getPreferences() async {
    final response = await _apiClient.get('/profile/preferences');
    final data = _unpackData(response.data);
    return UserPreferencesModel.fromJson(data as Map<String, dynamic>);
  }

  @override
  Future<UserPreferencesModel> updatePreferences(Map<String, dynamic> body) async {
    final response = await _apiClient.patch('/profile/preferences', data: body);
    final data = _unpackData(response.data);
    return UserPreferencesModel.fromJson(data as Map<String, dynamic>);
  }

  @override
  Future<UserStatisticsModel> getStatistics() async {
    final response = await _apiClient.get('/profile/analytics');
    final data = _unpackData(response.data);
    return UserStatisticsModel.fromJson(data as Map<String, dynamic>);
  }

  @override
  Future<List<AchievementModel>> getAchievements() async {
    final response = await _apiClient.get('/profile/achievements');
    final rawData = _unpackData(response.data);
    final list = rawData is List<dynamic> ? rawData : [];
    return list.map((e) => AchievementModel.fromJson(e as Map<String, dynamic>)).toList();
  }

  @override
  Future<List<ConnectedAccountModel>> getConnectedAccounts() async {
    final response = await _apiClient.get('/profile/connected-accounts');
    final rawData = _unpackData(response.data);
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
    final data = _unpackData(response.data);
    return SecuritySettingsModel.fromJson(data as Map<String, dynamic>);
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
    final data = _unpackData(response.data);
    if (data is Map<String, dynamic>) {
      return data['downloadUrl'] as String? ?? 'https://api.nexus-ai.com/exports/user_data.json';
    }
    return 'https://api.nexus-ai.com/exports/user_data.json';
  }

  @override
  Future<void> deleteAccount() async {
    await _apiClient.delete('/profile/me');
  }
}
