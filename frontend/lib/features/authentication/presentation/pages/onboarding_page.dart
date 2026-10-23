import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../router/route_names.dart';
import '../../../../shared/branding/nexus_feature_icon.dart';
import '../../../../shared/branding/nexus_logo.dart';
import '../../../../shared/widgets/primary_button.dart';
import '../../../../shared/widgets/secondary_button.dart';
import '../widgets/auth_scaffold.dart';

class OnboardingSlide {
  final String title;
  final String description;
  final NexusFeatureModule module;

  const OnboardingSlide({
    required this.title,
    required this.description,
    required this.module,
  });
}

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final PageController _controller = PageController();
  int _currentIndex = 0;

  final List<OnboardingSlide> _slides = const [
    OnboardingSlide(
      title: 'Smart Academic Planning',
      description: 'Synthesize your assignments, exam deadlines, and daily schedule automatically.',
      module: NexusFeatureModule.academics,
    ),
    OnboardingSlide(
      title: 'AI Financial Advisor',
      description: 'Keep your personal budget on track with real-time financial health alerts.',
      module: NexusFeatureModule.finance,
    ),
    OnboardingSlide(
      title: '24/7 AI Academic Mentor',
      description: 'Get instant tutoring, writing assistance, and study guidance whenever you need it.',
      module: NexusFeatureModule.aiNexus,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return AuthScaffold(
      child: Column(
        children: [
          const SizedBox(height: 12),
          // Top Nexus Ecosystem Logo
          NexusLogo(
            variant: LogoVariant.ecosystem,
            markSize: 85,
            logoTheme: isDark ? LogoTheme.dark : LogoTheme.light,
          ),
          const SizedBox(height: 24),
          SizedBox(
            height: 320,
            child: PageView.builder(
              controller: _controller,
              itemCount: _slides.length,
              onPageChanged: (index) => setState(() => _currentIndex = index),
              itemBuilder: (context, index) {
                final slide = _slides[index];
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    NexusFeatureIcon(
                      module: slide.module,
                      size: 48,
                      showContainer: true,
                    ),
                    const SizedBox(height: 24),
                    Text(
                      slide.title,
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      slide.description,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                );
              },
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              _slides.length,
              (index) => AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                margin: const EdgeInsets.symmetric(horizontal: 4),
                width: _currentIndex == index ? 24 : 8,
                height: 8,
                decoration: BoxDecoration(
                  color: _currentIndex == index
                      ? const Color(0xFF7C6CFF)
                      : Theme.of(context).colorScheme.outlineVariant,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
          ),
          const SizedBox(height: 32),
          PrimaryButton(
            label: 'Get Started',
            onPressed: () => context.go(RouteNames.register),
          ),
          const SizedBox(height: 12),
          SecondaryButton(
            label: 'Already have an account? Sign In',
            onPressed: () => context.go(RouteNames.login),
          ),
        ],
      ),
    );
  }
}
