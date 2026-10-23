import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'admin_auth_event.dart';
import 'admin_auth_state.dart';

class AdminAuthBloc extends Bloc<AdminAuthEvent, AdminAuthState> {
  final SharedPreferences prefs;

  AdminAuthBloc(this.prefs) : super(AdminAuthInitial()) {
    on<AdminLoginRequested>(_onLoginRequested);
    on<AdminLogoutRequested>(_onLogoutRequested);
  }

  Future<void> _onLoginRequested(
    AdminLoginRequested event,
    Emitter<AdminAuthState> emit,
  ) async {
    emit(AdminAuthLoading());
    await Future.delayed(const Duration(milliseconds: 800));

    if (event.email == 'admin@nexusai.com' && event.password == 'Admin@12345') {
      await prefs.setString('admin_jwt_token', 'mock_admin_token');
      emit(const AdminAuthenticated('admin@nexusai.com', 'SuperAdmin'));
    } else {
      emit(const AdminAuthFailure('Invalid admin credentials'));
    }
  }

  Future<void> _onLogoutRequested(
    AdminLogoutRequested event,
    Emitter<AdminAuthState> emit,
  ) async {
    await prefs.remove('admin_jwt_token');
    emit(AdminUnauthenticated());
  }
}
