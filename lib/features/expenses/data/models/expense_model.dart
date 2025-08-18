import 'package:floor/floor.dart';
import '../../domain/entities/expense.dart';
import '../converters/date_time_converter.dart';

@Entity(tableName: 'expenses')
@TypeConverters([DateTimeConverter])
class ExpenseModel {
  @PrimaryKey()
  final String id;

  final double amount;

  final String description;

  final String category;

  @ColumnInfo(name: 'date_time')
  final DateTime date;

  @ColumnInfo(name: 'user_id')
  final String userId;

  @ColumnInfo(name: 'created_at')
  final DateTime createdAt;

  @ColumnInfo(name: 'updated_at')
  final DateTime updatedAt;

  const ExpenseModel({
    required this.id,
    required this.amount,
    required this.description,
    required this.category,
    required this.date,
    required this.userId,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ExpenseModel.fromEntity(Expense expense) {
    return ExpenseModel(
      id: expense.id,
      amount: expense.amount,
      description: expense.description,
      category: expense.category,
      date: expense.date,
      userId: expense.userId,
      createdAt: expense.createdAt,
      updatedAt: expense.updatedAt,
    );
  }

  Expense toEntity() {
    return Expense(
      id: id,
      amount: amount,
      description: description,
      category: category,
      date: date,
      userId: userId,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}