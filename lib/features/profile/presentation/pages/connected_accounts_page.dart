import 'package:flutter/material.dart';
import '../../domain/entities/connected_account.dart';
import '../widgets/connected_account_tile.dart';

class ConnectedAccountsPage extends StatefulWidget {
  const ConnectedAccountsPage({super.key});

  @override
  State<ConnectedAccountsPage> createState() => _ConnectedAccountsPageState();
}

class _ConnectedAccountsPageState extends State<ConnectedAccountsPage> {
  final List<ConnectedAccount> _accounts = [
    ConnectedAccount(provider: 'GOOGLE', accountName: 'alex.rivers@gmail.com', isConnected: true, linkedAt: DateTime.now()),
    const ConnectedAccount(provider: 'GITHUB', accountName: 'alexrivers', isConnected: true),
    const ConnectedAccount(provider: 'APPLE', accountName: 'Apple ID', isConnected: false),
    const ConnectedAccount(provider: 'MICROSOFT', accountName: 'Outlook', isConnected: false),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Connected Accounts')),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _accounts.length,
        itemBuilder: (context, index) {
          final acc = _accounts[index];
          return ConnectedAccountTile(
            account: acc,
            onToggle: () {
              setState(() {
                _accounts[index] = ConnectedAccount(
                  provider: acc.provider,
                  accountName: acc.accountName,
                  isConnected: !acc.isConnected,
                );
              });
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${acc.provider} account updated!')));
            },
          );
        },
      ),
    );
  }
}
