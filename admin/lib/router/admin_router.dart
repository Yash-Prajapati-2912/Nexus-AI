import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../core/di/admin_injection.dart';
import '../shared/layout/admin_shell_layout.dart';
import '../features/auth/presentation/pages/admin_login_page.dart';
import '../features/dashboard/presentation/pages/admin_dashboard_page.dart';
import '../features/users/presentation/pages/admin_users_page.dart';
import '../features/roles/presentation/pages/admin_roles_page.dart';
import '../features/ai_modules/presentation/pages/admin_ai_modules_page.dart';
import '../features/analytics/presentation/pages/admin_analytics_page.dart';
import '../features/planner/presentation/pages/admin_planner_page.dart';
import '../features/finance/presentation/pages/admin_finance_page.dart';
import '../features/notifications/presentation/pages/admin_notifications_page.dart';
import '../features/files/presentation/pages/admin_files_page.dart';
import '../features/settings/presentation/pages/admin_settings_page.dart';

class AdminRouter {
  static GoRouter createRouter() {
    return GoRouter(
      initialLocation: '/dashboard',
      redirect: (context, state) {
        final prefs = getIt<SharedPreferences>();
        final token = prefs.getString('admin_jwt_token');
        final isLoggingIn = state.uri.path == '/login';

        if (token == null && !isLoggingIn) {
          return '/login';
        }
        if (token != null && isLoggingIn) {
          return '/dashboard';
        }
        return null;
      },
      routes: [
        GoRoute(
          path: '/login',
          builder: (context, state) => const AdminLoginPage(),
        ),
        ShellRoute(
          builder: (context, state, child) => AdminShellLayout(child: child),
          routes: [
            GoRoute(
              path: '/dashboard',
              builder: (context, state) => const AdminDashboardPage(),
            ),
            GoRoute(
              path: '/users',
              builder: (context, state) => const AdminUsersPage(),
            ),
            GoRoute(
              path: '/roles',
              builder: (context, state) => const AdminRolesPage(),
            ),
            GoRoute(
              path: '/ai-modules',
              builder: (context, state) => const AdminAIModulesPage(),
            ),
            GoRoute(
              path: '/analytics',
              builder: (context, state) => const AdminAnalyticsPage(),
            ),
            GoRoute(
              path: '/planner',
              builder: (context, state) => const AdminPlannerPage(),
            ),
            GoRoute(
              path: '/finance',
              builder: (context, state) => const AdminFinancePage(),
            ),
            GoRoute(
              path: '/notifications',
              builder: (context, state) => const AdminNotificationsPage(),
            ),
            GoRoute(
              path: '/files',
              builder: (context, state) => const AdminFilesPage(),
            ),
            GoRoute(
              path: '/settings',
              builder: (context, state) => const AdminSettingsPage(),
            ),
          ],
        ),
      ],
    );
  }
}
