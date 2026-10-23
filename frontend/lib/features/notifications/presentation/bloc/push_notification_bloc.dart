import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nexus_ai/core/error/failures.dart';
import '../../domain/usecases/register_fcm_token_usecase.dart';

abstract class PushNotificationEvent extends Equatable {
  const PushNotificationEvent();
  @override
  List<Object?> get props => [];
}

class RegisterFCMTokenEvent extends PushNotificationEvent {
  final String deviceId;
  final String token;
  final String platform;

  const RegisterFCMTokenEvent({
    required this.deviceId,
    required this.token,
    required this.platform,
  });

  @override
  List<Object?> get props => [deviceId, token, platform];
}

class ReceivePushMessageEvent extends PushNotificationEvent {
  final Map<String, dynamic> payload;
  const ReceivePushMessageEvent(this.payload);
  @override
  List<Object?> get props => [payload];
}

class HandleNotificationTapEvent extends PushNotificationEvent {
  final String? deepLinkUrl;
  const HandleNotificationTapEvent(this.deepLinkUrl);
  @override
  List<Object?> get props => [deepLinkUrl];
}

abstract class PushNotificationState extends Equatable {
  const PushNotificationState();
  @override
  List<Object?> get props => [];
}

class PushNotificationInitialState extends PushNotificationState {
  const PushNotificationInitialState();
}

class PushTokenRegisteredState extends PushNotificationState {
  final String token;
  const PushTokenRegisteredState(this.token);
  @override
  List<Object?> get props => [token];
}

class PushNotificationReceivedState extends PushNotificationState {
  final Map<String, dynamic> payload;
  const PushNotificationReceivedState(this.payload);
  @override
  List<Object?> get props => [payload];
}

class PushNotificationNavigatedState extends PushNotificationState {
  final String deepLinkUrl;
  const PushNotificationNavigatedState(this.deepLinkUrl);
  @override
  List<Object?> get props => [deepLinkUrl];
}

class PushNotificationFailureState extends PushNotificationState {
  final String message;
  const PushNotificationFailureState(this.message);
  @override
  List<Object?> get props => [message];
}

class PushNotificationBloc extends Bloc<PushNotificationEvent, PushNotificationState> {
  final RegisterFCMTokenUseCase registerFCMTokenUseCase;

  PushNotificationBloc({required this.registerFCMTokenUseCase})
      : super(const PushNotificationInitialState()) {
    on<RegisterFCMTokenEvent>((event, emit) async {
      final res = await registerFCMTokenUseCase(RegisterFCMTokenParams(
        deviceId: event.deviceId,
        token: event.token,
        platform: event.platform,
      ));
      res.fold(
        (Failure f) => emit(PushNotificationFailureState(f.message)),
        (_) => emit(PushTokenRegisteredState(event.token)),
      );
    });

    on<ReceivePushMessageEvent>((event, emit) {
      emit(PushNotificationReceivedState(event.payload));
    });

    on<HandleNotificationTapEvent>((event, emit) {
      if (event.deepLinkUrl != null && event.deepLinkUrl!.isNotEmpty) {
        emit(PushNotificationNavigatedState(event.deepLinkUrl!));
      }
    });
  }
}
