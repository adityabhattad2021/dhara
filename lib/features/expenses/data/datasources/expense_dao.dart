import 'package:floor/floor.dart';
import '../models/expense_model.dart';

@dao
abstract class ExpenseDao {
  @Query('SELECT * FROM expenses WHERE user_id = :userId ORDER BY created_at DESC')
  Future<List<ExpenseModel>> getExpensesByUserId(String userId);

  @insert
  Future<void> insertExpense(ExpenseModel expense);

  @update
  Future<void> updateExpense(ExpenseModel expense);

  @Query('DELETE FROM expenses WHERE id = :id')
  Future<void> deleteExpense(String id);

  @Query('SELECT * FROM expenses WHERE id = :id')
  Future<ExpenseModel?> getExpenseById(String id);
}