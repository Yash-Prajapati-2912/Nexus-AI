import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../di/injection_container.dart';
import '../../../../router/route_names.dart';
import '../../../authentication/presentation/bloc/authentication_bloc.dart';
import '../../../authentication/presentation/bloc/authentication_event.dart';
import '../bloc/account_bloc.dart';

class DeleteAccountPage extends StatelessWidget {
  const DeleteAccountPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<AccountBloc>(),
      child: const _DeleteAccountView(),
    );
  }
}

class _DeleteAccountView extends StatefulWidget {
  const _DeleteAccountView();

  @override
  State<_DeleteAccountView> createState() => _DeleteAccountViewState();
}

class _DeleteAccountViewState extends State<_DeleteAccountView> {
  final TextEditingController _confirmController = TextEditingController();
  bool _confirmed = false;

  @override
  void dispose() {
    _confirmController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocConsumer<AccountBloc, AccountState>(
      listener: (context, state) {
        if (state is AccountLoadedState && state.isDeleted) {
          // Irreversible deletion confirmed by backend. Clear session credentials and redirect.
          context.read<AuthenticationBloc>().add(LogoutRequestedEvent());
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Your Nexus AI account has been permanently deleted.'),
              backgroundColor: Color(0xFF10B981),
            ),
          );
          context.go(RouteNames.login);
        } else if (state is AccountFailureState) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed to delete account: ${state.message}'),
              backgroundColor: theme.colorScheme.error,
            ),
          );
        }
      },
      builder: (context, state) {
        final isLoading = state is AccountLoadingState;

        return Scaffold(
          appBar: AppBar(title: const Text('Delete Account')),
          body: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(Icons.warning_amber_rounded, color: Colors.redAccent, size: 28),
                    SizedBox(width: 8),
                    Text(
                      'Permanent Account Deletion',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.redAccent),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  'Deleting your Nexus AI account will permanently remove all your Smart Planner tasks, Smart Finance logs, AI Mentor chat histories, achievements, and statistics. This action cannot be undone.',
                  style: theme.textTheme.bodyMedium,
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: _confirmController,
                  enabled: !isLoading,
                  decoration: const InputDecoration(
                    labelText: 'Type "DELETE" to confirm',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (val) {
                    setState(() {
                      _confirmed = val.trim().toUpperCase() == 'DELETE';
                    });
                  },
                ),
                const Spacer(),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: (_confirmed && !isLoading) ? Colors.redAccent : Colors.grey,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    onPressed: (_confirmed && !isLoading)
                        ? () {
                            context.read<AccountBloc>().add(const TriggerDeleteAccountEvent());
                          }
                        : null,
                    child: isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                          )
                        : const Text('Permanently Delete My Account'),
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
