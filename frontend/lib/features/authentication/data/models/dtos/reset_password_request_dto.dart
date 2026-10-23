class ResetPasswordRequestDto {
  final String token;
  final String newPassword;

  const ResetPasswordRequestDto({
    required this.token,
    required this.newPassword,
  });

  Map<String, dynamic> toJson() {
    return {
      'token': token,
      'newPassword': newPassword,
    };
  }
}
