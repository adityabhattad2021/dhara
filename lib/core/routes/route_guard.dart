import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../features/auth/presentation/bloc/auth_bloc.dart';
import '../../features/auth/presentation/bloc/auth_state.dart';
import '../../features/auth/presentation/pages/sign_in_page.dart';
import 'app_routes.dart';

class RouteGuard {
  static final List<String> _protectedRoutes = [
    AppRoutes.dashboard,
    AppRoutes.addExpense,
    AppRoutes.allTransactions,
    AppRoutes.passbookChat,
    AppRoutes.settings,
  ];

  static bool isProtectedRoute(String? routeName) {
    return _protectedRoutes.contains(routeName);
  }

  static Widget guardRoute({
    required BuildContext context,
    required Widget child,
    required String routeName,
  }) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (isProtectedRoute(routeName)) {
          if (state is AuthAuthenticated) {
            return child;
          } else if (state is AuthUnauthenticated || state is AuthError) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              Navigator.of(
                context,
              ).pushNamedAndRemoveUntil(AppRoutes.signIn, (route) => false);
            });
            return const SignInPage();
          } else {
            return const _LoadingGuard();
          }
        }
        return child;
      },
    );
  }
}

class _LoadingGuard extends StatelessWidget {
  const _LoadingGuard();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.deepPurple),
            ),
            SizedBox(height: 16),
            Text(
              'Checking authentication...',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
