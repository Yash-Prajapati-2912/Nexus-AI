import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../core/storage/session_manager.dart';
import 'route_names.dart';

/// Navigation Auth Guard directing unauthenticated users away from protected routes.
abstract class AuthGuard {
  static Future<String?> redirectGuard(
    BuildContext context,
    GoRouterState state,
    SessionManager sessionManager,
  ) async {
    final isAuthenticated = await sessionManager.isAuthenticated();
    final location = state.matchedLocation;

    final isPublicRoute = location == RouteNames.splash ||
        location == RouteNames.onboarding ||
        location == RouteNames.login ||
        location == RouteNames.register ||
        location == RouteNames.forgotPassword ||
        location == RouteNames.resetPassword ||
        location == RouteNames.verifyEmail ||
        location == RouteNames.emailVerificationPending ||
        location == RouteNames.sessionExpired;

    if (!isAuthenticated && !isPublicRoute) {
      return RouteNames.login;
    }

    if (isAuthenticated && (location == RouteNames.login || location == RouteNames.register)) {
      return RouteNames.dashboard;
    }

    return null;
  }
}
