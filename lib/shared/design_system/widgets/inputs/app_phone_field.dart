import 'package:flutter/material.dart';
import 'app_text_field.dart';

class AppPhoneField extends StatelessWidget {
  final TextEditingController controller;

  const AppPhoneField({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return AppTextField(
      controller: controller,
      label: 'Phone Number',
      keyboardType: TextInputType.phone,
      prefixIcon: const Icon(Icons.phone_outlined),
    );
  }
}
