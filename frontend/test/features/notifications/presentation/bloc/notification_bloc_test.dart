import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:nexus_ai/features/notifications/domain/entities/notification_item.dart';
import 'package:nexus_ai/features/notifications/domain/repositories/i_notification_repository.dart';
import 'package:nexus_ai/features/notifications/domain/usecases/delete_notification_usecase.dart';
import 'package:nexus_ai/features/notifications/domain/usecases/get_notifications_usecase.dart';
import 'package:nexus_ai/features/notifications/domain/usecases/mark_notification_read_usecase.dart';
import 'package:nexus_ai/features/notifications/presentation/bloc/notification_bloc.dart';

class MockGetNotificationsUseCase extends Mock implements GetNotificationsUseCase {}
class MockMarkNotificationReadUseCase extends Mock implements MarkNotificationReadUseCase {}
class MockDeleteNotificationUseCase extends Mock implements DeleteNotificationUseCase {}
class MockNotificationRepository extends Mock implements INotificationRepository {}

void main() {
  late NotificationBloc bloc;
  late MockGetNotificationsUseCase mockGetNotificationsUseCase;
  late MockMarkNotificationReadUseCase mockMarkNotificationReadUseCase;
  late MockDeleteNotificationUseCase mockDeleteNotificationUseCase;
  late MockNotificationRepository mockRepository;

  setUpAll(() {
    registerFallbackValue(const GetNotificationsParams());
  });

  setUp(() {
    mockGetNotificationsUseCase = MockGetNotificationsUseCase();
    mockMarkNotificationReadUseCase = MockMarkNotificationReadUseCase();
    mockDeleteNotificationUseCase = MockDeleteNotificationUseCase();
    mockRepository = MockNotificationRepository();

    bloc = NotificationBloc(
      getNotificationsUseCase: mockGetNotificationsUseCase,
      markNotificationReadUseCase: mockMarkNotificationReadUseCase,
      deleteNotificationUseCase: mockDeleteNotificationUseCase,
      repository: mockRepository,
    );
  });

  tearDown(() {
    bloc.close();
  });

  final tNotification = NotificationItem(
    id: 'n1',
    userId: 'u1',
    title: 'Assignment Due',
    body: 'Submit by 11:59 PM',
    type: 'PLANNER',
    module: 'PLANNER',
    category: 'ASSIGNMENT',
    priority: 'HIGH',
    createdAt: DateTime.now(),
  );

  test('initial state should be NotificationInitialState', () {
    expect(bloc.state, equals(const NotificationInitialState()));
  });

  blocTest<NotificationBloc, NotificationState>(
    'emits [NotificationLoadingState, NotificationLoadedState] when LoadNotificationsEvent is added',
    build: () {
      when(() => mockGetNotificationsUseCase(any())).thenAnswer((_) async => Right([tNotification]));
      when(() => mockRepository.getUnreadCount()).thenAnswer((_) async => const Right(1));
      return bloc;
    },
    act: (b) => b.add(const LoadNotificationsEvent()),
    expect: () => [
      const NotificationLoadingState(),
      NotificationLoadedState(notifications: [tNotification], unreadCount: 1),
    ],
  );
}
