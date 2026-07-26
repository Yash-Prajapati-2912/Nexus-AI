import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/usecases/usecase.dart';
import '../../domain/usecases/forgot_password_usecase.dart';
import '../../domain/usecases/load_current_user_usecase.dart';
import '../../domain/usecases/login_usecase.dart';
import '../../domain/usecases/logout_all_usecase.dart';
import '../../domain/usecases/logout_usecase.dart';
import '../../domain/usecases/register_usecase.dart';
import '../../domain/usecases/resend_verification_usecase.dart';
import '../../domain/usecases/reset_password_usecase.dart';
import '../../domain/usecases/verify_email_usecase.dart';
import 'authentication_event.dart';
import 'authentication_state.dart';

class AuthenticationBloc extends Bloc<AuthenticationEvent, AuthenticationState> {
  final LoginUseCase _loginUseCase;
  final RegisterUseCase _registerUseCase;
  final LogoutUseCase _logoutUseCase;
  final LogoutAllUseCase _logoutAllUseCase;
  final ForgotPasswordUseCase _forgotPasswordUseCase;
  final ResetPasswordUseCase _resetPasswordUseCase;
  final VerifyEmailUseCase _verifyEmailUseCase;
  final ResendVerificationUseCase _resendVerificationUseCase;
  final LoadCurrentUserUseCase _loadCurrentUserUseCase;

  AuthenticationBloc({
    required LoginUseCase loginUseCase,
    required RegisterUseCase registerUseCase,
    required LogoutUseCase logoutUseCase,
    required LogoutAllUseCase logoutAllUseCase,
    required ForgotPasswordUseCase forgotPasswordUseCase,
    required ResetPasswordUseCase resetPasswordUseCase,
    required VerifyEmailUseCase verifyEmailUseCase,
    required ResendVerificationUseCase resendVerificationUseCase,
    required LoadCurrentUserUseCase loadCurrentUserUseCase,
  })  : _loginUseCase = loginUseCase,
        _registerUseCase = registerUseCase,
        _logoutUseCase = logoutUseCase,
        _logoutAllUseCase = logoutAllUseCase,
        _forgotPasswordUseCase = forgotPasswordUseCase,
        _resetPasswordUseCase = resetPasswordUseCase,
        _verifyEmailUseCase = verifyEmailUseCase,
        _resendVerificationUseCase = resendVerificationUseCase,
        _loadCurrentUserUseCase = loadCurrentUserUseCase,
        super(AuthInitialState()) {
    on<AppStartedEvent>(_onAppStarted);
    on<LoginRequestedEvent>(_onLoginRequested);
    on<RegisterRequestedEvent>(_onRegisterRequested);
    on<LogoutRequestedEvent>(_onLogoutRequested);
    on<LogoutAllRequestedEvent>(_onLogoutAllRequested);
    on<ForgotPasswordRequestedEvent>(_onForgotPasswordRequested);
    on<ResetPasswordRequestedEvent>(_onResetPasswordRequested);
    on<VerifyEmailRequestedEvent>(_onVerifyEmailRequested);
    on<ResendVerificationRequestedEvent>(_onResendVerificationRequested);
    on<LoadCurrentUserRequestedEvent>(_onLoadCurrentUserRequested);
  }

  Future<void> _onAppStarted(
    AppStartedEvent event,
    Emitter<AuthenticationState> emit,
  ) async {
    emit(AuthLoadingState());
    final userResult = await _loadCurrentUserUseCase(const NoParams());
    userResult.fold(
      (failure) => emit(UnauthenticatedState()),
      (user) {
        if (!user.isEmailVerified) {
          emit(EmailVerificationPendingState(email: user.email));
        } else {
          emit(AuthenticatedState(user: user));
        }
      },
    );
  }

  Future<void> _onLoginRequested(
    LoginRequestedEvent event,
    Emitter<AuthenticationState> emit,
  ) async {
    emit(AuthLoadingState());
    final loginResult = await _loginUseCase(
      LoginParams(email: event.email, password: event.password),
    );

    await loginResult.fold(
      (failure) async => emit(AuthFailureState(message: failure.message)),
      (tokens) async {
        final userResult = await _loadCurrentUserUseCase(const NoParams());
        userResult.fold(
          (failure) => emit(AuthFailureState(message: failure.message)),
          (user) {
            if (!user.isEmailVerified) {
              emit(EmailVerificationPendingState(email: user.email));
            } else {
              emit(AuthenticatedState(user: user));
            }
          },
        );
      },
    );
  }

  Future<void> _onRegisterRequested(
    RegisterRequestedEvent event,
    Emitter<AuthenticationState> emit,
  ) async {
    emit(AuthLoadingState());
    final result = await _registerUseCase(
      RegisterParams(
        email: event.email,
        password: event.password,
        fullName: event.fullName,
      ),
    );

    result.fold(
      (failure) => emit(AuthFailureState(message: failure.message)),
      (user) => emit(EmailVerificationPendingState(email: user.email)),
    );
  }

  Future<void> _onLogoutRequested(
    LogoutRequestedEvent event,
    Emitter<AuthenticationState> emit,
  ) async {
    emit(AuthLoadingState());
    await _logoutUseCase(const NoParams());
    emit(UnauthenticatedState());
  }

  Future<void> _onLogoutAllRequested(
    LogoutAllRequestedEvent event,
    Emitter<AuthenticationState> emit,
  ) async {
    emit(AuthLoadingState());
    await _logoutAllUseCase(const NoParams());
    emit(UnauthenticatedState());
  }

  Future<void> _onForgotPasswordRequested(
    ForgotPasswordRequestedEvent event,
    Emitter<AuthenticationState> emit,
  ) async {
    emit(AuthLoadingState());
    final result = await _forgotPasswordUseCase(
      ForgotPasswordParams(email: event.email),
    );

    result.fold(
      (failure) => emit(AuthFailureState(message: failure.message)),
      (_) => emit(PasswordResetSentState(email: event.email)),
    );
  }

  Future<void> _onResetPasswordRequested(
    ResetPasswordRequestedEvent event,
    Emitter<AuthenticationState> emit,
  ) async {
    emit(AuthLoadingState());
    final result = await _resetPasswordUseCase(
      ResetPasswordParams(token: event.token, newPassword: event.newPassword),
    );

    result.fold(
      (failure) => emit(AuthFailureState(message: failure.message)),
      (_) => emit(PasswordResetSuccessState()),
    );
  }

  Future<void> _onVerifyEmailRequested(
    VerifyEmailRequestedEvent event,
    Emitter<AuthenticationState> emit,
  ) async {
    emit(AuthLoadingState());
    final result = await _verifyEmailUseCase(
      VerifyEmailParams(token: event.token),
    );

    result.fold(
      (failure) => emit(AuthFailureState(message: failure.message)),
      (_) => emit(EmailVerificationSuccessState()),
    );
  }

  Future<void> _onResendVerificationRequested(
    ResendVerificationRequestedEvent event,
    Emitter<AuthenticationState> emit,
  ) async {
    emit(AuthLoadingState());
    final result = await _resendVerificationUseCase(
      ResendVerificationParams(email: event.email),
    );

    result.fold(
      (failure) => emit(AuthFailureState(message: failure.message)),
      (_) => emit(EmailVerificationPendingState(email: event.email)),
    );
  }

  Future<void> _onLoadCurrentUserRequested(
    LoadCurrentUserRequestedEvent event,
    Emitter<AuthenticationState> emit,
  ) async {
    final result = await _loadCurrentUserUseCase(const NoParams());
    result.fold(
      (failure) => emit(UnauthenticatedState()),
      (user) => emit(AuthenticatedState(user: user)),
    );
  }
}
