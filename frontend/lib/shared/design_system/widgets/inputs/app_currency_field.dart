import 'package:flutter/material.dart';
import 'app_text_field.dart';

class AppCurrencyField extends StatelessWidget {
  final TextEditingController controller;
  final String currencySymbol;

  const AppCurrencyField({
    super.key,
    required this.controller,
    this.currencySymbol = '₹',
  });

  @override
  Widget build(BuildContext context) {
    return AppTextField(
      controller: controller,
      label: 'Amount',
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      prefixIcon: Padding(
        padding: const EdgeInsets.all(14.0),
        child: Text(
          currencySymbol,
          style: Theme.of(context).textTheme.titleMedium,
        ),
      ),
    );
  }
}
