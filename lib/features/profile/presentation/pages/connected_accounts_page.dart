import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/connected_account.dart';
import '../bloc/profile_bloc.dart';
import '../widgets/connected_account_tile.dart';

class ConnectedAccountsPage extends StatefulWidget {
  const ConnectedAccountsPage({super.key});

  @override
  State<ConnectedAccountsPage> createState() => _ConnectedAccountsPageState();
}

class _ConnectedAccountsPageState extends State<ConnectedAccountsPage> {
  final Set<String> _connectedProviders = {'GOOGLE'};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Connected Accounts')),
      body: BlocBuilder<ProfileBloc, ProfileState>(
        builder: (context, state) {
          final userEmail = (state is ProfileLoadedState && state.profile.email.isNotEmpty)
              ? state.profile.email
              : 'Google Account';

          final accounts = [
            ConnectedAccount(
              provider: 'GOOGLE',
              accountName: userEmail,
              isConnected: _connectedProviders.contains('GOOGLE'),
              linkedAt: DateTime.now(),
            ),
            ConnectedAccount(
              provider: 'GITHUB',
              accountName: 'GitHub Account',
              isConnected: _connectedProviders.contains('GITHUB'),
            ),
            ConnectedAccount(
              provider: 'APPLE',
              accountName: 'Apple ID',
              isConnected: _connectedProviders.contains('APPLE'),
            ),
            ConnectedAccount(
              provider: 'MICROSOFT',
              accountName: 'Microsoft Account',
              isConnected: _connectedProviders.contains('MICROSOFT'),
            ),
          ];

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: accounts.length,
            itemBuilder: (context, index) {
              final acc = accounts[index];
              return ConnectedAccountTile(
                account: acc,
                onToggle: () {
                  final isCurrentlyConnected = _connectedProviders.contains(acc.provider);
                  setState(() {
                    if (isCurrentlyConnected) {
                      _connectedProviders.remove(acc.provider);
                    } else {
                      _connectedProviders.add(acc.provider);
                    }
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        '${acc.provider} ${isCurrentlyConnected ? "disconnected" : "connected"}!',
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
