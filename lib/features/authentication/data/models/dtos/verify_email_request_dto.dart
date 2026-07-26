class VerifyEmailRequestDto {
  final String token;

  const VerifyEmailRequestDto({required this.token});

  Map<String, dynamic> toJson() {
    return {
      'token': token,
    };
  }
}
