import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../network/admin_api_client.dart';
import '../security/permission_manager.dart';

final GetIt getIt = GetIt.instance;

Future<void> configureAdminDependencies() async {
  final prefs = await SharedPreferences.getInstance();
  getIt.registerSingleton<SharedPreferences>(prefs);
  getIt.registerSingleton<AdminApiClient>(AdminApiClient(getIt<SharedPreferences>()));
  getIt.registerSingleton<PermissionManager>(PermissionManager());
}
