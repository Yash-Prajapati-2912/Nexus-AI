import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../router/route_names.dart';
import '../../../../shared/widgets/custom_text_field.dart';
import '../../../../shared/widgets/primary_button.dart';
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

class ResetPasswordPage extends StatefulWidget {
  final String token;

  const ResetPasswordPage({super.key, required this.token});

  @override
  State<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _onResetSubmitted() {
    if (_formKey.currentState?.validate() ?? false) {
      context.read<AuthenticationBloc>().add(
            ResetPasswordRequestedEvent(
              token: widget.token,
              newPassword: _newPasswordController.text,
            ),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthenticationBloc, AuthenticationState>(
      listener: (context, state) {
        if (state is PasswordResetSuccessState) {
          SnackBarManager.showSuccess(context, 'Password successfully updated! Please log in.');
          context.go(RouteNames.login);
        } else if (state is AuthFailureState) {
          SnackBarManager.showError(context, state.message);
        }
      },
      builder: (context, state) {
        final isLoading = state is AuthLoadingState;

        return AuthScaffold(
          child: LoadingOverlay(
            isLoading: isLoading,
            child: Column(
              children: [
                const AppLogo(size: 80),
                const SizedBox(height: 16),
                const AuthHeader(
                  title: 'Reset Password',
                  subtitle: 'Enter your new password below',
                ),
                const SizedBox(height: 24),
                AuthCard(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        CustomTextField(
                          controller: _newPasswordController,
                          label: 'New Password',
                          obscureText: _obscurePassword,
                          prefixIcon: const Icon(Icons.lock_outline),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscurePassword
                                  ? Icons.visibility_off_outlined
                                  : Icons.visibility_outlined,
                            ),
                            onPressed: () {
                              setState(() {
                                _obscurePassword = !_obscurePassword;
                              });
                            },
                          ),
                          validator: (val) => Validators.password(val, minLength: 8),
                        ),
                        const SizedBox(height: 16),
                        CustomTextField(
                          controller: _confirmPasswordController,
                          label: 'Confirm New Password',
                          obscureText: _obscurePassword,
                          prefixIcon: const Icon(Icons.lock_reset_outlined),
                          validator: (val) {
                            if (val != _newPasswordController.text) {
                              return 'Passwords do not match';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 24),
                        PrimaryButton(
                          label: 'Update Password',
                          isLoading: isLoading,
                          onPressed: _onResetSubmitted,
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
