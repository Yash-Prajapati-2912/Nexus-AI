import 'package:flutter/material.dart';

class AppOtpField extends StatelessWidget {
  final int length;
  final ValueChanged<String> onChanged;

  const AppOtpField({
    super.key,
    this.length = 6,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: List.generate(
        length,
        (index) => SizedBox(
          width: 48,
          child: TextField(
            textAlign: TextAlign.center,
            keyboardType: TextInputType.number,
            maxLength: 1,
            decoration: const InputDecoration(counterText: ''),
            onChanged: (val) {
              if (val.isNotEmpty && index < length - 1) {
                FocusScope.of(context).nextFocus();
              }
            },
          ),
        ),
      ),
    );
  }
}
