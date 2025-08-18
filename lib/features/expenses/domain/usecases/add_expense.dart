import 'package:dartz/dartz.dart';
import 'package:dhara/core/errors/failures.dart';
import 'package:dhara/core/usecases/usecase.dart';
import '../entities/expense.dart';
import '../repositories/expense_repository.dart';

class AddExpense implements UseCase<Expense, AddExpenseParams> {
  final ExpenseRepository repository;

  AddExpense(this.repository);

  @override
  Future<Either<Failure, Expense>> call(AddExpenseParams params) async {
    final now = DateTime.now();
    final expense = Expense(
      id: now.millisecondsSinceEpoch.toString(),
      amount: params.amount,
      description: params.description,
      category: params.category,
      date: params.date ?? now,
      userId: params.userId,
      createdAt: now,
      updatedAt: now,
    );

    return await repository.addExpense(expense);
  }
}

class AddExpenseParams {
  final double amount;
  final String description;
  final String category;
  final String userId;
  final DateTime? date;

  AddExpenseParams({
    required this.amount,
    required this.description,
    required this.category,
    required this.userId,
    this.date,
  });
}