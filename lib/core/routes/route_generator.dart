import 'package:flutter/material.dart';
import '../../features/auth/presentation/pages/sign_in_page.dart';
import '../../features/expenses/presentation/pages/all_transactions_page.dart';
import '../../features/expenses/presentation/pages/dashboard_page.dart';
import '../../features/expenses/presentation/pages/add_expense_page.dart';
import '../../features/passbook_chat/presentation/pages/chat_page.dart';
import '../../features/settings/presentation/pages/settings_page.dart';
import 'app_routes.dart';
import 'route_guard.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.signIn:
        return PageRouteBuilder(
          settings: settings,
          pageBuilder: (context, animation, secondaryAnimation) => const SignInPage(),
          transitionDuration: Duration.zero,
          reverseTransitionDuration: Duration.zero,
        );

      case AppRoutes.dashboard:
        return PageRouteBuilder(
          settings: settings,
          pageBuilder: (context, animation, secondaryAnimation) => RouteGuard.guardRoute(
            context: context,
            childBuilder: (userId) => DashboardPage(userId: userId),
            routeName: AppRoutes.dashboard,
          ),
          transitionDuration: Duration.zero,
          reverseTransitionDuration: Duration.zero,
        );

      case AppRoutes.addExpense:
        return PageRouteBuilder(
          settings: settings,
          pageBuilder: (context, animation, secondaryAnimation) => RouteGuard.guardRoute(
            context: context,
            childBuilder: (userId) => AddExpenseContent(userId: userId),
            routeName: AppRoutes.addExpense,
          ),
          transitionDuration: Duration.zero,
          reverseTransitionDuration: Duration.zero,
        );

      case AppRoutes.allTransactions:
        return PageRouteBuilder(
          settings: settings,
          pageBuilder: (context, animation, secondaryAnimation) => RouteGuard.guardRoute(
            context: context,
            childBuilder: (userId) => AllTransactionsContent(userId: userId),
            routeName: AppRoutes.allTransactions,
          ),
          transitionDuration: Duration.zero,
          reverseTransitionDuration: Duration.zero,
        );

      case AppRoutes.passbookChat:
        return PageRouteBuilder(
          settings: settings,
          pageBuilder: (context, animation, secondaryAnimation) => RouteGuard.guardRoute(
            context: context,
            childBuilder: (userId) => const ChatPage(),
            routeName: AppRoutes.passbookChat,
          ),
          transitionDuration: Duration.zero,
          reverseTransitionDuration: Duration.zero,
        );

      case AppRoutes.settings:
        return PageRouteBuilder(
          settings: settings,
          pageBuilder: (context, animation, secondaryAnimation) => RouteGuard.guardRoute(
            context: context,
            childBuilder: (userId) => const SettingsPage(),
            routeName: AppRoutes.settings,
          ),
          transitionDuration: Duration.zero,
          reverseTransitionDuration: Duration.zero,
        );

      default:
        return PageRouteBuilder(
          settings: settings,
          pageBuilder: (context, animation, secondaryAnimation) => const _NotFoundPage(),
          transitionDuration: Duration.zero,
          reverseTransitionDuration: Duration.zero,
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
