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
    final userMap = json['user'] is Map<String, dynamic> ? json['user'] as Map<String, dynamic> : null;

    final firstName = json['firstName'] as String? ?? userMap?['firstName'] as String? ?? '';
    final lastName = json['lastName'] as String? ?? userMap?['lastName'] as String? ?? '';
    final rawName = json['fullName'] as String? ??
        json['displayName'] as String? ??
        json['name'] as String? ??
        userMap?['fullName'] as String? ??
        userMap?['displayName'] as String?;
    final computedName = (rawName != null && rawName.trim().isNotEmpty)
        ? rawName.trim()
        : (firstName.isNotEmpty || lastName.isNotEmpty ? '$firstName $lastName'.trim() : 'Student');

    final emailVal = json['email'] as String? ?? userMap?['email'] as String? ?? '';
    final usernameVal = json['username'] as String? ??
        userMap?['username'] as String? ??
        (emailVal.isNotEmpty ? emailVal.split('@').first : 'student');

    return UserProfileModel(
      id: json['id'] as String? ?? userMap?['id'] as String? ?? '',
      userId: json['userId'] as String? ?? userMap?['id'] as String? ?? '',
      displayName: computedName,
      username: usernameVal,
      email: emailVal,
      phone: json['phone'] as String? ?? userMap?['phone'] as String?,
      avatarUrl: json['avatarUrl'] as String? ?? json['avatar'] as String? ?? userMap?['avatarUrl'] as String? ?? userMap?['avatar'] as String?,
      coverImageUrl: json['coverImageUrl'] as String? ?? userMap?['coverImageUrl'] as String?,
      bio: json['bio'] as String? ?? '',
      dateOfBirth: json['dateOfBirth'] != null
          ? DateTime.tryParse(json['dateOfBirth'] as String)
          : (userMap?['dateOfBirth'] != null ? DateTime.tryParse(userMap!['dateOfBirth'] as String) : null),
      gender: json['gender'] as String?,
      country: json['country'] as String? ?? '',
      city: json['city'] as String? ?? '',
      timezone: json['timezone'] as String? ?? 'UTC',
      language: json['language'] as String? ?? 'en',
      completionPercentage: (json['profileCompletionPercentage'] as num?)?.toInt() ?? (json['completionPercentage'] as num?)?.toInt() ?? 85,
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
