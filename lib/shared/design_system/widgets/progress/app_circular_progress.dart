import 'package:flutter/material.dart';

class AppCircularProgress extends StatelessWidget {
  final double? value;

  const AppCircularProgress({super.key, this.value});

  @override
  Widget build(BuildContext context) {
    return CircularProgressIndicator(value: value);
  }
}
