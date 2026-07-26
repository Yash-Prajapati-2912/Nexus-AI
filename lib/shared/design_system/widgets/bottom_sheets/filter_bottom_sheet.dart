import 'package:flutter/material.dart';
import 'app_base_bottom_sheet.dart';

class FilterBottomSheet extends StatelessWidget {
  final Widget filterOptions;
  final VoidCallback onApply;

  const FilterBottomSheet({
    super.key,
    required this.filterOptions,
    required this.onApply,
  });

  @override
  Widget build(BuildContext context) {
    return AppBaseBottomSheet(
      title: 'Filter Results',
      child: Column(
        children: [
          filterOptions,
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                onApply();
              },
              child: const Text('Apply Filters'),
            ),
          ),
        ],
      ),
    );
  }
}
