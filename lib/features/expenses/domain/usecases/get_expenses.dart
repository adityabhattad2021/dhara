import 'package:dartz/dartz.dart';
import 'package:dhara/core/errors/failures.dart';
import 'package:dhara/core/usecases/usecase.dart';
import '../entities/expense.dart';
import '../repositories/expense_repository.dart';

class GetExpenses implements UseCase<List<Expense>, GetExpensesParams> {
  final ExpenseRepository repository;

  GetExpenses(this.repository);

  @override
  Future<Either<Failure, List<Expense>>> call(GetExpensesParams params) async {
    return await repository.getExpenses(params.userId);
  }
}

class GetExpensesParams {
  final String userId;

  GetExpensesParams({required this.userId});
}