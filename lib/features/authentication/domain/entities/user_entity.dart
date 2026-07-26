import 'package:equatable/equatable.dart';

/// User Domain Entity.
class UserEntity extends Equatable {
  final String id;
  final String email;
  final String fullName;
  final String role;
  final bool isEmailVerified;
  final String? avatarUrl;
  final DateTime createdAt;

  const UserEntity({
    required this.id,
    required this.email,
    required this.fullName,
    required this.role,
    required this.isEmailVerified,
    this.avatarUrl,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [id, email, fullName, role, isEmailVerified, avatarUrl, createdAt];
}
