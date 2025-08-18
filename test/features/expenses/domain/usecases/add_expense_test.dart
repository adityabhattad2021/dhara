import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:dartz/dartz.dart';
import 'package:dhara/core/errors/failures.dart';
import 'package:dhara/features/expenses/domain/entities/expense.dart';
import 'package:dhara/features/expenses/domain/repositories/expense_repository.dart';
import 'package:dhara/features/expenses/domain/usecases/add_expense.dart';

import 'add_expense_test.mocks.dart';

@GenerateMocks([ExpenseRepository])
void main() {
  late AddExpense usecase;
  late MockExpenseRepository mockRepository;

  setUp(() {
    mockRepository = MockExpenseRepository();
    usecase = AddExpense(mockRepository);
  });

  group('AddExpense UseCase', () {
    final now = DateTime.now();
    final testExpense = Expense(
      id: '1',
      amount: 100.0,
      description: 'Test expense',
      category: 'Food',
      date: now,
      userId: 'user123',
      createdAt: now,
      updatedAt: now,
    );

    test('should add expense successfully', () async {
      when(mockRepository.addExpense(any))
          .thenAnswer((_) async => Right(testExpense));

      final result = await usecase(AddExpenseParams(
        amount: 100.0,
        description: 'Test expense',
        category: 'Food',
        userId: 'user123',
      ));

      expect(result, Right(testExpense));
      verify(mockRepository.addExpense(any)).called(1);
    });

    test('should return failure when repository fails', () async {
      when(mockRepository.addExpense(any))
          .thenAnswer((_) async => Left(DatabaseFailure()));

      final result = await usecase(AddExpenseParams(
        amount: 100.0,
        description: 'Test expense',
        category: 'Food',
        userId: 'user123',
      ));

      expect(result.isLeft(), true);
    });
  });
}