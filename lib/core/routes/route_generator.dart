import 'package:flutter/material.dart';
import '../../features/auth/presentation/pages/sign_in_page.dart';
import '../../features/dashboard/presentation/pages/all_transactions_page.dart';
import '../../features/dashboard/presentation/pages/dashboard_page.dart';
import '../../features/add_expense/presentation/pages/add_expense_page.dart';
import '../../features/passbook_chat/presentation/pages/chat_page.dart';
import '../../features/settings/presentation/pages/settings_page.dart';
import 'app_routes.dart';
import 'route_guard.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.signIn:
        return MaterialPageRoute(
          builder: (_) => const SignInPage(),
          settings: settings,
        );

      case AppRoutes.dashboard:
        return MaterialPageRoute(
          builder: (context) => RouteGuard.guardRoute(
            context: context,
            child: const DashboardContent(),
            routeName: AppRoutes.dashboard,
          ),
          settings: settings,
        );

      case AppRoutes.addExpense:
        return MaterialPageRoute(
          builder: (context) => RouteGuard.guardRoute(
            context: context,
            child: const AddExpenseContent(),
            routeName: AppRoutes.addExpense,
          ),
          settings: settings,
        );

      case AppRoutes.allTransactions:
        return MaterialPageRoute(
          builder: (context) => RouteGuard.guardRoute(
            context: context,
            child: const AllTransactionsPage(),
            routeName: AppRoutes.allTransactions,
          ),
          settings: settings,
        );

      case AppRoutes.passbookChat:
        return MaterialPageRoute(
          builder: (context) => RouteGuard.guardRoute(
            context: context,
            child: const ChatContent(),
            routeName: AppRoutes.passbookChat,
          ),
          settings: settings,
        );

      case AppRoutes.settings:
        return MaterialPageRoute(
          builder: (context) => RouteGuard.guardRoute(
            context: context,
            child: const SettingsContent(),
            routeName: AppRoutes.settings,
          ),
          settings: settings,
        );

      default:
        return MaterialPageRoute(
          builder: (_) => const _NotFoundPage(),
          settings: settings,
        );
    }
  }
}

class _NotFoundPage extends StatelessWidget {
  const _NotFoundPage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Page Not Found'),
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 80, color: Colors.red),
            SizedBox(height: 24),
            Text(
              '404 - Page Not Found',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Text(
              'The page you are looking for does not exist.',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
