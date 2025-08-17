import 'package:flutter/material.dart';
import '../../../../core/navigation/main_navigation.dart';

class AddExpenseContent extends StatelessWidget {
  const AddExpenseContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Expense'),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        automaticallyImplyLeading: false,
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.add_circle_outline, size: 80, color: Colors.green),
            SizedBox(height: 24),
            Text(
              'Add Expense',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 32.0),
              child: Text(
                'Quick expense entry with natural language processing',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            ),
            SizedBox(height: 32),
            Text(
              '• Natural language input\n• Auto-categorization\n• Smart amount detection\n• Quick photo capture',
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const MainNavigation(),
    );
  }
}
