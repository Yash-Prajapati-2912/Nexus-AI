import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/services/connectivity_service.dart';

// Connectivity Events
abstract class ConnectivityEvent extends Equatable {
  const ConnectivityEvent();

  @override
  List<Object?> get props => [];
}

class ConnectivityStatusChangedEvent extends ConnectivityEvent {
  final bool isConnected;
  const ConnectivityStatusChangedEvent(this.isConnected);

  @override
  List<Object?> get props => [isConnected];
}

// Connectivity States
abstract class ConnectivityState extends Equatable {
  const ConnectivityState();

  @override
  List<Object?> get props => [];
}

class ConnectivityInitialState extends ConnectivityState {}
class ConnectivityConnectedState extends ConnectivityState {}
class ConnectivityDisconnectedState extends ConnectivityState {}

// Connectivity BLoC
class ConnectivityBloc extends Bloc<ConnectivityEvent, ConnectivityState> {
  final ConnectivityService _connectivityService;
  StreamSubscription<bool>? _subscription;

  ConnectivityBloc(this._connectivityService) : super(ConnectivityInitialState()) {
    on<ConnectivityStatusChangedEvent>((event, emit) {
      if (event.isConnected) {
        emit(ConnectivityConnectedState());
      } else {
        emit(ConnectivityDisconnectedState());
      }
    });

    _subscription = _connectivityService.onConnectivityChanged.listen((isConnected) {
      add(ConnectivityStatusChangedEvent(isConnected));
    });
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
