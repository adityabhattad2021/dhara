import 'package:dartz/dartz.dart';
import 'package:dhara/core/errors/failures.dart';
import '../entities/expense.dart';

abstract class ExpenseRepository {
  Future<Either<Failure, Expense>> addExpense(Expense expense);
  Future<Either<Failure, List<Expense>>> getExpenses(String userId);
  Future<Either<Failure, void>> deleteExpense(String expenseId);
  Future<Either<Failure, Expense>> updateExpense(Expense expense);
}