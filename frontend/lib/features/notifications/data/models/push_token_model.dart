import '../../domain/entities/push_token.dart';

class PushTokenModel extends PushToken {
  const PushTokenModel({
    required super.deviceId,
    required super.token,
    required super.platform,
  });

  factory PushTokenModel.fromJson(Map<String, dynamic> json) {
    return PushTokenModel(
      deviceId: json['deviceId'] as String? ?? '',
      token: json['token'] as String? ?? json['fcmToken'] as String? ?? '',
      platform: json['platform'] as String? ?? 'ANDROID',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'deviceId': deviceId,
      'token': token,
      'platform': platform,
    };
  }
}
