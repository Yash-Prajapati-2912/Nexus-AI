import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../router/route_names.dart';
import '../../../../shared/widgets/primary_button.dart';
import '../../../../shared/widgets/secondary_button.dart';
import '../../../../shared/widgets/snackbar_manager.dart';
import '../bloc/authentication_bloc.dart';
import '../bloc/authentication_event.dart';
import '../bloc/authentication_state.dart';
import '../widgets/app_logo.dart';
import '../widgets/auth_card.dart';
import '../widgets/auth_header.dart';
import '../widgets/auth_scaffold.dart';

class EmailVerificationPendingPage extends StatelessWidget {
  final String email;

  const EmailVerificationPendingPage({super.key, required this.email});

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthenticationBloc, AuthenticationState>(
      listener: (context, state) {
        if (state is AuthFailureState) {
          SnackBarManager.showError(context, state.message);
        }
      },
      child: AuthScaffold(
        child: Column(
          children: [
            const AppLogo(size: 80),
            const SizedBox(height: 16),
            const AuthHeader(
              title: 'Verify Your Email',
              subtitle: 'We sent a verification link to your email address',
            ),
            const SizedBox(height: 24),
            AuthCard(
              child: Column(
                children: [
                  Icon(
                    Icons.mark_email_unread_outlined,
                    size: 64,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Please check your inbox at $email and click the verification link to activate your Nexus AI account.',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 24),
                  PrimaryButton(
                    label: 'Continue to Dashboard',
                    onPressed: () {
                      context.read<AuthenticationBloc>().add(AppStartedEvent());
                      context.go(RouteNames.dashboard);
                    },
                  ),
                  const SizedBox(height: 12),
                  SecondaryButton(
                    label: 'Resend Verification Email',
                    onPressed: () {
                      context.read<AuthenticationBloc>().add(ResendVerificationRequestedEvent(email: email));
                      SnackBarManager.showSuccess(context, 'Verification email re-sent!');
                    },
                  ),
                  const SizedBox(height: 12),
                  SecondaryButton(
                    label: 'Back to Sign In',
                    onPressed: () {
                      context.read<AuthenticationBloc>().add(LogoutRequestedEvent());
                      context.go(RouteNames.login);
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
