import 'package:flutter/material.dart';
import '../../../../theme/design_tokens/colors.dart';

/// 2026 Futuristic Authentication Scaffold with Dual-Theme Ambient Mesh Backdrop.
class AuthScaffold extends StatelessWidget {
  final Widget child;

  const AuthScaffold({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = isDark ? DesignColors.backgroundDark : DesignColors.backgroundLight;

    final purpleMeshColor = isDark ? DesignColors.meshPurpleDark : DesignColors.meshPurpleLight;
    final cyanMeshColor = isDark ? DesignColors.meshCyanDark : DesignColors.meshCyanLight;

    return Scaffold(
      backgroundColor: backgroundColor,
      body: Stack(
        children: [
          // Top-right ambient purple mesh spot
          Positioned(
            top: -100,
            right: -100,
            child: Container(
              width: 320,
              height: 320,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: purpleMeshColor,
              ),
            ),
          ),

          // Bottom-left ambient cyan mesh spot
          Positioned(
            bottom: -100,
            left: -100,
            child: Container(
              width: 320,
              height: 320,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: cyanMeshColor,
              ),
            ),
          ),

          // Main scrollable content
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 24.0),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 450),
                  child: child,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

