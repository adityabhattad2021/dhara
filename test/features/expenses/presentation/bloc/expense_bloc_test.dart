import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:dartz/dartz.dart';
import 'package:dhara/core/errors/failures.dart';
import 'package:dhara/features/expenses/domain/entities/expense.dart';
import 'package:dhara/features/expenses/domain/usecases/add_expense.dart';
import 'package:dhara/features/expenses/domain/usecases/get_expenses.dart';
import 'package:dhara/features/expenses/presentation/bloc/expense_bloc.dart';
import 'package:dhara/features/expenses/presentation/bloc/expense_event.dart';
import 'package:dhara/features/expenses/presentation/bloc/expense_state.dart';

import 'expense_bloc_test.mocks.dart';

@GenerateMocks([AddExpense, GetExpenses])
void main() {
  late ExpenseBloc bloc;
  late MockAddExpense mockAddExpense;
  late MockGetExpenses mockGetExpenses;

  setUp(() {
    mockAddExpense = MockAddExpense();
    mockGetExpenses = MockGetExpenses();
    bloc = ExpenseBloc(
      addExpense: mockAddExpense,
      getExpenses: mockGetExpenses,
    );
  });

  group('ExpenseBloc', () {
    final now = DateTime.now();
    final testExpense = Expense(
      id: '1',
      amount: 100.0,
      description: 'Test',
      category: 'Food',
      date: now,
      userId: 'user123',
      createdAt: now,
      updatedAt: now,
    );

    blocTest<ExpenseBloc, ExpenseState>(
      'should emit success when expense is added',
      build: () {
        when(mockAddExpense(any))
            .thenAnswer((_) async => Right(testExpense));
        return bloc;
      },
      act: (bloc) => bloc.add(AddExpenseEvent(
        amount: 100.0,
        description: 'Test',
        category: 'Food',
        userId: 'user123',
      )),
      expect: () => [
        ExpenseLoading(),
        ExpenseAdded(testExpense),
      ],
    );

    blocTest<ExpenseBloc, ExpenseState>(
      'should emit error when adding expense fails',
      build: () {
        when(mockAddExpense(any))
            .thenAnswer((_) async => Left(DatabaseFailure()));
        return bloc;
      },
      act: (bloc) => bloc.add(AddExpenseEvent(
        amount: 100.0,
        description: 'Test',
        category: 'Food',
        userId: 'user123',
      )),
      expect: () => [
        ExpenseLoading(),
        ExpenseError('Failed to add expense'),
      ],
    );
  });
}