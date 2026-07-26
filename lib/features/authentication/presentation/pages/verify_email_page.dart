import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../router/route_names.dart';
import '../../../../shared/widgets/primary_button.dart';
import '../../../../shared/widgets/snackbar_manager.dart';
import '../bloc/authentication_bloc.dart';
import '../bloc/authentication_event.dart';
import '../bloc/authentication_state.dart';
import '../widgets/app_logo.dart';
import '../widgets/auth_card.dart';
import '../widgets/auth_header.dart';
import '../widgets/auth_scaffold.dart';

class VerifyEmailPage extends StatefulWidget {
  final String token;

  const VerifyEmailPage({super.key, required this.token});

  @override
  State<VerifyEmailPage> createState() => _VerifyEmailPageState();
}

class _VerifyEmailPageState extends State<VerifyEmailPage> {
  @override
  void initState() {
    super.initState();
    context.read<AuthenticationBloc>().add(VerifyEmailRequestedEvent(token: widget.token));
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthenticationBloc, AuthenticationState>(
      listener: (context, state) {
        if (state is EmailVerificationSuccessState) {
          SnackBarManager.showSuccess(context, 'Email verified! Redirecting to Dashboard...');
          context.go(RouteNames.dashboard);
        } else if (state is AuthFailureState) {
          SnackBarManager.showError(context, state.message);
        }
      },
      builder: (context, state) {
        final isLoading = state is AuthLoadingState;

        return AuthScaffold(
          child: Column(
            children: [
              const AppLogo(size: 80),
              const SizedBox(height: 16),
              const AuthHeader(
                title: 'Verifying Email',
                subtitle: 'Please wait while we validate your email address token',
              ),
              const SizedBox(height: 24),
              AuthCard(
                child: Column(
                  children: [
                    if (isLoading) ...[
                      const CircularProgressIndicator(),
                      const SizedBox(height: 16),
                      Text('Validating verification token...', style: Theme.of(context).textTheme.bodyMedium),
                    ] else ...[
                      Icon(
                        state is AuthFailureState ? Icons.error_outline : Icons.check_circle_outline,
                        size: 64,
                        color: state is AuthFailureState
                            ? Theme.of(context).colorScheme.error
                            : Colors.green,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        state is AuthFailureState
                            ? state.message
                            : 'Verification Complete!',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      const SizedBox(height: 24),
                      PrimaryButton(
                        label: 'Continue to Sign In',
                        onPressed: () => context.go(RouteNames.login),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
