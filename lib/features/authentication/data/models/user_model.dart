import '../../domain/entities/user_entity.dart';

/// User Model (Data Transfer Object & Entity Mapper).
class UserModel extends UserEntity {
  const UserModel({
    required super.id,
    required super.email,
    required super.fullName,
    required super.role,
    required super.isEmailVerified,
    super.avatarUrl,
    required super.createdAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    final map = json.containsKey('user') && json['user'] is Map<String, dynamic>
        ? json['user'] as Map<String, dynamic>
        : json;

    final firstName = map['firstName'] as String? ?? '';
    final lastName = map['lastName'] as String? ?? '';
    final computedFullName = map['fullName'] as String? ??
        (firstName.isNotEmpty || lastName.isNotEmpty
            ? '$firstName $lastName'.trim()
            : '');

    String roleStr = 'STUDENT';
    if (map['role'] != null) {
      roleStr = map['role'] as String;
    } else if (map['roles'] != null &&
        map['roles'] is List &&
        (map['roles'] as List).isNotEmpty) {
      roleStr = (map['roles'] as List).first.toString();
    }

    return UserModel(
      id: map['userId'] as String? ?? map['id'] as String? ?? '',
      email: map['email'] as String? ?? '',
      fullName: computedFullName,
      role: roleStr,
      isEmailVerified: map['isEmailVerified'] as bool? ?? false,
      avatarUrl: map['avatarUrl'] as String?,
      createdAt: map['createdAt'] != null
          ? DateTime.parse(map['createdAt'] as String)
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': id,
      'email': email,
      'fullName': fullName,
      'role': role,
      'isEmailVerified': isEmailVerified,
      'avatarUrl': avatarUrl,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  UserEntity toDomain() {
    return UserEntity(
      id: id,
      email: email,
      fullName: fullName,
      role: role,
      isEmailVerified: isEmailVerified,
      avatarUrl: avatarUrl,
      createdAt: createdAt,
    );
  }
}
