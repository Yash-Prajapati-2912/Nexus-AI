import 'package:flutter/material.dart';
import '../../../widgets/snackbar_manager.dart';

abstract class AppSnackBar {
  static void showSuccess(BuildContext context, String message) {
    SnackBarManager.showSuccess(context, message);
  }

  static void showError(BuildContext context, String message) {
    SnackBarManager.showError(context, message);
  }

  static void showInfo(BuildContext context, String message) {
    SnackBarManager.showInfo(context, message);
  }

  static void showWarning(BuildContext context, String message) {
    SnackBarManager.showWarning(context, message);
  }
}
