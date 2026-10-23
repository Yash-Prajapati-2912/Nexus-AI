import 'dart:async';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:nexus_ai_admin/features/auth/presentation/bloc/admin_auth_bloc.dart';
import 'package:nexus_ai_admin/features/auth/presentation/bloc/admin_auth_event.dart';
import 'package:nexus_ai_admin/features/auth/presentation/bloc/admin_auth_state.dart';

void main() {
  late AdminAuthBloc authBloc;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    authBloc = AdminAuthBloc(prefs);
  });

  tearDown(() {
    authBloc.close();
  });

  test('initial state should be AdminAuthInitial', () {
    expect(authBloc.state, equals(AdminAuthInitial()));
  });

  test('emits [AdminAuthLoading, AdminAuthenticated] on valid login credentials', () async {
    final expectedStates = [
      AdminAuthLoading(),
      const AdminAuthenticated('admin@nexusai.com', 'SuperAdmin'),
    ];

    unawaited(expectLater(authBloc.stream, emitsInOrder(expectedStates)));

    authBloc.add(const AdminLoginRequested('admin@nexusai.com', 'Admin@12345'));
  });
}
