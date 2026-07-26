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
    return UserProfileModel(
      id: json['id'] as String? ?? '',
      userId: json['userId'] as String? ?? '',
      displayName: json['displayName'] as String? ?? json['name'] as String? ?? 'Student',
      username: json['username'] as String? ?? 'student',
      email: json['email'] as String? ?? '',
      phone: json['phone'] as String?,
      avatarUrl: json['avatarUrl'] as String? ?? json['avatar'] as String?,
      coverImageUrl: json['coverImageUrl'] as String?,
      bio: json['bio'] as String? ?? 'Computer Science Undergraduate',
      dateOfBirth: json['dateOfBirth'] != null ? DateTime.parse(json['dateOfBirth'] as String) : null,
      gender: json['gender'] as String?,
      country: json['country'] as String? ?? 'United States',
      city: json['city'] as String? ?? 'San Francisco',
      timezone: json['timezone'] as String? ?? 'UTC',
      language: json['language'] as String? ?? 'en',
      completionPercentage: json['completionPercentage'] as int? ?? 90,
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
