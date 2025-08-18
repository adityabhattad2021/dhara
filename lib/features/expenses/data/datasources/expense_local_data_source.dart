import '../models/expense_model.dart';
import 'expense_dao.dart';

abstract class ExpenseLocalDataSource {
  Future<List<ExpenseModel>> getExpenses(String userId);
  Future<void> addExpense(ExpenseModel expense);
  Future<void> updateExpense(ExpenseModel expense);
  Future<void> deleteExpense(String expenseId);
}

class ExpenseLocalDataSourceImpl implements ExpenseLocalDataSource {
  final ExpenseDao expenseDao;

  ExpenseLocalDataSourceImpl({required this.expenseDao});

  @override
  Future<List<ExpenseModel>> getExpenses(String userId) async {
    return await expenseDao.getExpensesByUserId(userId);
  }

  @override
  Future<void> addExpense(ExpenseModel expense) async {
    await expenseDao.insertExpense(expense);
  }

  @override
  Future<void> updateExpense(ExpenseModel expense) async {
    await expenseDao.updateExpense(expense);
  }

  @override
  Future<void> deleteExpense(String expenseId) async {
    await expenseDao.deleteExpense(expenseId);
  }
}