import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../router/route_names.dart';
import '../../../../shared/widgets/primary_button.dart';
import '../widgets/app_logo.dart';
import '../widgets/auth_card.dart';
import '../widgets/auth_header.dart';
import '../widgets/auth_scaffold.dart';

class SessionExpiredPage extends StatelessWidget {
  const SessionExpiredPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AuthScaffold(
      child: Column(
        children: [
          const AppLogo(size: 80),
          const SizedBox(height: 16),
          const AuthHeader(
            title: 'Session Expired',
            subtitle: 'Your security token has expired. Please re-authenticate.',
          ),
          const SizedBox(height: 24),
          AuthCard(
            child: Column(
              children: [
                Icon(
                  Icons.timer_off_outlined,
                  size: 64,
                  color: Theme.of(context).colorScheme.error,
                ),
                const SizedBox(height: 16),
                Text(
                  'For your privacy and security, sessions expire after inactivity. Please sign in again to resume.',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 24),
                PrimaryButton(
                  label: 'Re-authenticate Now',
                  onPressed: () => context.go(RouteNames.login),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
