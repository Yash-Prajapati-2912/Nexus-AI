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
import '../widgets/auth_footer.dart';
import '../widgets/auth_header.dart';
import '../widgets/auth_scaffold.dart';
import '../widgets/loading_overlay.dart';
import '../widgets/terms_checkbox.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _agreeTerms = false;
  bool _obscurePassword = true;

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _onRegisterSubmitted() {
    if (!_agreeTerms) {
      SnackBarManager.showError(context, 'Please accept the Terms of Service');
      return;
    }

    if (_formKey.currentState?.validate() ?? false) {
      context.read<AuthenticationBloc>().add(
            RegisterRequestedEvent(
              fullName: _fullNameController.text.trim(),
              email: _emailController.text.trim(),
              password: _passwordController.text,
            ),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthenticationBloc, AuthenticationState>(
      listener: (context, state) {
        if (state is AuthenticatedState) {
          context.go(RouteNames.dashboard);
        } else if (state is EmailVerificationPendingState) {
          context.go(RouteNames.dashboard);
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
                  title: 'Create Account',
                  subtitle: 'Join Nexus AI OS today',
                ),
                const SizedBox(height: 24),
                AuthCard(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        CustomTextField(
                          controller: _fullNameController,
                          label: 'Full Name',
                          hint: 'Enter your full name',
                          prefixIcon: const Icon(Icons.person_outline),
                          validator: (val) => Validators.required(val, message: 'Full Name is required'),
                        ),
                        const SizedBox(height: 16),
                        CustomTextField(
                          controller: _emailController,
                          label: 'Email Address',
                          hint: 'Enter your email',
                          keyboardType: TextInputType.emailAddress,
                          prefixIcon: const Icon(Icons.email_outlined),
                          validator: Validators.email,
                        ),
                        const SizedBox(height: 16),
                        CustomTextField(
                          controller: _passwordController,
                          label: 'Password',
                          hint: 'Enter your password',
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
                          label: 'Confirm Password',
                          hint: 'Re-enter your password',
                          obscureText: _obscurePassword,
                          prefixIcon: const Icon(Icons.lock_reset_outlined),
                          validator: (val) {
                            if (val != _passwordController.text) {
                              return 'Passwords do not match';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        TermsCheckbox(
                          value: _agreeTerms,
                          onChanged: (val) => setState(() => _agreeTerms = val ?? false),
                        ),
                        const SizedBox(height: 24),
                        PrimaryButton(
                          label: 'Create Account',
                          isLoading: isLoading,
                          onPressed: _onRegisterSubmitted,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                AuthFooter(
                  text: 'Already have an account?',
                  actionLabel: 'Sign In',
                  onActionTap: () => context.go(RouteNames.login),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
