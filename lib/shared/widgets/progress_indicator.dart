import 'package:flutter/material.dart';

/// Reusable Progress Indicator widget.
class AppProgressIndicator extends StatelessWidget {
  final double? value;

  const AppProgressIndicator({super.key, this.value});

  @override
  Widget build(BuildContext context) {
    return CircularProgressIndicator(value: value);
  }
}
