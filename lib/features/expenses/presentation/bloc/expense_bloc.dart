import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/add_expense.dart';
import '../../domain/usecases/get_expenses.dart';
import 'expense_event.dart';
import 'expense_state.dart';

class ExpenseBloc extends Bloc<ExpenseEvent, ExpenseState> {
  final AddExpense addExpense;
  final GetExpenses getExpenses;

  ExpenseBloc({
    required this.addExpense,
    required this.getExpenses,
  }) : super(ExpenseInitial()) {
    on<AddExpenseEvent>(_onAddExpense);
    on<GetExpensesEvent>(_onGetExpenses);
    on<DeleteExpenseEvent>(_onDeleteExpense);
  }

  Future<void> _onAddExpense(
    AddExpenseEvent event,
    Emitter<ExpenseState> emit,
  ) async {
    emit(ExpenseLoading());

    final result = await addExpense(AddExpenseParams(
      amount: event.amount,
      description: event.description,
      category: event.category,
      userId: event.userId,
      date: event.date,
    ));

    result.fold(
      (failure) => emit(ExpenseError('Failed to add expense')),
      (expense) => emit(ExpenseAdded(expense)),
    );
  }

  Future<void> _onGetExpenses(
    GetExpensesEvent event,
    Emitter<ExpenseState> emit,
  ) async {
    emit(ExpenseLoading());

    final result = await getExpenses(GetExpensesParams(userId: event.userId));

    result.fold(
      (failure) => emit(ExpenseError('Failed to load expenses')),
      (expenses) => emit(ExpenseLoaded(expenses: expenses)),
    );
  }

  Future<void> _onDeleteExpense(
    DeleteExpenseEvent event,
    Emitter<ExpenseState> emit,
  ) async {
    emit(ExpenseLoading());

    emit(ExpenseDeleted(expenseId: event.expenseId));
  }
}