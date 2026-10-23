import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Centralized Navigation Service for programmatic routing without BuildContext.
class NavigationService {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  BuildContext? get currentContext => navigatorKey.currentContext;

  void go(String location, {Object? extra}) {
    if (currentContext != null) {
      GoRouter.of(currentContext!).go(location, extra: extra);
    }
  }

  void push(String location, {Object? extra}) {
    if (currentContext != null) {
      GoRouter.of(currentContext!).push(location, extra: extra);
    }
  }

  void pop<T extends Object?>([T? result]) {
    if (currentContext != null && GoRouter.of(currentContext!).canPop()) {
      GoRouter.of(currentContext!).pop(result);
    }
  }
}
