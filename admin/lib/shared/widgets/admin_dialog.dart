import 'package:flutter/material.dart';

class AdminDialog extends StatelessWidget {
  final String title;
  final Widget content;
  final String confirmText;
  final VoidCallback onConfirm;

  const AdminDialog({
    super.key,
    required this.title,
    required this.content,
    this.confirmText = 'Confirm',
    required this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: SizedBox(
        width: 500,
        child: content,
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            onConfirm();
            Navigator.of(context).pop();
          },
          child: Text(confirmText),
        ),
      ],
    );
  }
}
