import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:dartz/dartz.dart';
import 'package:dhara/core/errors/failures.dart';
import 'package:dhara/features/expenses/domain/entities/expense.dart';
import 'package:dhara/features/expenses/domain/repositories/expense_repository.dart';
import 'package:dhara/features/expenses/domain/usecases/get_expenses.dart';

import 'add_expense_test.mocks.dart';

void main() {
  late GetExpenses usecase;
  late MockExpenseRepository mockRepository;

  setUp(() {
    mockRepository = MockExpenseRepository();
    usecase = GetExpenses(mockRepository);
  });

  group('GetExpenses UseCase', () {
    final now = DateTime.now();
    final testExpenses = [
      Expense(
        id: '1',
        amount: 100.0,
        description: 'Test 1',
        category: 'Food',
        date: now,
        userId: 'user123',
        createdAt: now,
        updatedAt: now,
      ),
    ];

    test('should get expenses for user', () async {
      when(mockRepository.getExpenses('user123'))
          .thenAnswer((_) async => Right(testExpenses));

      final result = await usecase(GetExpensesParams(userId: 'user123'));

      expect(result, Right(testExpenses));
    });

    test('should return failure when repository fails', () async {
      when(mockRepository.getExpenses('user123'))
          .thenAnswer((_) async => Left(DatabaseFailure()));

      final result = await usecase(GetExpensesParams(userId: 'user123'));

      expect(result.isLeft(), true);
    });
  });
}