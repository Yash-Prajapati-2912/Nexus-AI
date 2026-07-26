import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../router/route_names.dart';
import '../../../../shared/widgets/custom_text_field.dart';
import '../../../../shared/widgets/primary_button.dart';
import '../../../../shared/widgets/secondary_button.dart';
import '../../../../shared/widgets/snackbar_manager.dart';
import '../../../../utils/validators.dart';
import '../bloc/authentication_bloc.dart';
import '../bloc/authentication_event.dart';
import '../bloc/authentication_state.dart';
import '../widgets/app_logo.dart';
import '../widgets/auth_card.dart';
import '../widgets/auth_header.dart';
import '../widgets/auth_scaffold.dart';
import '../widgets/loading_overlay.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void _onResetSubmitted() {
    if (_formKey.currentState?.validate() ?? false) {
      context.read<AuthenticationBloc>().add(
            ForgotPasswordRequestedEvent(email: _emailController.text.trim()),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthenticationBloc, AuthenticationState>(
      listener: (context, state) {
        if (state is PasswordResetSentState) {
          SnackBarManager.showSuccess(context, 'Password reset link sent to your email!');
        } else if (state is AuthFailureState) {
          SnackBarManager.showError(context, state.message);
        }
      },
      builder: (context, state) {
        final isLoading = state is AuthLoadingState;
        final isSent = state is PasswordResetSentState;

        return AuthScaffold(
          child: LoadingOverlay(
            isLoading: isLoading,
            child: Column(
              children: [
                const AppLogo(size: 80),
                const SizedBox(height: 16),
                AuthHeader(
                  title: isSent ? 'Check Your Email' : 'Forgot Password?',
                  subtitle: isSent
                      ? 'We have dispatched password reset instructions to ${_emailController.text}'
                      : 'Enter your email address to receive password reset link',
                ),
                const SizedBox(height: 24),
                AuthCard(
                  child: isSent
                      ? Column(
                          children: [
                            Icon(
                              Icons.mark_email_read_outlined,
                              size: 64,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Please check your inbox and follow instructions to reset your password.',
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                            const SizedBox(height: 24),
                            PrimaryButton(
                              label: 'Back to Login',
                              onPressed: () => context.go(RouteNames.login),
                            ),
                          ],
                        )
                      : Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              CustomTextField(
                                controller: _emailController,
                                label: 'Email Address',
                                hint: 'student@university.edu',
                                keyboardType: TextInputType.emailAddress,
                                prefixIcon: const Icon(Icons.email_outlined),
                                validator: Validators.email,
                              ),
                              const SizedBox(height: 24),
                              PrimaryButton(
                                label: 'Send Reset Link',
                                isLoading: isLoading,
                                onPressed: _onResetSubmitted,
                              ),
                              const SizedBox(height: 12),
                              SecondaryButton(
                                label: 'Cancel',
                                onPressed: () => context.pop(),
                              ),
                            ],
                          ),
                        ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
