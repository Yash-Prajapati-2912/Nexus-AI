import 'package:flutter/material.dart';
import 'app_base_bottom_sheet.dart';

class MediaPickerBottomSheet extends StatelessWidget {
  final VoidCallback onCameraTap;
  final VoidCallback onGalleryTap;

  const MediaPickerBottomSheet({
    super.key,
    required this.onCameraTap,
    required this.onGalleryTap,
  });

  @override
  Widget build(BuildContext context) {
    return AppBaseBottomSheet(
      title: 'Select Media Source',
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          IconButton.filledTonal(
            iconSize: 32,
            icon: const Icon(Icons.camera_alt_rounded),
            onPressed: () {
              Navigator.of(context).pop();
              onCameraTap();
            },
          ),
          IconButton.filledTonal(
            iconSize: 32,
            icon: const Icon(Icons.photo_library_rounded),
            onPressed: () {
              Navigator.of(context).pop();
              onGalleryTap();
            },
          ),
        ],
      ),
    );
  }
}
