import 'package:flutter/material.dart';
import '../../domain/entities/connected_account.dart';

class ConnectedAccountTile extends StatelessWidget {
  final ConnectedAccount account;
  final VoidCallback onToggle;

  const ConnectedAccountTile({
    super.key,
    required this.account,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    final isConnected = account.isConnected;

    return ListTile(
      leading: CircleAvatar(
        backgroundColor: Colors.transparent,
        child: Icon(_getProviderIcon(account.provider), size: 24),
      ),
      title: Text(account.provider, style: const TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text(isConnected ? account.accountName : 'Not linked'),
      trailing: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: isConnected ? Colors.redAccent.withAlpha(20) : null,
          foregroundColor: isConnected ? Colors.redAccent : null,
        ),
        onPressed: onToggle,
        child: Text(isConnected ? 'Unlink' : 'Link'),
      ),
    );
  }

  IconData _getProviderIcon(String provider) {
    switch (provider.toUpperCase()) {
      case 'GOOGLE':
        return Icons.g_mobiledata_rounded;
      case 'APPLE':
        return Icons.apple_rounded;
      case 'GITHUB':
        return Icons.code_rounded;
      case 'MICROSOFT':
        return Icons.window_rounded;
      default:
        return Icons.account_circle_rounded;
    }
  }
}
