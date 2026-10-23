import 'package:flutter/material.dart';
import 'app.dart';
import 'core/di/admin_injection.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await configureAdminDependencies();
  runApp(const NexusAdminApp());
}
