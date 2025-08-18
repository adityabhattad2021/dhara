import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../../../core/navigation/main_navigation.dart';
import '../../../../core/routes/app_routes.dart';
import '../bloc/expense_bloc.dart';
import '../bloc/expense_event.dart';
import '../bloc/expense_state.dart';

class DashboardPage extends StatefulWidget {
  final String userId;
  
  const DashboardPage({super.key, required this.userId});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  @override
  void initState() {
    super.initState();
    context.read<ExpenseBloc>().add(GetExpensesEvent(userId: widget.userId));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        automaticallyImplyLeading: false,
      ),
      body: BlocBuilder<ExpenseBloc, ExpenseState>(
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Quick Stats Cards Row
                _buildStatsSection(state),
                const SizedBox(height: 24),
                
                // Recent Transactions Section
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Recent Transactions',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextButton.icon(
                      onPressed: () {
                        Navigator.of(context).pushNamed(AppRoutes.allTransactions);
                      },
                      icon: const Icon(Icons.arrow_forward),
                      label: const Text('View All'),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                
                // Recent Transactions List
                Expanded(
                  child: _buildRecentTransactions(state),
                ),
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: const MainNavigation(),
    );
  }

  Widget _buildStatsSection(ExpenseState state) {
    if (state is ExpenseLoaded) {
      final expenses = state.expenses;
      final total = expenses.fold<double>(0, (sum, expense) => sum + expense.amount);
      final thisMonth = expenses.where((expense) =>
        expense.date.month == DateTime.now().month &&
        expense.date.year == DateTime.now().year
      ).fold<double>(0, (sum, expense) => sum + expense.amount);

      return Row(
        children: [
          Expanded(
            child: _buildStatCard(
              'Total Spent',
              '\$${total.toStringAsFixed(2)}',
              Icons.account_balance_wallet,
              Colors.red,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildStatCard(
              'This Month',
              '\$${thisMonth.toStringAsFixed(2)}',
              Icons.calendar_month,
              Colors.blue,
            ),
          ),
        ],
      );
    }

    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            'Total Spent',
            '\$0.00',
            Icons.account_balance_wallet,
            Colors.red,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatCard(
            'This Month',
            '\$0.00',
            Icons.calendar_month,
            Colors.blue,
          ),
        ),
      ],
    );
  }

  Widget _buildRecentTransactions(ExpenseState state) {
    if (state is ExpenseLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state is ExpenseLoaded) {
      final recentExpenses = state.expenses.take(5).toList();
      
      if (recentExpenses.isEmpty) {
        return Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.grey[50],
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey[200]!),
          ),
          child: const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.receipt_long_outlined, size: 48, color: Colors.grey),
                SizedBox(height: 16),
                Text('No recent transactions', style: TextStyle(fontSize: 16, color: Colors.grey)),
                SizedBox(height: 8),
                Text('Start adding expenses to see them here', style: TextStyle(fontSize: 14, color: Colors.grey)),
              ],
            ),
          ),
        );
      }

      return ListView.builder(
        itemCount: recentExpenses.length,
        itemBuilder: (context, index) {
          final expense = recentExpenses[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 8),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.deepPurple.withValues(alpha: 0.1),
                child: Text(
                  expense.category.substring(0, 1).toUpperCase(),
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              title: Text(expense.description),
              subtitle: Text('${expense.category} • ${DateFormat('MMM dd').format(expense.date)}'),
              trailing: Text(
                '\$${expense.amount.toStringAsFixed(2)}',
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ),
          );
        },
      );
    }

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.receipt_long_outlined, size: 48, color: Colors.grey),
            SizedBox(height: 16),
            Text('Loading...', style: TextStyle(fontSize: 16, color: Colors.grey)),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String title, String amount, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            amount,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
