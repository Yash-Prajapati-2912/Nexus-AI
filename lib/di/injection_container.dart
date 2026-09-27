import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../config/env/app_env.dart';
import '../core/network/api_client.dart';
import '../core/network/dio_client.dart';
import '../core/services/connectivity_service.dart';
import '../core/services/logger_service.dart';
import '../core/services/notification_service.dart';
import '../core/storage/preferences_manager.dart';
import '../core/storage/secure_token_storage.dart';
import '../core/storage/session_manager.dart';
import '../features/authentication/data/datasources/auth_remote_data_source.dart';
import '../features/authentication/data/repositories/auth_repository_impl.dart';
import '../features/authentication/domain/repositories/i_auth_repository.dart';
import '../features/authentication/domain/usecases/forgot_password_usecase.dart';
import '../features/authentication/domain/usecases/load_current_user_usecase.dart';
import '../features/authentication/domain/usecases/login_usecase.dart';
import '../features/authentication/domain/usecases/logout_all_usecase.dart';
import '../features/authentication/domain/usecases/logout_usecase.dart';
import '../features/authentication/domain/usecases/refresh_token_usecase.dart';
import '../features/authentication/domain/usecases/register_usecase.dart';
import '../features/authentication/domain/usecases/resend_verification_usecase.dart';
import '../features/authentication/domain/usecases/reset_password_usecase.dart';
import '../features/authentication/domain/usecases/verify_email_usecase.dart';
import '../features/authentication/presentation/bloc/authentication_bloc.dart';
import '../features/dashboard/data/datasources/dashboard_remote_data_source.dart';
import '../features/dashboard/data/repositories/dashboard_repository_impl.dart';
import '../features/dashboard/domain/repositories/i_dashboard_repository.dart';
import '../features/dashboard/domain/usecases/get_ai_insight_usecase.dart';
import '../features/dashboard/domain/usecases/get_dashboard_usecase.dart';
import '../features/dashboard/domain/usecases/get_finance_summary_usecase.dart';
import '../features/dashboard/domain/usecases/get_notification_summary_usecase.dart';
import '../features/dashboard/domain/usecases/get_planner_summary_usecase.dart';
import '../features/dashboard/presentation/bloc/dashboard_bloc.dart';
import '../features/planner/data/datasources/planner_remote_data_source.dart';
import '../features/planner/data/repositories/planner_repository_impl.dart';
import '../features/planner/domain/repositories/i_planner_repository.dart';
import '../features/planner/domain/usecases/complete_task_usecase.dart';
import '../features/planner/domain/usecases/create_assignment_usecase.dart';
import '../features/planner/domain/usecases/create_study_session_usecase.dart';
import '../features/planner/domain/usecases/create_task_usecase.dart';
import '../features/planner/domain/usecases/delete_assignment_usecase.dart';
import '../features/planner/domain/usecases/delete_task_usecase.dart';
import '../features/planner/domain/usecases/get_calendar_events_usecase.dart';
import '../features/planner/domain/usecases/get_planner_usecase.dart';
import '../features/planner/domain/usecases/search_planner_usecase.dart';
import '../features/planner/domain/usecases/update_assignment_usecase.dart';
import '../features/planner/domain/usecases/update_task_usecase.dart';
import '../features/planner/presentation/bloc/planner_bloc.dart';
import '../features/ai_planner/data/datasources/ai_planner_remote_data_source.dart';
import '../features/ai_planner/data/repositories/ai_planner_repository_impl.dart';
import '../features/ai_planner/domain/repositories/i_ai_planner_repository.dart';
import '../features/ai_planner/domain/usecases/delete_plan_usecase.dart';
import '../features/ai_planner/domain/usecases/generate_study_plan_usecase.dart';
import '../features/ai_planner/domain/usecases/get_ai_history_usecase.dart';
import '../features/ai_planner/domain/usecases/get_productivity_insights_usecase.dart';
import '../features/ai_planner/domain/usecases/get_recommendations_usecase.dart';
import '../features/ai_planner/domain/usecases/get_workload_analysis_usecase.dart';
import '../features/ai_planner/domain/usecases/save_plan_usecase.dart';
import '../features/ai_planner/presentation/bloc/ai_planner_bloc.dart';
import '../features/finance/data/datasources/finance_remote_data_source.dart';
import '../features/finance/data/repositories/finance_repository_impl.dart';
import '../features/finance/domain/repositories/i_finance_repository.dart';
import '../features/finance/domain/usecases/create_expense_usecase.dart';
import '../features/finance/domain/usecases/create_income_usecase.dart';
import '../features/finance/domain/usecases/delete_expense_usecase.dart';
import '../features/finance/domain/usecases/generate_report_usecase.dart';
import '../features/finance/domain/usecases/get_budget_usecase.dart';
import '../features/finance/domain/usecases/get_expenses_usecase.dart';
import '../features/finance/domain/usecases/get_income_usecase.dart';
import '../features/finance/domain/usecases/get_savings_goals_usecase.dart';
import '../features/finance/domain/usecases/update_budget_usecase.dart';
import '../features/finance/domain/usecases/update_expense_usecase.dart';
import '../features/finance/presentation/bloc/finance_bloc.dart';
import '../features/finance/presentation/bloc/expense_bloc.dart';
import '../features/finance/presentation/bloc/income_bloc.dart';
import '../features/finance/presentation/bloc/budget_bloc.dart';
import '../features/finance/presentation/bloc/savings_bloc.dart';
import '../features/finance/presentation/bloc/report_bloc.dart';
import '../features/ai_finance/data/datasources/ai_finance_remote_data_source.dart';
import '../features/ai_finance/data/repositories/ai_finance_repository_impl.dart';
import '../features/ai_finance/domain/repositories/i_ai_finance_repository.dart';
import '../features/ai_finance/domain/usecases/get_budget_recommendations_usecase.dart';
import '../features/ai_finance/domain/usecases/get_financial_health_usecase.dart';
import '../features/ai_finance/domain/usecases/get_forecast_usecase.dart';
import '../features/ai_finance/domain/usecases/get_savings_advice_usecase.dart';
import '../features/ai_finance/domain/usecases/get_spending_insights_usecase.dart';
import '../features/ai_finance/domain/usecases/get_subscription_analysis_usecase.dart';
import '../features/ai_finance/presentation/bloc/ai_finance_bloc.dart';
import '../features/ai_mentor/data/datasources/ai_mentor_remote_data_source.dart';
import '../features/ai_mentor/data/repositories/ai_mentor_repository_impl.dart';
import '../features/ai_mentor/domain/repositories/i_ai_mentor_repository.dart';
import '../features/ai_mentor/domain/usecases/get_wellness_scores_usecase.dart';
import '../features/ai_mentor/domain/usecases/load_conversation_details_usecase.dart';
import '../features/ai_mentor/domain/usecases/load_conversations_usecase.dart';
import '../features/ai_mentor/domain/usecases/search_conversations_usecase.dart';
import '../features/ai_mentor/domain/usecases/send_message_usecase.dart';
import '../features/ai_mentor/domain/usecases/update_conversation_usecase.dart';
import '../features/ai_mentor/presentation/bloc/ai_mentor_bloc.dart';

import '../features/ai_mentor/presentation/bloc/conversation_bloc.dart';
import '../features/ai_mentor/presentation/bloc/mentor_search_bloc.dart';
import '../features/ai_mentor/presentation/bloc/prompt_bloc.dart';
import '../features/profile/data/datasources/profile_remote_data_source.dart';
import '../features/profile/data/repositories/profile_repository_impl.dart';
import '../features/profile/domain/repositories/i_profile_repository.dart';
import '../features/profile/domain/usecases/change_password_usecase.dart';
import '../features/profile/domain/usecases/delete_account_usecase.dart';
import '../features/profile/domain/usecases/export_data_usecase.dart';
import '../features/profile/domain/usecases/get_profile_usecase.dart';
import '../features/profile/domain/usecases/load_statistics_usecase.dart';
import '../features/profile/domain/usecases/update_academic_profile_usecase.dart';
import '../features/profile/domain/usecases/update_profile_usecase.dart';
import '../features/profile/domain/usecases/upload_avatar_usecase.dart';
import '../features/profile/presentation/bloc/account_bloc.dart';
import '../features/profile/presentation/bloc/achievement_bloc.dart';
import '../features/profile/presentation/bloc/profile_bloc.dart';
import '../features/profile/presentation/bloc/security_bloc.dart' as profile_security;
import '../features/profile/presentation/bloc/statistics_bloc.dart';
import '../features/notifications/data/datasources/notification_remote_data_source.dart';
import '../features/notifications/data/repositories/notification_repository_impl.dart';
import '../features/notifications/data/services/fcm_push_notification_service.dart';
import '../features/notifications/data/services/local_notification_service.dart';
import '../features/notifications/domain/repositories/i_notification_repository.dart';
import '../features/notifications/domain/usecases/delete_notification_usecase.dart';
import '../features/notifications/domain/usecases/get_activity_usecase.dart';
import '../features/notifications/domain/usecases/get_notifications_usecase.dart';
import '../features/notifications/domain/usecases/mark_notification_read_usecase.dart';
import '../features/notifications/domain/usecases/register_fcm_token_usecase.dart';
import '../features/notifications/domain/usecases/update_notification_preferences_usecase.dart';
import '../features/notifications/presentation/bloc/activity_bloc.dart';
import '../features/notifications/presentation/bloc/notification_bloc.dart';
import '../features/notifications/presentation/bloc/notification_preference_bloc.dart';
import '../features/notifications/presentation/bloc/push_notification_bloc.dart';
import '../features/files/data/datasources/file_remote_data_source.dart';
import '../features/files/data/repositories/file_repository_impl.dart';
import '../features/files/domain/repositories/i_file_repository.dart';
import '../features/files/domain/usecases/delete_file_usecase.dart';
import '../features/files/domain/usecases/download_file_usecase.dart';
import '../features/files/domain/usecases/get_files_usecase.dart';
import '../features/files/domain/usecases/rename_file_usecase.dart';
import '../features/files/domain/usecases/search_files_usecase.dart';
import '../features/files/domain/usecases/share_file_usecase.dart';
import '../features/files/domain/usecases/upload_file_usecase.dart';
import '../features/files/presentation/bloc/download_bloc.dart';
import '../features/files/presentation/bloc/file_bloc.dart';
import '../features/files/presentation/bloc/file_search_bloc.dart';
import '../features/files/presentation/bloc/media_bloc.dart';
import '../features/files/presentation/bloc/storage_bloc.dart';
import '../features/files/presentation/bloc/upload_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../features/settings/data/datasources/settings_local_data_source.dart';
import '../features/settings/data/datasources/settings_remote_data_source.dart';
import '../features/settings/data/repositories/settings_repository_impl.dart';
import '../features/settings/domain/repositories/i_settings_repository.dart';
import '../features/settings/domain/usecases/get_settings_usecase.dart';
import '../features/settings/domain/usecases/update_theme_usecase.dart';
import '../features/settings/domain/usecases/update_language_usecase.dart';
import '../features/settings/domain/usecases/update_accessibility_usecase.dart';
import '../features/settings/domain/usecases/update_preferences_usecase.dart';
import '../features/settings/domain/usecases/enable_biometric_usecase.dart';
import '../features/settings/domain/usecases/backup_data_usecase.dart';
import '../features/settings/domain/usecases/restore_data_usecase.dart';
import '../features/settings/domain/usecases/logout_other_devices_usecase.dart';
import '../features/settings/domain/usecases/terminate_session_usecase.dart';
import '../features/settings/domain/usecases/update_developer_settings_usecase.dart';
import '../features/settings/presentation/bloc/settings_bloc.dart';
import '../features/settings/presentation/bloc/theme_bloc.dart';
import '../features/settings/presentation/bloc/security_bloc.dart' as settings_security;
import '../features/settings/presentation/bloc/privacy_bloc.dart';
import '../features/settings/presentation/bloc/session_bloc.dart';
import '../features/settings/presentation/bloc/backup_bloc.dart';
import '../features/settings/presentation/bloc/developer_bloc.dart';
import '../core/services/analytics_service.dart';
import '../core/services/crashlytics_service.dart';
import '../core/services/remote_config_service.dart';
import '../core/services/deep_link_handler.dart';
import '../core/services/health_monitor.dart';
import '../core/services/notification_sync_service.dart';
import '../core/security/security_service.dart';
import '../core/security/secrets_manager.dart';
import '../core/offline/offline_queue_manager.dart';
import '../core/offline/conflict_resolver.dart';
import '../core/offline/sync_manager.dart';
import '../core/optimization/file_transfer_queue.dart';

final GetIt getIt = GetIt.instance;








@InjectableInit()
Future<void> configureDependencies(AppEnv env) async {
  AppEnv.initialize(env);

  // Storage Registrations
  final prefs = await SharedPreferences.getInstance();
  getIt.registerSingleton<SharedPreferences>(prefs);
  getIt.registerSingleton<PreferencesManager>(PreferencesManager(getIt<SharedPreferences>()));
  getIt.registerSingleton<FlutterSecureStorage>(const FlutterSecureStorage());
  getIt.registerSingleton<SecureTokenStorage>(SecureTokenStorage(storage: getIt<FlutterSecureStorage>()));
  getIt.registerSingleton<SessionManager>(
    SessionManager(
      secureStorage: getIt<SecureTokenStorage>(),
      preferencesManager: getIt<PreferencesManager>(),
    ),
  );

  // Network Engine
  final dio = DioClient.createDio(getIt<SecureTokenStorage>());
  getIt.registerSingleton(dio);
  getIt.registerSingleton<ApiClient>(ApiClient(getIt()));

  // Core Services
  getIt.registerSingleton<NotificationService>(NotificationService());
  getIt.registerSingleton<ConnectivityService>(ConnectivityService());
  getIt.registerSingleton<AnalyticsService>(AnalyticsService());
  getIt.registerSingleton<CrashlyticsService>(CrashlyticsService());
  getIt.registerSingleton<RemoteConfigService>(RemoteConfigService());
  getIt.registerSingleton<SecurityService>(SecurityService());
  getIt.registerSingleton<SecretsManager>(SecretsManager(getIt<FlutterSecureStorage>()));
  getIt.registerSingleton<DeepLinkHandler>(DeepLinkHandler());
  getIt.registerSingleton<HealthMonitor>(HealthMonitor());
  getIt.registerSingleton<NotificationSyncService>(NotificationSyncService());
  getIt.registerSingleton<FileTransferQueue>(FileTransferQueue());

  // Offline Engine
  getIt.registerSingleton<OfflineQueueManager>(OfflineQueueManager(getIt<SharedPreferences>()));
  getIt.registerSingleton<ConflictResolver>(ConflictResolver());
  getIt.registerSingleton<SyncManager>(
    SyncManager(
      connectivityService: getIt<ConnectivityService>(),
      queueManager: getIt<OfflineQueueManager>(),
      conflictResolver: getIt<ConflictResolver>(),
    ),
  );

  // Authentication Feature
  getIt.registerLazySingleton<IAuthRemoteDataSource>(() => AuthRemoteDataSourceImpl(getIt<ApiClient>()));
  getIt.registerLazySingleton<IAuthRepository>(
    () => AuthRepositoryImpl(
      remoteDataSource: getIt<IAuthRemoteDataSource>(),
      sessionManager: getIt<SessionManager>(),
    ),
  );
  getIt.registerLazySingleton(() => LoginUseCase(getIt<IAuthRepository>()));
  getIt.registerLazySingleton(() => RegisterUseCase(getIt<IAuthRepository>()));
  getIt.registerLazySingleton(() => LogoutUseCase(getIt<IAuthRepository>()));
  getIt.registerLazySingleton(() => LogoutAllUseCase(getIt<IAuthRepository>()));
  getIt.registerLazySingleton(() => ForgotPasswordUseCase(getIt<IAuthRepository>()));
  getIt.registerLazySingleton(() => ResetPasswordUseCase(getIt<IAuthRepository>()));
  getIt.registerLazySingleton(() => RefreshTokenUseCase(getIt<IAuthRepository>()));
  getIt.registerLazySingleton(() => VerifyEmailUseCase(getIt<IAuthRepository>()));
  getIt.registerLazySingleton(() => ResendVerificationUseCase(getIt<IAuthRepository>()));
  getIt.registerLazySingleton(() => LoadCurrentUserUseCase(getIt<IAuthRepository>()));

  getIt.registerFactory(
    () => AuthenticationBloc(
      loginUseCase: getIt<LoginUseCase>(),
      registerUseCase: getIt<RegisterUseCase>(),
      logoutUseCase: getIt<LogoutUseCase>(),
      logoutAllUseCase: getIt<LogoutAllUseCase>(),
      forgotPasswordUseCase: getIt<ForgotPasswordUseCase>(),
      resetPasswordUseCase: getIt<ResetPasswordUseCase>(),
      verifyEmailUseCase: getIt<VerifyEmailUseCase>(),
      resendVerificationUseCase: getIt<ResendVerificationUseCase>(),
      loadCurrentUserUseCase: getIt<LoadCurrentUserUseCase>(),
    ),
  );

  // Dashboard Feature
  getIt.registerLazySingleton<IDashboardRemoteDataSource>(() => DashboardRemoteDataSourceImpl(getIt<ApiClient>()));
  getIt.registerLazySingleton<IDashboardRepository>(() => DashboardRepositoryImpl(getIt<IDashboardRemoteDataSource>()));
  getIt.registerLazySingleton(() => GetDashboardUseCase(getIt<IDashboardRepository>()));
  getIt.registerLazySingleton(() => GetPlannerSummaryUseCase(getIt<IDashboardRepository>()));
  getIt.registerLazySingleton(() => GetFinanceSummaryUseCase(getIt<IDashboardRepository>()));
  getIt.registerLazySingleton(() => GetAiInsightUseCase(getIt<IDashboardRepository>()));
  getIt.registerLazySingleton(() => GetNotificationSummaryUseCase(getIt<IDashboardRepository>()));

  getIt.registerFactory(
    () => DashboardBloc(
      getDashboardUseCase: getIt<GetDashboardUseCase>(),
      getPlannerUseCase: getIt<GetPlannerUseCase>(),
    ),
  );

  // Smart Planner Feature
  getIt.registerLazySingleton<IPlannerRemoteDataSource>(() => PlannerRemoteDataSourceImpl(getIt<ApiClient>()));
  getIt.registerLazySingleton<IPlannerRepository>(() => PlannerRepositoryImpl(getIt<IPlannerRemoteDataSource>()));
  getIt.registerLazySingleton(() => GetPlannerUseCase(getIt<IPlannerRepository>()));
  getIt.registerLazySingleton(() => CreateTaskUseCase(getIt<IPlannerRepository>()));
  getIt.registerLazySingleton(() => UpdateTaskUseCase(getIt<IPlannerRepository>()));
  getIt.registerLazySingleton(() => DeleteTaskUseCase(getIt<IPlannerRepository>()));
  getIt.registerLazySingleton(() => CompleteTaskUseCase(getIt<IPlannerRepository>()));
  getIt.registerLazySingleton(() => CreateAssignmentUseCase(getIt<IPlannerRepository>()));
  getIt.registerLazySingleton(() => UpdateAssignmentUseCase(getIt<IPlannerRepository>()));
  getIt.registerLazySingleton(() => DeleteAssignmentUseCase(getIt<IPlannerRepository>()));
  getIt.registerLazySingleton(() => CreateStudySessionUseCase(getIt<IPlannerRepository>()));
  getIt.registerLazySingleton(() => GetCalendarEventsUseCase(getIt<IPlannerRepository>()));
  getIt.registerLazySingleton(() => SearchPlannerUseCase(getIt<IPlannerRepository>()));

  getIt.registerFactory(
    () => PlannerBloc(
      getPlannerUseCase: getIt<GetPlannerUseCase>(),
      createTaskUseCase: getIt<CreateTaskUseCase>(),
      completeTaskUseCase: getIt<CompleteTaskUseCase>(),
      deleteTaskUseCase: getIt<DeleteTaskUseCase>(),
      searchPlannerUseCase: getIt<SearchPlannerUseCase>(),
    ),
  );

  // AI Smart Planner Feature
  getIt.registerLazySingleton<IAIPlannerRemoteDataSource>(
    () => AIPlannerRemoteDataSourceImpl(getIt<ApiClient>()),
  );
  getIt.registerLazySingleton<IAIPlannerRepository>(
    () => AIPlannerRepositoryImpl(remoteDataSource: getIt<IAIPlannerRemoteDataSource>()),
  );
  getIt.registerLazySingleton(() => GenerateStudyPlanUseCase(getIt<IAIPlannerRepository>()));
  getIt.registerLazySingleton(() => GetAIHistoryUseCase(getIt<IAIPlannerRepository>()));
  getIt.registerLazySingleton(() => GetWorkloadAnalysisUseCase(getIt<IAIPlannerRepository>()));
  getIt.registerLazySingleton(() => GetProductivityInsightsUseCase(getIt<IAIPlannerRepository>()));
  getIt.registerLazySingleton(() => GetRecommendationsUseCase(getIt<IAIPlannerRepository>()));
  getIt.registerLazySingleton(() => SavePlanUseCase(getIt<IAIPlannerRepository>()));
  getIt.registerLazySingleton(() => DeletePlanUseCase(getIt<IAIPlannerRepository>()));

  getIt.registerFactory(
    () => AIPlannerBloc(
      generateStudyPlanUseCase: getIt<GenerateStudyPlanUseCase>(),
      getAIHistoryUseCase: getIt<GetAIHistoryUseCase>(),
      getWorkloadAnalysisUseCase: getIt<GetWorkloadAnalysisUseCase>(),
      getProductivityInsightsUseCase: getIt<GetProductivityInsightsUseCase>(),
      getRecommendationsUseCase: getIt<GetRecommendationsUseCase>(),
      savePlanUseCase: getIt<SavePlanUseCase>(),
      deletePlanUseCase: getIt<DeletePlanUseCase>(),
      repository: getIt<IAIPlannerRepository>(),
    ),
  );

  // Smart Finance Feature
  getIt.registerLazySingleton<IFinanceRemoteDataSource>(
    () => FinanceRemoteDataSourceImpl(getIt<ApiClient>()),
  );
  getIt.registerLazySingleton<IFinanceRepository>(
    () => FinanceRepositoryImpl(remoteDataSource: getIt<IFinanceRemoteDataSource>()),
  );
  getIt.registerLazySingleton(() => GetExpensesUseCase(getIt<IFinanceRepository>()));
  getIt.registerLazySingleton(() => CreateExpenseUseCase(getIt<IFinanceRepository>()));
  getIt.registerLazySingleton(() => UpdateExpenseUseCase(getIt<IFinanceRepository>()));
  getIt.registerLazySingleton(() => DeleteExpenseUseCase(getIt<IFinanceRepository>()));
  getIt.registerLazySingleton(() => GetIncomeUseCase(getIt<IFinanceRepository>()));
  getIt.registerLazySingleton(() => CreateIncomeUseCase(getIt<IFinanceRepository>()));
  getIt.registerLazySingleton(() => GetBudgetUseCase(getIt<IFinanceRepository>()));
  getIt.registerLazySingleton(() => UpdateBudgetUseCase(getIt<IFinanceRepository>()));
  getIt.registerLazySingleton(() => GetSavingsGoalsUseCase(getIt<IFinanceRepository>()));
  getIt.registerLazySingleton(() => GenerateReportUseCase(getIt<IFinanceRepository>()));

  getIt.registerFactory(
    () => FinanceBloc(
      getExpensesUseCase: getIt<GetExpensesUseCase>(),
      getIncomeUseCase: getIt<GetIncomeUseCase>(),
      getBudgetUseCase: getIt<GetBudgetUseCase>(),
      getSavingsGoalsUseCase: getIt<GetSavingsGoalsUseCase>(),
      repository: getIt<IFinanceRepository>(),
    ),
  );
  getIt.registerFactory(
    () => ExpenseBloc(
      getExpensesUseCase: getIt<GetExpensesUseCase>(),
      createExpenseUseCase: getIt<CreateExpenseUseCase>(),
      updateExpenseUseCase: getIt<UpdateExpenseUseCase>(),
      deleteExpenseUseCase: getIt<DeleteExpenseUseCase>(),
    ),
  );
  getIt.registerFactory(
    () => IncomeBloc(
      getIncomeUseCase: getIt<GetIncomeUseCase>(),
      createIncomeUseCase: getIt<CreateIncomeUseCase>(),
      repository: getIt<IFinanceRepository>(),
    ),
  );
  getIt.registerFactory(
    () => BudgetBloc(
      getBudgetUseCase: getIt<GetBudgetUseCase>(),
      updateBudgetUseCase: getIt<UpdateBudgetUseCase>(),
      repository: getIt<IFinanceRepository>(),
    ),
  );
  getIt.registerFactory(
    () => SavingsBloc(
      getSavingsGoalsUseCase: getIt<GetSavingsGoalsUseCase>(),
      repository: getIt<IFinanceRepository>(),
    ),
  );
  getIt.registerFactory(
    () => ReportBloc(
      generateReportUseCase: getIt<GenerateReportUseCase>(),
    ),
  );

  // AI Financial Advisor Feature
  getIt.registerLazySingleton<IAIFinanceRemoteDataSource>(
    () => AIFinanceRemoteDataSourceImpl(getIt<ApiClient>()),
  );
  getIt.registerLazySingleton<IAIFinanceRepository>(
    () => AIFinanceRepositoryImpl(remoteDataSource: getIt<IAIFinanceRemoteDataSource>()),
  );
  getIt.registerLazySingleton(() => GetFinancialHealthUseCase(getIt<IAIFinanceRepository>()));
  getIt.registerLazySingleton(() => GetSpendingInsightsUseCase(getIt<IAIFinanceRepository>()));
  getIt.registerLazySingleton(() => GetForecastUseCase(getIt<IAIFinanceRepository>()));
  getIt.registerLazySingleton(() => GetBudgetRecommendationsUseCase(getIt<IAIFinanceRepository>()));
  getIt.registerLazySingleton(() => GetSavingsAdviceUseCase(getIt<IAIFinanceRepository>()));
  getIt.registerLazySingleton(() => GetSubscriptionAnalysisUseCase(getIt<IAIFinanceRepository>()));

  getIt.registerFactory(
    () => AIFinanceBloc(
      getFinancialHealthUseCase: getIt<GetFinancialHealthUseCase>(),
      getSpendingInsightsUseCase: getIt<GetSpendingInsightsUseCase>(),
      getForecastUseCase: getIt<GetForecastUseCase>(),
      getBudgetRecommendationsUseCase: getIt<GetBudgetRecommendationsUseCase>(),
      getSavingsAdviceUseCase: getIt<GetSavingsAdviceUseCase>(),
      getSubscriptionAnalysisUseCase: getIt<GetSubscriptionAnalysisUseCase>(),
      repository: getIt<IAIFinanceRepository>(),
    ),
  );

  // AI Mentor Feature
  getIt.registerLazySingleton<IAIMentorRemoteDataSource>(
    () => AIMentorRemoteDataSourceImpl(getIt<ApiClient>()),
  );
  getIt.registerLazySingleton<IAIMentorRepository>(
    () => AIMentorRepositoryImpl(remoteDataSource: getIt<IAIMentorRemoteDataSource>()),
  );
  getIt.registerLazySingleton(() => GetWellnessScoresUseCase(getIt<IAIMentorRepository>()));
  getIt.registerLazySingleton(() => LoadConversationsUseCase(getIt<IAIMentorRepository>()));
  getIt.registerLazySingleton(() => LoadConversationDetailsUseCase(getIt<IAIMentorRepository>()));
  getIt.registerLazySingleton(() => SendMessageUseCase(getIt<IAIMentorRepository>()));
  getIt.registerLazySingleton(() => UpdateConversationUseCase(getIt<IAIMentorRepository>()));
  getIt.registerLazySingleton(() => SearchConversationsUseCase(getIt<IAIMentorRepository>()));

  getIt.registerFactory(
    () => AIMentorBloc(
      getWellnessScoresUseCase: getIt<GetWellnessScoresUseCase>(),
      loadConversationsUseCase: getIt<LoadConversationsUseCase>(),
      repository: getIt<IAIMentorRepository>(),
    ),
  );
  getIt.registerFactory(
    () => ConversationBloc(
      sendMessageUseCase: getIt<SendMessageUseCase>(),
      loadConversationDetailsUseCase: getIt<LoadConversationDetailsUseCase>(),
      updateConversationUseCase: getIt<UpdateConversationUseCase>(),
    ),
  );
  getIt.registerFactory(
    () => PromptBloc(repository: getIt<IAIMentorRepository>()),
  );
  getIt.registerFactory(
    () => MentorSearchBloc(searchConversationsUseCase: getIt<SearchConversationsUseCase>()),
  );

  // Profile & User Management Feature
  getIt.registerLazySingleton<IProfileRemoteDataSource>(
    () => ProfileRemoteDataSourceImpl(getIt<ApiClient>()),
  );
  getIt.registerLazySingleton<IProfileRepository>(
    () => ProfileRepositoryImpl(remoteDataSource: getIt<IProfileRemoteDataSource>()),
  );
  getIt.registerLazySingleton(() => GetProfileUseCase(getIt<IProfileRepository>()));
  getIt.registerLazySingleton(() => UpdateProfileUseCase(getIt<IProfileRepository>()));
  getIt.registerLazySingleton(() => UploadAvatarUseCase(getIt<IProfileRepository>()));
  getIt.registerLazySingleton(() => UpdateAcademicProfileUseCase(getIt<IProfileRepository>()));
  getIt.registerLazySingleton(() => LoadStatisticsUseCase(getIt<IProfileRepository>()));
  getIt.registerLazySingleton(() => ExportDataUseCase(getIt<IProfileRepository>()));
  getIt.registerLazySingleton(() => DeleteAccountUseCase(getIt<IProfileRepository>()));
  getIt.registerLazySingleton(() => ChangePasswordUseCase(getIt<IProfileRepository>()));

  getIt.registerLazySingleton(
    () => ProfileBloc(
      getProfileUseCase: getIt<GetProfileUseCase>(),
      updateProfileUseCase: getIt<UpdateProfileUseCase>(),
      uploadAvatarUseCase: getIt<UploadAvatarUseCase>(),
      updateAcademicProfileUseCase: getIt<UpdateAcademicProfileUseCase>(),
      repository: getIt<IProfileRepository>(),
    ),
  );
  getIt.registerFactory(
    () => AccountBloc(
      exportDataUseCase: getIt<ExportDataUseCase>(),
      deleteAccountUseCase: getIt<DeleteAccountUseCase>(),
      repository: getIt<IProfileRepository>(),
    ),
  );
  getIt.registerFactory(
    () => AchievementBloc(repository: getIt<IProfileRepository>()),
  );
  getIt.registerFactory(
    () => StatisticsBloc(loadStatisticsUseCase: getIt<LoadStatisticsUseCase>()),
  );
  getIt.registerFactory(
    () => profile_security.SecurityBloc(
      changePasswordUseCase: getIt<ChangePasswordUseCase>(),
      repository: getIt<IProfileRepository>(),
    ),
  );

  // Notifications & Activity Center Feature
  getIt.registerLazySingleton(() => FCMPushNotificationService());
  getIt.registerLazySingleton(() => LocalNotificationService());

  getIt.registerLazySingleton<INotificationRemoteDataSource>(
    () => NotificationRemoteDataSourceImpl(getIt<ApiClient>()),
  );
  getIt.registerLazySingleton<INotificationRepository>(
    () => NotificationRepositoryImpl(remoteDataSource: getIt<INotificationRemoteDataSource>()),
  );

  getIt.registerLazySingleton(() => GetNotificationsUseCase(getIt<INotificationRepository>()));
  getIt.registerLazySingleton(() => GetActivityUseCase(getIt<INotificationRepository>()));
  getIt.registerLazySingleton(() => UpdateNotificationPreferencesUseCase(getIt<INotificationRepository>()));
  getIt.registerLazySingleton(() => MarkNotificationReadUseCase(getIt<INotificationRepository>()));
  getIt.registerLazySingleton(() => DeleteNotificationUseCase(getIt<INotificationRepository>()));
  getIt.registerLazySingleton(() => RegisterFCMTokenUseCase(getIt<INotificationRepository>()));

  getIt.registerFactory(
    () => NotificationBloc(
      getNotificationsUseCase: getIt<GetNotificationsUseCase>(),
      markNotificationReadUseCase: getIt<MarkNotificationReadUseCase>(),
      deleteNotificationUseCase: getIt<DeleteNotificationUseCase>(),
      repository: getIt<INotificationRepository>(),
    ),
  );
  getIt.registerFactory(
    () => ActivityBloc(getActivityUseCase: getIt<GetActivityUseCase>()),
  );
  getIt.registerFactory(
    () => NotificationPreferenceBloc(
      updateNotificationPreferencesUseCase: getIt<UpdateNotificationPreferencesUseCase>(),
      repository: getIt<INotificationRepository>(),
    ),
  );
  getIt.registerFactory(
    () => PushNotificationBloc(registerFCMTokenUseCase: getIt<RegisterFCMTokenUseCase>()),
  );

  // Files & Media Platform Feature
  getIt.registerLazySingleton<IFileRemoteDataSource>(
    () => FileRemoteDataSourceImpl(getIt<ApiClient>()),
  );
  getIt.registerLazySingleton<IFileRepository>(
    () => FileRepositoryImpl(remoteDataSource: getIt<IFileRemoteDataSource>()),
  );

  getIt.registerLazySingleton(() => GetFilesUseCase(getIt<IFileRepository>()));
  getIt.registerLazySingleton(() => UploadFileUseCase(getIt<IFileRepository>()));
  getIt.registerLazySingleton(() => DownloadFileUseCase(getIt<IFileRepository>()));
  getIt.registerLazySingleton(() => DeleteFileUseCase(getIt<IFileRepository>()));
  getIt.registerLazySingleton(() => RenameFileUseCase(getIt<IFileRepository>()));
  getIt.registerLazySingleton(() => ShareFileUseCase(getIt<IFileRepository>()));
  getIt.registerLazySingleton(() => SearchFilesUseCase(getIt<IFileRepository>()));

  getIt.registerFactory(
    () => FileBloc(
      getFilesUseCase: getIt<GetFilesUseCase>(),
      renameFileUseCase: getIt<RenameFileUseCase>(),
      deleteFileUseCase: getIt<DeleteFileUseCase>(),
      repository: getIt<IFileRepository>(),
    ),
  );
  getIt.registerFactory(() => UploadBloc(uploadFileUseCase: getIt<UploadFileUseCase>()));
  getIt.registerFactory(() => DownloadBloc(downloadFileUseCase: getIt<DownloadFileUseCase>()));
  getIt.registerFactory(() => StorageBloc(repository: getIt<IFileRepository>()));
  getIt.registerFactory(() => MediaBloc(getFilesUseCase: getIt<GetFilesUseCase>()));
  getIt.registerFactory(() => FileSearchBloc(searchFilesUseCase: getIt<SearchFilesUseCase>()));

  // Enterprise Settings, Security & Preferences Feature
  getIt.registerLazySingleton<ISettingsLocalDataSource>(
    () => SettingsLocalDataSourceImpl(
      preferencesManager: getIt<PreferencesManager>(),
      secureStorage: getIt<FlutterSecureStorage>(),
    ),
  );
  getIt.registerLazySingleton<ISettingsRemoteDataSource>(
    () => SettingsRemoteDataSourceImpl(apiClient: getIt<ApiClient>()),
  );
  getIt.registerLazySingleton<ISettingsRepository>(
    () => SettingsRepositoryImpl(
      remoteDataSource: getIt<ISettingsRemoteDataSource>(),
      localDataSource: getIt<ISettingsLocalDataSource>(),
    ),
  );

  // UseCases
  getIt.registerLazySingleton(() => GetSettingsUseCase(getIt<ISettingsRepository>()));
  getIt.registerLazySingleton(() => UpdateThemeUseCase(getIt<ISettingsRepository>()));
  getIt.registerLazySingleton(() => UpdateLanguageUseCase(getIt<ISettingsRepository>()));
  getIt.registerLazySingleton(() => UpdateAccessibilityUseCase(getIt<ISettingsRepository>()));
  getIt.registerLazySingleton(() => UpdatePreferencesUseCase(getIt<ISettingsRepository>()));
  getIt.registerLazySingleton(() => EnableBiometricUseCase(getIt<ISettingsRepository>()));
  getIt.registerLazySingleton(() => BackupDataUseCase(getIt<ISettingsRepository>()));
  getIt.registerLazySingleton(() => RestoreDataUseCase(getIt<ISettingsRepository>()));
  getIt.registerLazySingleton(() => LogoutOtherDevicesUseCase(getIt<ISettingsRepository>()));
  getIt.registerLazySingleton(() => TerminateSessionUseCase(getIt<ISettingsRepository>()));
  getIt.registerLazySingleton(() => UpdateDeveloperSettingsUseCase(getIt<ISettingsRepository>()));

  // Blocs
  getIt.registerFactory(
    () => SettingsBloc(
      getSettingsUseCase: getIt<GetSettingsUseCase>(),
      updatePreferencesUseCase: getIt<UpdatePreferencesUseCase>(),
    ),
  );
  getIt.registerSingleton<ThemeBloc>(
    ThemeBloc(
      updateThemeUseCase: getIt<UpdateThemeUseCase>(),
      updateLanguageUseCase: getIt<UpdateLanguageUseCase>(),
      updateAccessibilityUseCase: getIt<UpdateAccessibilityUseCase>(),
    ),
  );
  getIt.registerFactory(
    () => settings_security.SecurityBloc(
      enableBiometricUseCase: getIt<EnableBiometricUseCase>(),
      logoutOtherDevicesUseCase: getIt<LogoutOtherDevicesUseCase>(),
      updatePreferencesUseCase: getIt<UpdatePreferencesUseCase>(),
    ),
  );
  getIt.registerFactory(
    () => PrivacyBloc(
      repository: getIt<ISettingsRepository>(),
      updatePreferencesUseCase: getIt<UpdatePreferencesUseCase>(),
    ),
  );
  getIt.registerFactory(
    () => SessionBloc(
      repository: getIt<ISettingsRepository>(),
      terminateSessionUseCase: getIt<TerminateSessionUseCase>(),
    ),
  );
  getIt.registerFactory(
    () => BackupBloc(
      backupDataUseCase: getIt<BackupDataUseCase>(),
      restoreDataUseCase: getIt<RestoreDataUseCase>(),
    ).init(),
  );
  getIt.registerFactory(
    () => DeveloperBloc(
      updateDeveloperSettingsUseCase: getIt<UpdateDeveloperSettingsUseCase>(),
    ),
  );

  LoggerService.info('Dependency Injection Container initialized for ${env.environmentType.name}');
}







