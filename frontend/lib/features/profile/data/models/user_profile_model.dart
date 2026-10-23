import '../../domain/entities/user_profile.dart';

class UserProfileModel extends UserProfile {
  const UserProfileModel({
    required super.id,
    required super.userId,
    required super.displayName,
    required super.username,
    required super.email,
    super.phone,
    super.avatarUrl,
    super.coverImageUrl,
    super.bio,
    super.dateOfBirth,
    super.gender,
    super.country,
    super.city,
    required super.timezone,
    required super.language,
    required super.completionPercentage,
  });

  factory UserProfileModel.fromJson(Map<String, dynamic> json) {
    final target = (json['data'] is Map<String, dynamic>) ? json['data'] as Map<String, dynamic> : json;
    final userMap = target['user'] is Map<String, dynamic> ? target['user'] as Map<String, dynamic> : null;

    final firstName = target['firstName'] as String? ?? userMap?['firstName'] as String? ?? '';
    final lastName = target['lastName'] as String? ?? userMap?['lastName'] as String? ?? '';
    final rawName = target['fullName'] as String? ??
        target['displayName'] as String? ??
        target['name'] as String? ??
        userMap?['fullName'] as String? ??
        userMap?['displayName'] as String?;
    final emailVal = target['email'] as String? ?? userMap?['email'] as String? ?? '';
    final computedName = (rawName != null && rawName.trim().isNotEmpty)
        ? rawName.trim()
        : (firstName.isNotEmpty || lastName.isNotEmpty
            ? '$firstName $lastName'.trim()
            : (emailVal.isNotEmpty ? emailVal.split('@').first : 'User'));

    final usernameVal = target['username'] as String? ??
        userMap?['username'] as String? ??
        (emailVal.isNotEmpty ? emailVal.split('@').first : '');

    return UserProfileModel(
      id: target['id'] as String? ?? userMap?['id'] as String? ?? '',
      userId: target['userId'] as String? ?? userMap?['id'] as String? ?? '',
      displayName: computedName,
      username: usernameVal,
      email: emailVal,
      phone: target['phone'] as String? ?? userMap?['phone'] as String?,
      avatarUrl: target['avatarUrl'] as String? ?? target['avatar'] as String? ?? userMap?['avatarUrl'] as String? ?? userMap?['avatar'] as String?,
      coverImageUrl: target['coverImageUrl'] as String? ?? userMap?['coverImageUrl'] as String?,
      bio: target['bio'] as String? ?? '',
      dateOfBirth: target['dateOfBirth'] != null
          ? DateTime.tryParse(target['dateOfBirth'] as String)
          : (userMap?['dateOfBirth'] != null ? DateTime.tryParse(userMap!['dateOfBirth'] as String) : null),
      gender: target['gender'] as String?,
      country: target['country'] as String? ?? '',
      city: target['city'] as String? ?? '',
      timezone: target['timezone'] as String? ?? 'UTC',
      language: target['language'] as String? ?? 'en',
      completionPercentage: (target['profileCompletionPercentage'] as num?)?.toInt() ?? (target['completionPercentage'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'displayName': displayName,
      'username': username,
      'email': email,
      'phone': phone,
      'avatarUrl': avatarUrl,
      'coverImageUrl': coverImageUrl,
      'bio': bio,
      'dateOfBirth': dateOfBirth?.toIso8601String(),
      'gender': gender,
      'country': country,
      'city': city,
      'timezone': timezone,
      'language': language,
      'completionPercentage': completionPercentage,
    };
  }
}
