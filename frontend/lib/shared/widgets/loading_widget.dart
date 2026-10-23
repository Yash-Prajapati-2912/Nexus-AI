import 'package:flutter/material.dart';
import 'nexus_loading_widget.dart';

/// 2026 Contextual Loading Widget with subtle Nexus AI visual identity.
class LoadingWidget extends StatelessWidget {
  final String? message;
  final bool isAiLoading;

  const LoadingWidget({
    super.key,
    this.message,
    this.isAiLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return NexusLoadingWidget(
      message: message ?? 'Loading...',
    );
  }
}
