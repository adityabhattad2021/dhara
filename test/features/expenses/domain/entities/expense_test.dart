import 'package:flutter_test/flutter_test.dart';
import 'package:dhara/features/expenses/domain/entities/expense.dart';

void main() {
  group('Expense Entity', () {
    test('should create expense with valid data', () {
      final now = DateTime.now();
      final expense = Expense(
        id: '1',
        amount: 100.0,
        description: 'Lunch',
        category: 'Food',
        date: DateTime(2024, 1, 15),
        userId: 'user123',
        createdAt: now,
        updatedAt: now,
      );

      expect(expense.amount, 100.0);
      expect(expense.description, 'Lunch');
      expect(expense.category, 'Food');
    });

    test('should validate amount is positive', () {
      final now = DateTime.now();
      expect(
        () => Expense(
          id: '1',
          amount: -10.0,
          description: 'Test',
          category: 'Food',
          date: DateTime.now(),
          userId: 'user123',
          createdAt: now,
          updatedAt: now,
        ),
        throwsA(isA<AssertionError>()),
      );
    });
  });
}