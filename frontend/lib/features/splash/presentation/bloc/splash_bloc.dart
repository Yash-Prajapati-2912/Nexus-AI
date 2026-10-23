import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../../config/constants/app_constants.dart';

// Splash Events
abstract class SplashEvent extends Equatable {
  const SplashEvent();

  @override
  List<Object?> get props => [];
}

class SplashInitializedEvent extends SplashEvent {}

// Splash States
abstract class SplashState extends Equatable {
  const SplashState();

  @override
  List<Object?> get props => [];
}

class SplashInitialState extends SplashState {}
class SplashLoadingState extends SplashState {}
class SplashCompletedState extends SplashState {}

// Splash BLoC
class SplashBloc extends Bloc<SplashEvent, SplashState> {
  SplashBloc() : super(SplashInitialState()) {
    on<SplashInitializedEvent>((event, emit) async {
      emit(SplashLoadingState());
      await Future.delayed(AppConstants.splashDelay);
      emit(SplashCompletedState());
    });
  }
}
