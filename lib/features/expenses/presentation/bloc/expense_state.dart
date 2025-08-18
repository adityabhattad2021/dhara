import 'package:equatable/equatable.dart';
import '../../domain/entities/expense.dart';

abstract class ExpenseState extends Equatable {
  const ExpenseState();

  @override
  List<Object?> get props => [];
}

class ExpenseInitial extends ExpenseState {}

class ExpenseLoading extends ExpenseState {}

class ExpenseLoaded extends ExpenseState {
  final List<Expense> expenses;

  const ExpenseLoaded({required this.expenses});

  @override
  List<Object?> get props => [expenses];
}

class ExpenseAdded extends ExpenseState {
  final Expense expense;

  const ExpenseAdded(this.expense);

  @override
  List<Object?> get props => [expense];
}

class ExpenseDeleted extends ExpenseState {
  final String expenseId;

  const ExpenseDeleted({required this.expenseId});

  @override
  List<Object?> get props => [expenseId];
}

class ExpenseError extends ExpenseState {
  final String message;

  const ExpenseError(this.message);

  @override
  List<Object?> get props => [message];
}