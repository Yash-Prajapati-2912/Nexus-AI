import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../shared/branding/nexus_logo.dart';
import '../bloc/splash_bloc.dart';

/// Minimal Branded Splash Screen Page.
class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return BlocProvider(
      create: (context) => SplashBloc()..add(SplashInitializedEvent()),
      child: Scaffold(
        backgroundColor: isDark ? const Color(0xFF0B0D12) : const Color(0xFFF8FAFC),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // 1. NEXUS CONNECTED ECOSYSTEM LOGO LOCKUP
              NexusLogo(
                variant: LogoVariant.ecosystem,
                markSize: 100,
                logoTheme: isDark ? LogoTheme.dark : LogoTheme.light,
              ),
              const SizedBox(height: 54),

              // 3. Minimal Loading Indicator
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
