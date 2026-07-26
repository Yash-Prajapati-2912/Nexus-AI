import 'package:flutter/material.dart';

class DeleteAccountPage extends StatefulWidget {
  const DeleteAccountPage({super.key});

  @override
  State<DeleteAccountPage> createState() => _DeleteAccountPageState();
}

class _DeleteAccountPageState extends State<DeleteAccountPage> {
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
                Text('Permanent Account Deletion', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.redAccent)),
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
                  backgroundColor: _confirmed ? Colors.redAccent : Colors.grey,
                  foregroundColor: Colors.white,
                ),
                onPressed: _confirmed
                    ? () {
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Account deletion initiated')));
                        Navigator.pop(context);
                      }
                    : null,
                child: const Text('Permanently Delete My Account'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
