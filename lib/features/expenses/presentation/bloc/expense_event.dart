import 'package:equatable/equatable.dart';

abstract class ExpenseEvent extends Equatable {
  const ExpenseEvent();

  @override
  List<Object?> get props => [];
}

class AddExpenseEvent extends ExpenseEvent {
  final double amount;
  final String description;
  final String category;
  final String userId;
  final DateTime? date;

  const AddExpenseEvent({
    required this.amount,
    required this.description,
    required this.category,
    required this.userId,
    this.date,
  });

  @override
  List<Object?> get props => [amount, description, category, userId, date];
}

class GetExpensesEvent extends ExpenseEvent {
  final String userId;

  const GetExpensesEvent({required this.userId});

  @override
  List<Object?> get props => [userId];
}

class DeleteExpenseEvent extends ExpenseEvent {
  final String expenseId;

  const DeleteExpenseEvent({required this.expenseId});

  @override
  List<Object?> get props => [expenseId];
}