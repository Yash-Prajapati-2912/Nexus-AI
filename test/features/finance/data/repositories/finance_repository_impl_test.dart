import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:nexus_ai/features/finance/data/datasources/finance_remote_data_source.dart';
import 'package:nexus_ai/features/finance/data/models/expense_model.dart';
import 'package:nexus_ai/features/finance/data/repositories/finance_repository_impl.dart';

class MockFinanceRemoteDataSource extends Mock implements IFinanceRemoteDataSource {}

void main() {
  late FinanceRepositoryImpl repository;
  late MockFinanceRemoteDataSource mockRemoteDataSource;

  setUp(() {
    mockRemoteDataSource = MockFinanceRemoteDataSource();
    repository = FinanceRepositoryImpl(remoteDataSource: mockRemoteDataSource);
  });

  final tExpenseModel = ExpenseModel(
    id: 'exp-1',
    title: 'Textbooks',
    amount: 50.0,
    categoryId: 'c1',
    categoryName: 'Edu',
    categoryIcon: 'school',
    date: DateTime(2026, 7, 26),
  );

  test('should return list of expenses when remoteDataSource completes successfully', () async {
    when(() => mockRemoteDataSource.getExpenses()).thenAnswer((_) async => [tExpenseModel]);

    final result = await repository.getExpenses();

    expect(result.isRight(), isTrue);
    result.fold(
      (l) => fail('Should be Right'),
      (r) => expect(r, equals([tExpenseModel])),
    );
    verify(() => mockRemoteDataSource.getExpenses()).called(1);
  });
}
