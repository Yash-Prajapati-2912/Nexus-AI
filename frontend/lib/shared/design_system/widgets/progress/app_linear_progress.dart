import 'package:flutter/material.dart';

class AppLinearProgress extends StatelessWidget {
  final double? value;

  const AppLinearProgress({super.key, this.value});

  @override
  Widget build(BuildContext context) {
    return LinearProgressIndicator(
      value: value,
      borderRadius: BorderRadius.circular(4),
    );
  }
}
