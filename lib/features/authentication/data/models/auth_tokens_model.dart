import '../../domain/entities/auth_tokens_entity.dart';

/// Auth Tokens Model.
class AuthTokensModel extends AuthTokensEntity {
  const AuthTokensModel({
    required super.accessToken,
    required super.refreshToken,
    required super.tokenType,
    required super.expiresIn,
  });

  factory AuthTokensModel.fromJson(Map<String, dynamic> json) {
    final map = json.containsKey('tokens') && json['tokens'] is Map<String, dynamic>
        ? json['tokens'] as Map<String, dynamic>
        : json;
    return AuthTokensModel(
      accessToken: map['accessToken'] as String? ?? '',
      refreshToken: map['refreshToken'] as String? ?? '',
      tokenType: map['tokenType'] as String? ?? 'Bearer',
      expiresIn: map['expiresIn'] as int? ?? 900,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'accessToken': accessToken,
      'refreshToken': refreshToken,
      'tokenType': tokenType,
      'expiresIn': expiresIn,
    };
  }

  AuthTokensEntity toDomain() {
    return AuthTokensEntity(
      accessToken: accessToken,
      refreshToken: refreshToken,
      tokenType: tokenType,
      expiresIn: expiresIn,
    );
  }
}
