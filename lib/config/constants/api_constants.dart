/// REST API endpoint paths.
abstract class ApiConstants {
  // Auth
  static const String login = '/auth/login';
  static const String register = '/auth/register';
  static const String logout = '/auth/logout';
  static const String logoutAll = '/auth/logout-all';
  static const String refreshToken = '/auth/refresh';
  static const String forgotPassword = '/auth/forgot-password';
  static const String resetPassword = '/auth/reset-password';
  static const String verifyEmail = '/auth/verify-email';
  static const String resendVerification = '/auth/resend-verification';
  static const String profile = '/auth/me';

  // Dashboard
  static const String dashboardSummary = '/dashboard/summary';

  // Smart Planner
  static const String tasks = '/planner/tasks';
  static const String optimizeSchedule = '/planner/ai-optimize';

  // Smart Finance
  static const String expenses = '/finance/expenses';
  static const String financialAdvice = '/finance/ai-advisor';

  // AI Mentor
  static const String mentorChat = '/ai-mentor/chat';

  // Notifications
  static const String notifications = '/notifications';

  // Uploads
  static const String uploadPresignedUrl = '/upload/presigned-url';
}
