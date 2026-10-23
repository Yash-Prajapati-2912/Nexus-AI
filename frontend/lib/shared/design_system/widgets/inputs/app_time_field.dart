import 'package:flutter/material.dart';

class AppTimeField extends StatelessWidget {
  final TimeOfDay? selectedTime;
  final String label;
  final ValueChanged<TimeOfDay> onTimeSelected;

  const AppTimeField({
    super.key,
    required this.selectedTime,
    this.label = 'Select Time',
    required this.onTimeSelected,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        final picked = await showTimePicker(
          context: context,
          initialTime: selectedTime ?? TimeOfDay.now(),
        );
        if (picked != null) onTimeSelected(picked);
      },
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: const Icon(Icons.access_time_rounded),
        ),
        child: Text(
          selectedTime != null
              ? selectedTime!.format(context)
              : 'Tap to select time',
        ),
      ),
    );
  }
}
