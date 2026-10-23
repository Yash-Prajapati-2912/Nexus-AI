import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import '../../router/route_names.dart';
import 'app_logger.dart';

class DeepLinkHandler {
  final StreamController<Uri> _uriController = StreamController<Uri>.broadcast();
  Stream<Uri> get uriStream => _uriController.stream;

  void initialize(BuildContext context) {
    AppLogger.info('DeepLinkHandler: Initialized app link listener.');
  }

  void handleUri(BuildContext context, Uri uri) {
    AppLogger.info('DeepLinkHandler: Handling deep link URI [${uri.toString()}]');

    final path = uri.path;
    if (path.startsWith('/planner')) {
      context.push(RouteNames.planner);
    } else if (path.startsWith('/finance')) {
      context.push(RouteNames.finance);
    } else if (path.startsWith('/ai-mentor')) {
      context.push(RouteNames.aiMentorHome);
    } else if (path.startsWith('/notifications')) {
      context.push(RouteNames.notificationsCenter);
    } else if (path.startsWith('/settings')) {
      context.push(RouteNames.settings);
    }
  }

  void dispose() {
    _uriController.close();
  }
}
