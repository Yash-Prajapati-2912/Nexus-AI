import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../core/storage/session_manager.dart';
import '../di/injection_container.dart';
import '../features/authentication/presentation/pages/email_verification_pending_page.dart';
import '../features/authentication/presentation/pages/forgot_password_page.dart';
import '../features/authentication/presentation/pages/login_page.dart';
import '../features/authentication/presentation/pages/onboarding_page.dart';
import '../features/authentication/presentation/pages/register_page.dart';
import '../features/authentication/presentation/pages/reset_password_page.dart';
import '../features/authentication/presentation/pages/session_expired_page.dart';
import '../features/authentication/presentation/pages/splash_page.dart';
import '../features/authentication/presentation/pages/verify_email_page.dart';
import '../features/dashboard/presentation/bloc/dashboard_bloc.dart';
import '../features/dashboard/presentation/pages/dashboard_page.dart';
import '../features/planner/presentation/bloc/planner_bloc.dart';
import '../features/planner/presentation/bloc/planner_event.dart';
import '../features/planner/presentation/pages/planner_home_page.dart';
import '../features/planner/presentation/pages/task_detail_page.dart';
import '../features/ai_planner/presentation/bloc/ai_planner_bloc.dart';
import '../features/ai_planner/presentation/pages/ai_planner_home_page.dart';
import '../features/ai_planner/presentation/pages/generate_study_plan_page.dart';
import '../features/ai_planner/presentation/pages/study_plan_details_page.dart';
import '../features/ai_planner/presentation/pages/workload_analysis_page.dart';
import '../features/ai_planner/presentation/pages/priority_optimizer_page.dart';
import '../features/ai_planner/presentation/pages/deadline_risk_page.dart';
import '../features/ai_planner/presentation/pages/productivity_insights_page.dart';
import '../features/ai_planner/presentation/pages/study_recommendations_page.dart';
import '../features/ai_planner/presentation/pages/weekly_planning_page.dart';
import '../features/ai_planner/presentation/pages/monthly_planning_page.dart';
import '../features/ai_planner/presentation/pages/planner_history_page.dart';
import '../features/ai_planner/presentation/pages/saved_ai_plans_page.dart';

import '../features/ai_planner/presentation/pages/ai_planner_settings_page.dart';
import '../features/ai_planner/domain/entities/study_plan.dart';
import '../features/finance/presentation/bloc/finance_bloc.dart';
import '../features/finance/presentation/bloc/finance_event.dart';
import '../features/finance/presentation/bloc/expense_bloc.dart';
import '../features/finance/presentation/bloc/income_bloc.dart';
import '../features/finance/presentation/bloc/budget_bloc.dart';
import '../features/finance/presentation/bloc/savings_bloc.dart';
import '../features/finance/presentation/bloc/report_bloc.dart';
import '../features/finance/presentation/pages/finance_dashboard_page.dart';
import '../features/finance/presentation/pages/expense_list_page.dart';
import '../features/finance/presentation/pages/expense_details_page.dart';
import '../features/finance/presentation/pages/add_expense_page.dart';
import '../features/finance/presentation/pages/edit_expense_page.dart';
import '../features/finance/presentation/pages/income_list_page.dart';
import '../features/finance/presentation/pages/add_income_page.dart';
import '../features/finance/presentation/pages/budget_overview_page.dart';
import '../features/finance/presentation/pages/create_budget_page.dart';
import '../features/finance/presentation/pages/budget_details_page.dart';
import '../features/finance/presentation/pages/savings_goals_page.dart';
import '../features/finance/presentation/pages/create_savings_goal_page.dart';
import '../features/finance/presentation/pages/investments_page.dart';
import '../features/finance/presentation/pages/transactions_page.dart';
import '../features/finance/presentation/pages/categories_page.dart';
import '../features/finance/presentation/pages/reports_page.dart';
import '../features/finance/presentation/pages/monthly_summary_page.dart';
import '../features/finance/presentation/pages/finance_search_page.dart';
import '../features/finance/presentation/pages/finance_filter_page.dart';
import '../features/finance/domain/entities/expense.dart';
import '../features/finance/domain/entities/budget.dart';
import '../features/ai_finance/presentation/bloc/ai_finance_bloc.dart';
import '../features/ai_finance/presentation/pages/ai_finance_home_page.dart';
import '../features/ai_finance/presentation/pages/financial_health_dashboard_page.dart';
import '../features/ai_finance/presentation/pages/spending_insights_page.dart';
import '../features/ai_finance/presentation/pages/budget_recommendations_page.dart';
import '../features/ai_finance/presentation/pages/savings_advisor_page.dart';
import '../features/ai_finance/presentation/pages/expense_forecast_page.dart';
import '../features/ai_finance/presentation/pages/cash_flow_prediction_page.dart';
import '../features/ai_finance/presentation/pages/financial_goals_advisor_page.dart';
import '../features/ai_finance/presentation/pages/subscription_analysis_page.dart';
import '../features/ai_finance/presentation/pages/unusual_spending_detection_page.dart';
import '../features/ai_finance/presentation/pages/monthly_ai_report_page.dart';
import '../features/ai_finance/presentation/pages/yearly_ai_report_page.dart';
import '../features/ai_finance/presentation/pages/ai_finance_history_page.dart';
import '../features/ai_finance/presentation/pages/saved_insights_page.dart';
import '../features/ai_finance/presentation/pages/ai_finance_settings_page.dart';
import '../features/ai_mentor/presentation/bloc/ai_mentor_bloc.dart';
import '../features/ai_mentor/presentation/bloc/conversation_bloc.dart';
import '../features/ai_mentor/presentation/pages/ai_mentor_home_page.dart';
import '../features/ai_mentor/presentation/pages/conversation_screen.dart';
import '../features/ai_mentor/presentation/pages/conversation_history_page.dart';
import '../features/ai_mentor/presentation/pages/conversation_details_page.dart';
import '../features/ai_mentor/presentation/pages/pinned_conversations_page.dart';
import '../features/ai_mentor/presentation/pages/saved_messages_page.dart';
import '../features/ai_mentor/presentation/pages/ai_mentor_search_page.dart';
import '../features/ai_mentor/presentation/pages/suggested_prompts_page.dart';
import '../features/ai_mentor/presentation/pages/ai_mentor_settings_page.dart';
import '../features/ai_mentor/presentation/pages/ai_mentor_profile_page.dart';
import '../features/ai_mentor/presentation/pages/feedback_screen.dart';
import '../features/ai_mentor/presentation/pages/rate_response_screen.dart';
import '../features/profile/presentation/bloc/profile_bloc.dart';
import '../features/profile/presentation/pages/profile_home_page.dart';
import '../features/profile/presentation/pages/edit_profile_page.dart';
import '../features/profile/presentation/pages/academic_profile_page.dart';
import '../features/profile/presentation/pages/personal_information_page.dart';
import '../features/profile/presentation/pages/achievements_page.dart';
import '../features/profile/presentation/pages/statistics_dashboard_page.dart';
import '../features/profile/presentation/pages/skills_page.dart';
import '../features/profile/presentation/pages/interests_page.dart';
import '../features/profile/presentation/pages/goals_overview_page.dart';
import '../features/profile/presentation/pages/connected_accounts_page.dart';
import '../features/profile/presentation/pages/privacy_settings_page.dart';
import '../features/profile/presentation/pages/security_overview_page.dart';
import '../features/profile/presentation/pages/delete_account_page.dart';
import '../features/profile/presentation/pages/export_my_data_page.dart';
import '../features/profile/presentation/pages/profile_completion_page.dart';
import '../features/notifications/domain/entities/notification_item.dart';
import '../features/notifications/presentation/bloc/notification_bloc.dart';
import '../features/notifications/presentation/pages/notification_center_page.dart';
import '../features/notifications/presentation/pages/activity_center_page.dart';
import '../features/notifications/presentation/pages/notification_details_page.dart';
import '../features/notifications/presentation/pages/notification_preferences_page.dart';
import '../features/notifications/presentation/pages/notification_categories_page.dart';
import '../features/notifications/presentation/pages/activity_details_page.dart';
import '../features/notifications/presentation/pages/notification_search_page.dart';
import '../features/notifications/presentation/pages/notification_filters_page.dart';
import '../features/notifications/presentation/pages/empty_notification_page.dart';
import '../features/notifications/presentation/pages/error_notification_page.dart';
import '../features/files/domain/entities/file_item.dart';
import '../features/files/presentation/bloc/file_bloc.dart';
import '../features/files/presentation/pages/file_manager_page.dart';
import '../features/files/presentation/pages/media_gallery_page.dart';
import '../features/files/presentation/pages/image_viewer_page.dart';
import '../features/files/presentation/pages/pdf_viewer_page.dart';
import '../features/files/presentation/pages/document_viewer_page.dart';
import '../features/files/presentation/pages/video_player_page.dart';
import '../features/files/presentation/pages/audio_player_page.dart';
import '../features/files/presentation/pages/downloads_page.dart';
import '../features/files/presentation/pages/recent_files_page.dart';
import '../features/files/presentation/pages/favourite_files_page.dart';
import '../features/files/presentation/pages/shared_files_page.dart';
import '../features/files/presentation/pages/trash_page.dart';
import '../features/files/presentation/pages/storage_usage_page.dart';
import '../features/files/presentation/pages/file_details_page.dart';
import '../features/files/presentation/pages/upload_queue_page.dart';
import '../features/files/presentation/pages/search_files_page.dart';
import '../features/files/presentation/pages/filter_files_page.dart';
import '../features/settings/presentation/bloc/settings_bloc.dart';
import '../features/settings/presentation/bloc/theme_bloc.dart';
import '../features/settings/presentation/bloc/security_bloc.dart';
import '../features/settings/presentation/bloc/privacy_bloc.dart';
import '../features/settings/presentation/bloc/session_bloc.dart';
import '../features/settings/presentation/bloc/backup_bloc.dart';
import '../features/settings/presentation/bloc/developer_bloc.dart';
import '../features/settings/presentation/pages/settings_home_page.dart';
import '../features/settings/presentation/pages/appearance_settings_page.dart';
import '../features/settings/presentation/pages/theme_settings_page.dart';
import '../features/settings/presentation/pages/language_settings_page.dart';
import '../features/settings/presentation/pages/accessibility_settings_page.dart';
import '../features/settings/presentation/pages/security_settings_page.dart';
import '../features/settings/presentation/pages/privacy_settings_page.dart' as settings_privacy;
import '../features/settings/presentation/pages/ai_preferences_page.dart';
import '../features/settings/presentation/pages/notification_preferences_page.dart' as settings_notif;
import '../features/settings/presentation/pages/backup_restore_page.dart';
import '../features/settings/presentation/pages/session_management_page.dart';
import '../features/settings/presentation/pages/connected_devices_page.dart';
import '../features/settings/presentation/pages/developer_options_page.dart';
import '../features/settings/presentation/pages/about_application_page.dart';
import '../features/settings/presentation/pages/licenses_page.dart';
import '../features/settings/presentation/pages/terms_conditions_page.dart';
import '../features/settings/presentation/pages/privacy_policy_page.dart';
import '../features/settings/presentation/pages/open_source_licenses_page.dart';
import '../shared/widgets/unknown_screen.dart';





import 'auth_guard.dart';
import 'route_names.dart';


/// App GoRouter Configuration factory.
abstract class AppRouter {
  static CustomTransitionPage<void> buildPageTransition({
    required BuildContext context,
    required GoRouterState state,
    required Widget child,
  }) {
    return CustomTransitionPage<void>(
      key: state.pageKey,
      child: child,
      transitionDuration: const Duration(milliseconds: 220),
      reverseTransitionDuration: const Duration(milliseconds: 180),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        final curveAnimation = CurvedAnimation(
          parent: animation,
          curve: Curves.easeOutCubic,
          reverseCurve: Curves.easeInCubic,
        );
        return FadeTransition(
          opacity: curveAnimation,
          child: SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0.015, 0.0),
              end: Offset.zero,
            ).animate(curveAnimation),
            child: child,
          ),
        );
      },
    );
  }

  static GoRouter createRouter(
    SessionManager sessionManager,
    GlobalKey<NavigatorState> navigatorKey,
  ) {
    return GoRouter(
      navigatorKey: navigatorKey,
      initialLocation: RouteNames.splash,
      redirect: (context, state) =>
          AuthGuard.redirectGuard(context, state, sessionManager),
      routes: [
        GoRoute(
          path: RouteNames.splash,
          builder: (context, state) => const SplashPage(),
        ),
        GoRoute(
          path: RouteNames.onboarding,
          builder: (context, state) => const OnboardingPage(),
        ),
        GoRoute(
          path: RouteNames.login,
          builder: (context, state) => const LoginPage(),
        ),
        GoRoute(
          path: RouteNames.register,
          builder: (context, state) => const RegisterPage(),
        ),
        GoRoute(
          path: RouteNames.forgotPassword,
          builder: (context, state) => const ForgotPasswordPage(),
        ),
        GoRoute(
          path: RouteNames.resetPassword,
          builder: (context, state) {
            final token = state.extra as String? ?? state.uri.queryParameters['token'] ?? '';
            return ResetPasswordPage(token: token);
          },
        ),
        GoRoute(
          path: RouteNames.verifyEmail,
          builder: (context, state) {
            final token = state.extra as String? ?? state.uri.queryParameters['token'] ?? '';
            return VerifyEmailPage(token: token);
          },
        ),
        GoRoute(
          path: RouteNames.emailVerificationPending,
          builder: (context, state) {
            final email = state.extra as String? ?? '';
            return EmailVerificationPendingPage(email: email);
          },
        ),
        GoRoute(
          path: RouteNames.sessionExpired,
          builder: (context, state) => const SessionExpiredPage(),
        ),
        GoRoute(
          path: RouteNames.dashboard,
          pageBuilder: (context, state) => buildPageTransition(
            context: context,
            state: state,
            child: BlocProvider(
              create: (_) => getIt<DashboardBloc>(),
              child: const DashboardPage(),
            ),
          ),
        ),
        GoRoute(
          path: RouteNames.planner,
          pageBuilder: (context, state) => buildPageTransition(
            context: context,
            state: state,
            child: BlocProvider(
              create: (_) => getIt<PlannerBloc>(),
              child: const PlannerHomePage(),
            ),
          ),
        ),
        GoRoute(
          path: RouteNames.plannerTaskDetail,
          builder: (context, state) {
            final taskId = state.uri.queryParameters['id'] ?? (state.extra as String?);
            return BlocProvider.value(
              value: getIt<PlannerBloc>()..add(LoadPlannerEvent()),
              child: TaskDetailPage(taskId: taskId),
            );
          },
        ),
        GoRoute(
          path: RouteNames.aiPlannerHome,
          builder: (context, state) => BlocProvider(
            create: (_) => getIt<AIPlannerBloc>(),
            child: const AIPlannerHomePage(),
          ),
        ),
        GoRoute(
          path: RouteNames.aiPlannerGeneratePlan,
          builder: (context, state) => BlocProvider(
            create: (_) => getIt<AIPlannerBloc>(),
            child: const GenerateStudyPlanPage(),
          ),
        ),
        GoRoute(
          path: RouteNames.aiPlannerPlanDetails,
          builder: (context, state) {
            final plan = state.extra as StudyPlan?;
            return BlocProvider(
              create: (_) => getIt<AIPlannerBloc>(),
              child: StudyPlanDetailsPage(plan: plan),
            );
          },
        ),
        GoRoute(
          path: RouteNames.aiPlannerWorkload,
          builder: (context, state) => BlocProvider(
            create: (_) => getIt<AIPlannerBloc>(),
            child: const WorkloadAnalysisPage(),
          ),
        ),
        GoRoute(
          path: RouteNames.aiPlannerPriority,
          builder: (context, state) => BlocProvider(
            create: (_) => getIt<AIPlannerBloc>(),
            child: const PriorityOptimizerPage(),
          ),
        ),
        GoRoute(
          path: RouteNames.aiPlannerDeadlineRisk,
          builder: (context, state) => BlocProvider(
            create: (_) => getIt<AIPlannerBloc>(),
            child: const DeadlineRiskPage(),
          ),
        ),
        GoRoute(
          path: RouteNames.aiPlannerInsights,
          builder: (context, state) => BlocProvider(
            create: (_) => getIt<AIPlannerBloc>(),
            child: const ProductivityInsightsPage(),
          ),
        ),
        GoRoute(
          path: RouteNames.aiPlannerRecommendations,
          builder: (context, state) => BlocProvider(
            create: (_) => getIt<AIPlannerBloc>(),
            child: const StudyRecommendationsPage(),
          ),
        ),
        GoRoute(
          path: RouteNames.aiPlannerWeekly,
          builder: (context, state) => BlocProvider(
            create: (_) => getIt<AIPlannerBloc>(),
            child: const WeeklyPlanningPage(),
          ),
        ),
        GoRoute(
          path: RouteNames.aiPlannerMonthly,
          builder: (context, state) => BlocProvider(
            create: (_) => getIt<AIPlannerBloc>(),
            child: const MonthlyPlanningPage(),
          ),
        ),
        GoRoute(
          path: RouteNames.aiPlannerHistory,
          builder: (context, state) => BlocProvider(
            create: (_) => getIt<AIPlannerBloc>(),
            child: const PlannerHistoryPage(),
          ),
        ),
        GoRoute(
          path: RouteNames.aiPlannerSavedPlans,
          builder: (context, state) => BlocProvider(
            create: (_) => getIt<AIPlannerBloc>(),
            child: const SavedAIPlansPage(),
          ),
        ),
        GoRoute(
          path: RouteNames.aiPlannerSettings,
          builder: (context, state) => const AIPlannerSettingsPage(),
        ),
        // Finance Routes
        GoRoute(
          path: RouteNames.finance,
          pageBuilder: (context, state) => buildPageTransition(
            context: context,
            state: state,
            child: BlocProvider(
              create: (_) => getIt<FinanceBloc>()..add(const LoadFinanceDashboardEvent()),
              child: const FinanceDashboardPage(),
            ),
          ),
        ),
        GoRoute(
          path: RouteNames.financeExpenses,
          builder: (context, state) => BlocProvider(
            create: (_) => getIt<ExpenseBloc>(),
            child: const ExpenseListPage(),
          ),
        ),
        GoRoute(
          path: RouteNames.financeExpenseDetails,
          builder: (context, state) => BlocProvider(
            create: (_) => getIt<ExpenseBloc>(),
            child: ExpenseDetailsPage(expense: state.extra as Expense?),
          ),
        ),
        GoRoute(
          path: RouteNames.financeAddExpense,
          builder: (context, state) => BlocProvider(
            create: (_) => getIt<ExpenseBloc>(),
            child: const AddExpensePage(),
          ),
        ),
        GoRoute(
          path: RouteNames.financeEditExpense,
          builder: (context, state) => BlocProvider(
            create: (_) => getIt<ExpenseBloc>(),
            child: EditExpensePage(expense: state.extra as Expense?),
          ),
        ),
        GoRoute(
          path: RouteNames.financeIncome,
          builder: (context, state) => BlocProvider(
            create: (_) => getIt<IncomeBloc>(),
            child: const IncomeListPage(),
          ),
        ),
        GoRoute(
          path: RouteNames.financeAddIncome,
          builder: (context, state) => BlocProvider(
            create: (_) => getIt<IncomeBloc>(),
            child: const AddIncomePage(),
          ),
        ),
        GoRoute(
          path: RouteNames.financeBudgets,
          builder: (context, state) => BlocProvider(
            create: (_) => getIt<BudgetBloc>(),
            child: const BudgetOverviewPage(),
          ),
        ),
        GoRoute(
          path: RouteNames.financeCreateBudget,
          builder: (context, state) => BlocProvider(
            create: (_) => getIt<BudgetBloc>(),
            child: const CreateBudgetPage(),
          ),
        ),
        GoRoute(
          path: RouteNames.financeBudgetDetails,
          builder: (context, state) => BudgetDetailsPage(budget: state.extra as Budget?),
        ),
        GoRoute(
          path: RouteNames.financeSavings,
          builder: (context, state) => BlocProvider(
            create: (_) => getIt<SavingsBloc>(),
            child: const SavingsGoalsPage(),
          ),
        ),
        GoRoute(
          path: RouteNames.financeCreateSavingsGoal,
          builder: (context, state) => BlocProvider(
            create: (_) => getIt<SavingsBloc>(),
            child: const CreateSavingsGoalPage(),
          ),
        ),
        GoRoute(
          path: RouteNames.financeInvestments,
          builder: (context, state) => BlocProvider(
            create: (_) => getIt<FinanceBloc>(),
            child: const InvestmentsPage(),
          ),
        ),
        GoRoute(
          path: RouteNames.financeTransactions,
          builder: (context, state) => const TransactionsPage(),
        ),
        GoRoute(
          path: RouteNames.financeCategories,
          builder: (context, state) => const CategoriesPage(),
        ),
        GoRoute(
          path: RouteNames.financeReports,
          builder: (context, state) => BlocProvider(
            create: (_) => getIt<ReportBloc>(),
            child: const ReportsPage(),
          ),
        ),
        GoRoute(
          path: RouteNames.financeMonthlySummary,
          builder: (context, state) => const MonthlySummaryPage(),
        ),
        GoRoute(
          path: RouteNames.financeSearch,
          builder: (context, state) => BlocProvider(
            create: (_) => getIt<ExpenseBloc>(),
            child: const FinanceSearchPage(),
          ),
        ),
        GoRoute(
          path: RouteNames.financeFilter,
          builder: (context, state) => BlocProvider(
            create: (_) => getIt<ExpenseBloc>(),
            child: const FinanceFilterPage(),
          ),
        ),
        // AI Finance Routes
        GoRoute(
          path: RouteNames.aiFinanceHome,
          builder: (context, state) => BlocProvider(
            create: (_) => getIt<AIFinanceBloc>(),
            child: const AIFinanceHomePage(),
          ),
        ),
        GoRoute(
          path: RouteNames.aiFinanceHealthDashboard,
          builder: (context, state) => BlocProvider(
            create: (_) => getIt<AIFinanceBloc>(),
            child: const FinancialHealthDashboardPage(),
          ),
        ),
        GoRoute(
          path: RouteNames.aiFinanceSpendingInsights,
          builder: (context, state) => BlocProvider(
            create: (_) => getIt<AIFinanceBloc>(),
            child: const SpendingInsightsPage(),
          ),
        ),
        GoRoute(
          path: RouteNames.aiFinanceBudgetRecommendations,
          builder: (context, state) => BlocProvider(
            create: (_) => getIt<AIFinanceBloc>(),
            child: const BudgetRecommendationsPage(),
          ),
        ),
        GoRoute(
          path: RouteNames.aiFinanceSavingsAdvisor,
          builder: (context, state) => BlocProvider(
            create: (_) => getIt<AIFinanceBloc>(),
            child: const SavingsAdvisorPage(),
          ),
        ),
        GoRoute(
          path: RouteNames.aiFinanceExpenseForecast,
          builder: (context, state) => BlocProvider(
            create: (_) => getIt<AIFinanceBloc>(),
            child: const ExpenseForecastPage(),
          ),
        ),
        GoRoute(
          path: RouteNames.aiFinanceCashFlowPrediction,
          builder: (context, state) => const CashFlowPredictionPage(),
        ),
        GoRoute(
          path: RouteNames.aiFinanceGoalsAdvisor,
          builder: (context, state) => const FinancialGoalsAdvisorPage(),
        ),
        GoRoute(
          path: RouteNames.aiFinanceSubscriptionAnalysis,
          builder: (context, state) => BlocProvider(
            create: (_) => getIt<AIFinanceBloc>(),
            child: const SubscriptionAnalysisPage(),
          ),
        ),
        GoRoute(
          path: RouteNames.aiFinanceUnusualSpending,
          builder: (context, state) => const UnusualSpendingDetectionPage(),
        ),
        GoRoute(
          path: RouteNames.aiFinanceMonthlyReport,
          builder: (context, state) => const MonthlyAIReportPage(),
        ),
        GoRoute(
          path: RouteNames.aiFinanceYearlyReport,
          builder: (context, state) => const YearlyAIReportPage(),
        ),
        GoRoute(
          path: RouteNames.aiFinanceHistory,
          builder: (context, state) => const AIFinanceHistoryPage(),
        ),
        GoRoute(
          path: RouteNames.aiFinanceSavedInsights,
          builder: (context, state) => const SavedInsightsPage(),
        ),
        GoRoute(
          path: RouteNames.aiFinanceSettings,
          builder: (context, state) => const AIFinanceSettingsPage(),
        ),
        // AI Mentor Routes
        GoRoute(
          path: RouteNames.aiMentorHome,
          pageBuilder: (context, state) => buildPageTransition(
            context: context,
            state: state,
            child: BlocProvider(
              create: (_) => getIt<AIMentorBloc>(),
              child: const AIMentorHomePage(),
            ),
          ),
        ),
        GoRoute(
          path: RouteNames.aiMentorConversation,
          builder: (context, state) {
            final id = state.uri.queryParameters['id'];
            final prompt = state.uri.queryParameters['prompt'];
            final topic = state.uri.queryParameters['topic'];
            return MultiBlocProvider(
              providers: [
                BlocProvider(create: (_) => getIt<ConversationBloc>()),
                BlocProvider(create: (_) => getIt<AIMentorBloc>()..add(const LoadAIMentorDashboardEvent())),
              ],
              child: ConversationScreen(
                conversationId: id,
                initialPrompt: prompt,
                topic: topic,
              ),
            );
          },
        ),
        GoRoute(
          path: RouteNames.aiMentorHistory,
          builder: (context, state) => BlocProvider(
            create: (_) => getIt<AIMentorBloc>()..add(const LoadAIMentorDashboardEvent()),
            child: const ConversationHistoryPage(),
          ),
        ),
        GoRoute(
          path: RouteNames.aiMentorConversationDetails,
          builder: (context, state) => const ConversationDetailsPage(),
        ),
        GoRoute(
          path: RouteNames.aiMentorPinnedConversations,
          builder: (context, state) => const PinnedConversationsPage(),
        ),
        GoRoute(
          path: RouteNames.aiMentorSavedMessages,
          builder: (context, state) => const SavedMessagesPage(),
        ),
        GoRoute(
          path: RouteNames.aiMentorSearch,
          builder: (context, state) => BlocProvider(
            create: (_) => getIt<AIMentorBloc>()..add(const LoadAIMentorDashboardEvent()),
            child: const AIMentorSearchPage(),
          ),
        ),
        GoRoute(
          path: RouteNames.aiMentorSuggestedPrompts,
          builder: (context, state) => const SuggestedPromptsPage(),
        ),
        GoRoute(
          path: RouteNames.aiMentorSettings,
          builder: (context, state) => const AIMentorSettingsPage(),
        ),
        GoRoute(
          path: RouteNames.aiMentorProfile,
          builder: (context, state) => const AIMentorProfilePage(),
        ),
        GoRoute(
          path: RouteNames.aiMentorFeedback,
          builder: (context, state) => const FeedbackScreen(),
        ),
        GoRoute(
          path: RouteNames.aiMentorRateResponse,
          builder: (context, state) => const RateResponseScreen(),
        ),
        // Profile & User Management Routes
        GoRoute(
          path: RouteNames.profileHome,
          pageBuilder: (context, state) => buildPageTransition(
            context: context,
            state: state,
            child: BlocProvider.value(
              value: getIt<ProfileBloc>(),
              child: const ProfileHomePage(),
            ),
          ),
        ),
        GoRoute(
          path: RouteNames.profileEdit,
          builder: (context, state) => BlocProvider.value(
            value: getIt<ProfileBloc>(),
            child: const EditProfilePage(),
          ),
        ),
        GoRoute(
          path: RouteNames.profileAcademic,
          builder: (context, state) => BlocProvider.value(
            value: getIt<ProfileBloc>(),
            child: const AcademicProfilePage(),
          ),
        ),
        GoRoute(
          path: RouteNames.profilePersonalInformation,
          builder: (context, state) => BlocProvider.value(
            value: getIt<ProfileBloc>(),
            child: const PersonalInformationPage(),
          ),
        ),
        GoRoute(
          path: RouteNames.profileAchievements,
          builder: (context, state) => const AchievementsPage(),
        ),
        GoRoute(
          path: RouteNames.profileStatisticsDashboard,
          builder: (context, state) => const StatisticsDashboardPage(),
        ),
        GoRoute(
          path: RouteNames.profileSkills,
          builder: (context, state) => BlocProvider.value(
            value: getIt<ProfileBloc>(),
            child: const SkillsPage(),
          ),
        ),
        GoRoute(
          path: RouteNames.profileInterests,
          builder: (context, state) => BlocProvider.value(
            value: getIt<ProfileBloc>(),
            child: const InterestsPage(),
          ),
        ),
        GoRoute(
          path: RouteNames.profileGoalsOverview,
          builder: (context, state) => BlocProvider.value(
            value: getIt<ProfileBloc>(),
            child: const GoalsOverviewPage(),
          ),
        ),
        GoRoute(
          path: RouteNames.profileConnectedAccounts,
          builder: (context, state) => BlocProvider.value(
            value: getIt<ProfileBloc>(),
            child: const ConnectedAccountsPage(),
          ),
        ),
        GoRoute(
          path: RouteNames.profilePrivacySettings,
          builder: (context, state) => BlocProvider.value(
            value: getIt<ProfileBloc>(),
            child: const PrivacySettingsPage(),
          ),
        ),
        GoRoute(
          path: RouteNames.profileSecurityOverview,
          builder: (context, state) => BlocProvider.value(
            value: getIt<ProfileBloc>(),
            child: const SecurityOverviewPage(),
          ),
        ),
        GoRoute(
          path: RouteNames.profileDeleteAccount,
          builder: (context, state) => const DeleteAccountPage(),
        ),
        GoRoute(
          path: RouteNames.profileExportData,
          builder: (context, state) => const ExportMyDataPage(),
        ),
        GoRoute(
          path: RouteNames.profileCompletion,
          builder: (context, state) => const ProfileCompletionPage(),
        ),
        // Notifications & Activity Center Routes
        GoRoute(
          path: RouteNames.notificationsCenter,
          builder: (context, state) => BlocProvider(
            create: (_) => getIt<NotificationBloc>(),
            child: const NotificationCenterPage(),
          ),
        ),
        GoRoute(
          path: RouteNames.notificationsActivityCenter,
          builder: (context, state) => ActivityCenterPage(),
        ),
        GoRoute(
          path: RouteNames.notificationsDetails,
          builder: (context, state) {
            final item = state.extra as NotificationItem?;
            return NotificationDetailsPage(item: item);
          },
        ),
        GoRoute(
          path: RouteNames.notificationsPreferences,
          builder: (context, state) => const NotificationPreferencesPage(),
        ),
        GoRoute(
          path: RouteNames.notificationsCategories,
          builder: (context, state) => const NotificationCategoriesPage(),
        ),
        GoRoute(
          path: RouteNames.notificationsActivityDetails,
          builder: (context, state) => const ActivityDetailsPage(),
        ),
        GoRoute(
          path: RouteNames.notificationsSearch,
          builder: (context, state) => const NotificationSearchPage(),
        ),
        GoRoute(
          path: RouteNames.notificationsFilters,
          builder: (context, state) => const NotificationFiltersPage(),
        ),
        GoRoute(
          path: RouteNames.notificationsEmpty,
          builder: (context, state) => const EmptyNotificationPage(),
        ),
        GoRoute(
          path: RouteNames.notificationsError,
          builder: (context, state) => const ErrorNotificationPage(),
        ),
        // Files & Media Platform Routes
        GoRoute(
          path: RouteNames.filesManager,
          builder: (context, state) => BlocProvider(
            create: (_) => getIt<FileBloc>(),
            child: const FileManagerPage(),
          ),
        ),
        GoRoute(
          path: RouteNames.filesMediaGallery,
          builder: (context, state) => MediaGalleryPage(),
        ),
        GoRoute(
          path: RouteNames.filesImageViewer,
          builder: (context, state) {
            final file = state.extra as FileItem?;
            return ImageViewerPage(file: file);
          },
        ),
        GoRoute(
          path: RouteNames.filesPdfViewer,
          builder: (context, state) {
            final file = state.extra as FileItem?;
            return PdfViewerPage(file: file);
          },
        ),
        GoRoute(
          path: RouteNames.filesDocumentViewer,
          builder: (context, state) {
            final file = state.extra as FileItem?;
            return DocumentViewerPage(file: file);
          },
        ),
        GoRoute(
          path: RouteNames.filesVideoPlayer,
          builder: (context, state) {
            final file = state.extra as FileItem?;
            return VideoPlayerPage(file: file);
          },
        ),
        GoRoute(
          path: RouteNames.filesAudioPlayer,
          builder: (context, state) {
            final file = state.extra as FileItem?;
            return AudioPlayerPage(file: file);
          },
        ),
        GoRoute(
          path: RouteNames.filesDownloads,
          builder: (context, state) => const DownloadsPage(),
        ),
        GoRoute(
          path: RouteNames.filesRecent,
          builder: (context, state) => const RecentFilesPage(),
        ),
        GoRoute(
          path: RouteNames.filesFavourites,
          builder: (context, state) => const FavouriteFilesPage(),
        ),
        GoRoute(
          path: RouteNames.filesShared,
          builder: (context, state) => const SharedFilesPage(),
        ),
        GoRoute(
          path: RouteNames.filesTrash,
          builder: (context, state) => const TrashPage(),
        ),
        GoRoute(
          path: RouteNames.filesStorageUsage,
          builder: (context, state) => const StorageUsagePage(),
        ),
        GoRoute(
          path: RouteNames.filesDetails,
          builder: (context, state) {
            final file = state.extra as FileItem?;
            return FileDetailsPage(file: file);
          },
        ),
        GoRoute(
          path: RouteNames.filesUploadQueue,
          builder: (context, state) => const UploadQueuePage(),
        ),
        GoRoute(
          path: RouteNames.filesSearch,
          builder: (context, state) => const SearchFilesPage(),
        ),
        GoRoute(
          path: RouteNames.filesFilter,
          builder: (context, state) => const FilterFilesPage(),
        ),
        // Enterprise Settings & Preferences Routes
        GoRoute(
          path: RouteNames.settings,
          builder: (context, state) => BlocProvider(
            create: (_) => getIt<SettingsBloc>(),
            child: const SettingsHomePage(),
          ),
        ),
        GoRoute(
          path: RouteNames.settingsAppearance,
          builder: (context, state) => BlocProvider.value(
            value: getIt<ThemeBloc>(),
            child: const AppearanceSettingsPage(),
          ),
        ),
        GoRoute(
          path: RouteNames.settingsTheme,
          builder: (context, state) => BlocProvider.value(
            value: getIt<ThemeBloc>(),
            child: const ThemeSettingsPage(),
          ),
        ),
        GoRoute(
          path: RouteNames.settingsLanguage,
          builder: (context, state) => BlocProvider.value(
            value: getIt<ThemeBloc>(),
            child: const LanguageSettingsPage(),
          ),
        ),
        GoRoute(
          path: RouteNames.settingsAccessibility,
          builder: (context, state) => BlocProvider.value(
            value: getIt<ThemeBloc>(),
            child: const AccessibilitySettingsPage(),
          ),
        ),
        GoRoute(
          path: RouteNames.settingsSecurity,
          builder: (context, state) => BlocProvider(
            create: (_) => getIt<SecurityBloc>(),
            child: const SecuritySettingsPage(),
          ),
        ),
        GoRoute(
          path: RouteNames.settingsPrivacy,
          builder: (context, state) => BlocProvider(
            create: (_) => getIt<PrivacyBloc>(),
            child: const settings_privacy.PrivacySettingsPage(),
          ),
        ),
        GoRoute(
          path: RouteNames.settingsAiPreferences,
          builder: (context, state) => BlocProvider(
            create: (_) => getIt<SettingsBloc>(),
            child: const AIPreferencesPage(),
          ),
        ),
        GoRoute(
          path: RouteNames.settingsNotificationPreferences,
          builder: (context, state) => BlocProvider(
            create: (_) => getIt<SettingsBloc>(),
            child: const settings_notif.NotificationPreferencesPage(),
          ),
        ),
        GoRoute(
          path: RouteNames.settingsBackupRestore,
          builder: (context, state) => BlocProvider(
            create: (_) => getIt<BackupBloc>(),
            child: const BackupRestorePage(),
          ),
        ),
        GoRoute(
          path: RouteNames.settingsSessionManagement,
          builder: (context, state) => BlocProvider(
            create: (_) => getIt<SessionBloc>(),
            child: const SessionManagementPage(),
          ),
        ),
        GoRoute(
          path: RouteNames.settingsConnectedDevices,
          builder: (context, state) => BlocProvider(
            create: (_) => getIt<SessionBloc>(),
            child: const ConnectedDevicesPage(),
          ),
        ),
        GoRoute(
          path: RouteNames.settingsDeveloperOptions,
          builder: (context, state) => BlocProvider(
            create: (_) => getIt<DeveloperBloc>(),
            child: const DeveloperOptionsPage(),
          ),
        ),
        GoRoute(
          path: RouteNames.settingsAbout,
          builder: (context, state) => const AboutApplicationPage(),
        ),
        GoRoute(
          path: RouteNames.settingsLicenses,
          builder: (context, state) => const LicensesPage(),
        ),
        GoRoute(
          path: RouteNames.settingsTerms,
          builder: (context, state) => const TermsConditionsPage(),
        ),
        GoRoute(
          path: RouteNames.settingsPrivacyPolicy,
          builder: (context, state) => const PrivacyPolicyPage(),
        ),
        GoRoute(
          path: RouteNames.settingsOpenSourceLicenses,
          builder: (context, state) => const OpenSourceLicensesPage(),
        ),
      ],

      errorBuilder: (context, state) => const UnknownScreen(),
    );
  }
}






