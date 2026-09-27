import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../router/route_names.dart';
import '../../../../shared/branding/nexus_logo.dart';
import '../bloc/authentication_bloc.dart';
import '../bloc/authentication_event.dart';
import '../bloc/authentication_state.dart';

/// Splash Page restoring active user session or routing to Onboarding/Login.
class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    context.read<AuthenticationBloc>().add(AppStartedEvent());
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return BlocListener<AuthenticationBloc, AuthenticationState>(
      listener: (context, state) {
        if (state is AuthenticatedState) {
          context.go(RouteNames.dashboard);
        } else if (state is EmailVerificationPendingState) {
          context.go(RouteNames.emailVerificationPending, extra: state.email);
        } else if (state is UnauthenticatedState) {
          context.go(RouteNames.onboarding);
        }
      },
      child: Scaffold(
        backgroundColor: isDark ? const Color(0xFF0B0D12) : const Color(0xFFF8FAFC),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // 1. NEXUS SYMBOL (appears first)
              NexusLogoMark(
                size: 96,
                isDark: isDark,
              ),
              const SizedBox(height: 28),

              // 2. NEXUS AI WORDMARK + TAGLINE
              NexusLogo(
                variant: LogoVariant.wordmarkOnly,
                fontSize: 28,
                showTagline: true,
                logoTheme: isDark ? LogoTheme.dark : LogoTheme.light,
              ),
              const SizedBox(height: 54),

              // 3. Minimal Progress Indicator
              const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF7C6CFF)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
