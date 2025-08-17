import 'package:flutter/material.dart';
import '../routes/app_routes.dart';

class MainNavigation extends StatelessWidget {
  const MainNavigation({super.key});

  int _getCurrentIndex(BuildContext context) {
    final currentRoute = ModalRoute.of(context)?.settings.name;

    switch (currentRoute) {
      case AppRoutes.dashboard:
        return 0;
      case AppRoutes.addExpense:
        return 1;
      case AppRoutes.passbookChat:
        return 2;
      case AppRoutes.settings:
        return 3;
      default:
        return 0;
    }
  }

  void _onTabTapped(int index, BuildContext context) {
    final routes = [
      AppRoutes.dashboard,
      AppRoutes.addExpense,
      AppRoutes.passbookChat,
      AppRoutes.settings,
    ];

    final targetRoute = routes[index];
    final currentRoute = ModalRoute.of(context)?.settings.name;

    if (targetRoute != currentRoute) {
      Navigator.of(context).pushReplacementNamed(targetRoute);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      currentIndex: _getCurrentIndex(context),
      onTap: (index) => _onTabTapped(index, context),
      selectedItemColor: Colors.deepPurple,
      unselectedItemColor: Colors.grey,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.dashboard),
          label: 'Dashboard',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.add_circle_outline),
          label: 'Add Expense',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.chat_bubble_outline),
          label: 'Chat',
        ),
        BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Settings'),
      ],
    );
  }
}