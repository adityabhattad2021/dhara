import 'package:dartz/dartz.dart';
import 'package:dhara/core/errors/failures.dart';
import '../../domain/entities/expense.dart';
import '../../domain/repositories/expense_repository.dart';
import '../datasources/expense_local_data_source.dart';
import '../models/expense_model.dart';

class ExpenseRepositoryImpl implements ExpenseRepository {
  final ExpenseLocalDataSource localDataSource;

  ExpenseRepositoryImpl({required this.localDataSource});

  @override
  Future<Either<Failure, Expense>> addExpense(Expense expense) async {
    try {
      final expenseModel = ExpenseModel.fromEntity(expense);
      await localDataSource.addExpense(expenseModel);
      return Right(expense);
    } catch (e) {
      return Left(DatabaseFailure());
    }
  }

  @override
  Future<Either<Failure, List<Expense>>> getExpenses(String userId) async {
    try {
      final expenseModels = await localDataSource.getExpenses(userId);
      final expenses = expenseModels.map((model) => model.toEntity()).toList();
      return Right(expenses);
    } catch (e) {
      return Left(DatabaseFailure());
    }
  }

  @override
  Future<Either<Failure, void>> deleteExpense(String expenseId) async {
    try {
      await localDataSource.deleteExpense(expenseId);
      return const Right(null);
    } catch (e) {
      return Left(DatabaseFailure());
    }
  }

  @override
  Future<Either<Failure, Expense>> updateExpense(Expense expense) async {
    try {
      final updatedExpense = Expense(
        id: expense.id,
        amount: expense.amount,
        description: expense.description,
        category: expense.category,
        date: expense.date,
        userId: expense.userId,
        createdAt: expense.createdAt,
        updatedAt: DateTime.now(),
      );
      
      final expenseModel = ExpenseModel.fromEntity(updatedExpense);
      await localDataSource.updateExpense(expenseModel);
      return Right(updatedExpense);
    } catch (e) {
      return Left(DatabaseFailure());
    }
  }
}