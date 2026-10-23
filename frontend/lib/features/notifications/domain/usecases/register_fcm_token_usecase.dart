import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import 'package:nexus_ai/core/error/failures.dart';
import 'package:nexus_ai/core/usecases/usecase.dart';
import '../repositories/i_notification_repository.dart';

class RegisterFCMTokenParams extends Equatable {
  final String deviceId;
  final String token;
  final String platform;

  const RegisterFCMTokenParams({
    required this.deviceId,
    required this.token,
    required this.platform,
  });

  @override
  List<Object?> get props => [deviceId, token, platform];
}

class RegisterFCMTokenUseCase implements UseCase<Unit, RegisterFCMTokenParams> {
  final INotificationRepository repository;

  RegisterFCMTokenUseCase(this.repository);

  @override
  Future<Either<Failure, Unit>> call(RegisterFCMTokenParams params) {
    return repository.registerDeviceToken(params.deviceId, params.token, params.platform);
  }
}
