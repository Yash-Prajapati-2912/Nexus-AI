import 'package:flutter/material.dart';
import 'app_text_field.dart';

class AppEmailField extends StatelessWidget {
  final TextEditingController controller;

  const AppEmailField({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return AppTextField(
      controller: controller,
      label: 'Email',
      hint: 'you@domain.com',
      keyboardType: TextInputType.emailAddress,
      prefixIcon: const Icon(Icons.email_outlined),
    );
  }
}
