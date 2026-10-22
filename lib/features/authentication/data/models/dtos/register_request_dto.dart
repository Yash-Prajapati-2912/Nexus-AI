class RegisterRequestDto {
  final String email;
  final String password;
  final String fullName;

  const RegisterRequestDto({
    required this.email,
    required this.password,
    required this.fullName,
  });

  Map<String, dynamic> toJson() {
    final parts = fullName.trim().split(RegExp(r'\s+'));
    final firstName = parts.isNotEmpty && parts.first.isNotEmpty ? parts.first : 'User';
    final lastName = parts.length > 1 ? parts.sublist(1).join(' ') : 'Member';
    return {
      'email': email,
      'password': password,
      'firstName': firstName,
      'lastName': lastName,
    };
  }
}
