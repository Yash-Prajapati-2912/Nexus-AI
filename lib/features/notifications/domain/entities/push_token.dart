import 'package:equatable/equatable.dart';

/// Domain entity representing an FCM registration token.
class PushToken extends Equatable {
  final String deviceId;
  final String token;
  final String platform; // ANDROID, IOS, WEB

  const PushToken({
    required this.deviceId,
    required this.token,
    required this.platform,
  });

  @override
  List<Object?> get props => [deviceId, token, platform];
}
