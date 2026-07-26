import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:nexus_ai/features/notifications/data/datasources/notification_remote_data_source.dart';
import 'package:nexus_ai/features/notifications/data/models/notification_model.dart';
import 'package:nexus_ai/features/notifications/data/repositories/notification_repository_impl.dart';

class MockNotificationRemoteDataSource extends Mock implements INotificationRemoteDataSource {}

void main() {
  late NotificationRepositoryImpl repository;
  late MockNotificationRemoteDataSource mockRemoteDataSource;

  setUp(() {
    mockRemoteDataSource = MockNotificationRemoteDataSource();
    repository = NotificationRepositoryImpl(remoteDataSource: mockRemoteDataSource);
  });

  final tModel = NotificationModel(
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

  test('getNotifications should return list of NotificationItem when remote data source is successful', () async {
    when(() => mockRemoteDataSource.getNotifications(page: 1, limit: 20)).thenAnswer((_) async => [tModel]);

    final result = await repository.getNotifications();

    expect(result.isRight(), isTrue);
    result.fold(
      (l) => fail('Should be right'),
      (list) => expect(list.first.id, equals(tModel.id)),
    );
    verify(() => mockRemoteDataSource.getNotifications(page: 1, limit: 20)).called(1);
  });
}
