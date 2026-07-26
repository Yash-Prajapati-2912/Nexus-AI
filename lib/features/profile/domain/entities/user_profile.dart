import 'package:equatable/equatable.dart';

/// Domain entity representing user profile details.
class UserProfile extends Equatable {
  final String id;
  final String userId;
  final String displayName;
  final String username;
  final String email;
  final String? phone;
  final String? avatarUrl;
  final String? coverImageUrl;
  final String? bio;
  final DateTime? dateOfBirth;
  final String? gender;
  final String? country;
  final String? city;
  final String timezone;
  final String language;
  final int completionPercentage;

  const UserProfile({
    required this.id,
    required this.userId,
    required this.displayName,
    required this.username,
    required this.email,
    this.phone,
    this.avatarUrl,
    this.coverImageUrl,
    this.bio,
    this.dateOfBirth,
    this.gender,
    this.country,
    this.city,
    required this.timezone,
    required this.language,
    required this.completionPercentage,
  });

  @override
  List<Object?> get props => [
        id,
        userId,
        displayName,
        username,
        email,
        phone,
        avatarUrl,
        coverImageUrl,
        bio,
        dateOfBirth,
        gender,
        country,
        city,
        timezone,
        language,
        completionPercentage,
      ];
}
