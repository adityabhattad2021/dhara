import 'package:equatable/equatable.dart';

class Expense extends Equatable {
  final String id;
  final double amount;
  final String description;
  final String category;
  final DateTime date;
  final String userId;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Expense({
    required this.id,
    required this.amount,
    required this.description,
    required this.category,
    required this.date,
    required this.userId,
    required this.createdAt,
    required this.updatedAt,
  }) : assert(amount > 0, 'Amount must be positive');

  @override
  List<Object?> get props => [
        id,
        amount,
        description,
        category,
        date,
        userId,
        createdAt,
        updatedAt,
      ];
}