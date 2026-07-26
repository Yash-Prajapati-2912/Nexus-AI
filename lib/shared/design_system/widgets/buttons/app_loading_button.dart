import 'package:flutter/material.dart';
import 'app_primary_button.dart';

class AppLoadingButton extends StatelessWidget {
  final String label;
  final bool isLoading;
  final VoidCallback? onPressed;

  const AppLoadingButton({
    super.key,
    required this.label,
    required this.isLoading,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return AppPrimaryButton(
      label: label,
      isLoading: isLoading,
      onPressed: onPressed,
    );
  }
}
