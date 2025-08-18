import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dhara/core/routes/route_guard.dart';
import 'package:dhara/core/routes/app_routes.dart';
import 'package:dhara/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:dhara/features/auth/presentation/bloc/auth_state.dart';
import 'package:dhara/features/auth/presentation/pages/sign_in_page.dart';
import 'package:dhara/features/auth/domain/entities/user.dart';

import '../../features/auth/presentation/bloc/auth_bloc_test.mocks.dart';

void main() {
  group('RouteGuard Tests', () {
    late MockSignInWithGoogle mockSignInWithGoogle;
    late MockSignOut mockSignOut;
    late MockGetCurrentUser mockGetCurrentUser;
    late AuthBloc authBloc;

    setUp(() {
      mockSignInWithGoogle = MockSignInWithGoogle();
      mockSignOut = MockSignOut();
      mockGetCurrentUser = MockGetCurrentUser();
      
      authBloc = AuthBloc(
        signInWithGoogle: mockSignInWithGoogle,
        signOut: mockSignOut,
        getCurrentUser: mockGetCurrentUser,
      );
    });

    tearDown(() {
      authBloc.close();
    });

    final tUser = User(
      id: 'test_id',
      email: 'test@example.com',
      displayName: 'Test User',
      createdAt: DateTime.now(),
      lastLoginAt: DateTime.now(),
    );

    Widget makeTestableWidget(Widget child, String routeName) {
      return BlocProvider<AuthBloc>.value(
        value: authBloc,
        child: MaterialApp(
          routes: {
            AppRoutes.signIn: (context) => const SignInPage(),
            '/test': (context) => Scaffold(
              body: RouteGuard.guardRoute(
                context: context,
                childBuilder: (userId) => child,
                routeName: routeName,
              ),
            ),
          },
          initialRoute: '/test',
        ),
      );
    }

    group('Protected Route Detection', () {
      test('should identify protected routes correctly', () {
        expect(RouteGuard.isProtectedRoute(AppRoutes.dashboard), isTrue);
        expect(RouteGuard.isProtectedRoute(AppRoutes.addExpense), isTrue);
        expect(RouteGuard.isProtectedRoute(AppRoutes.allTransactions), isTrue);
        expect(RouteGuard.isProtectedRoute(AppRoutes.passbookChat), isTrue);
        expect(RouteGuard.isProtectedRoute(AppRoutes.settings), isTrue);
        expect(RouteGuard.isProtectedRoute(AppRoutes.signIn), isFalse);
        expect(RouteGuard.isProtectedRoute('/unknown'), isFalse);
        expect(RouteGuard.isProtectedRoute(null), isFalse);
      });
    });

    group('Route Guard Widget Behavior', () {
      final testWidget = Container(
        key: const Key('test_child'),
        child: const Text('Protected Content'),
      );

      testWidgets('should show child widget when authenticated and accessing protected route', (tester) async {
        // Set authenticated state
        authBloc.emit(AuthAuthenticated(tUser));

        await tester.pumpWidget(makeTestableWidget(testWidget, AppRoutes.dashboard));
        await tester.pump();

        expect(find.byKey(const Key('test_child')), findsOneWidget);
        expect(find.text('Protected Content'), findsOneWidget);
      });

      testWidgets('should show loading guard when unauthenticated and accessing protected route', (tester) async {
        // Set unauthenticated state
        authBloc.emit(const AuthUnauthenticated());

        await tester.pumpWidget(makeTestableWidget(testWidget, AppRoutes.dashboard));
        await tester.pump();

        // Should show loading guard instead of protected content
        expect(find.byType(CircularProgressIndicator), findsOneWidget);
        expect(find.text('Checking authentication...'), findsOneWidget);
        expect(find.byKey(const Key('test_child')), findsNothing);
      });

      testWidgets('should show loading guard when auth error and accessing protected route', (tester) async {
        // Set error state
        authBloc.emit(const AuthError('Authentication failed'));

        await tester.pumpWidget(makeTestableWidget(testWidget, AppRoutes.dashboard));
        await tester.pump();

        // Should show loading guard instead of protected content
        expect(find.byType(CircularProgressIndicator), findsOneWidget);
        expect(find.text('Checking authentication...'), findsOneWidget);
        expect(find.byKey(const Key('test_child')), findsNothing);
      });

      testWidgets('should show loading guard when auth loading and accessing protected route', (tester) async {
        // Set loading state
        authBloc.emit(const AuthLoading());

        await tester.pumpWidget(makeTestableWidget(testWidget, AppRoutes.dashboard));
        await tester.pump();

        // Should show loading indicator
        expect(find.byType(CircularProgressIndicator), findsOneWidget);
        expect(find.text('Checking authentication...'), findsOneWidget);
        expect(find.byKey(const Key('test_child')), findsNothing);
      });

      testWidgets('should always show child widget for non-protected routes', (tester) async {
        // Set unauthenticated state
        authBloc.emit(const AuthUnauthenticated());

        await tester.pumpWidget(makeTestableWidget(testWidget, AppRoutes.signIn));
        await tester.pump();

        // Should show child widget regardless of auth state
        expect(find.byKey(const Key('test_child')), findsOneWidget);
        expect(find.text('Protected Content'), findsOneWidget);
      });
    });

    group('Loading Guard Widget', () {
      testWidgets('should display loading indicator with proper styling', (tester) async {
        authBloc.emit(const AuthLoading());

        await tester.pumpWidget(makeTestableWidget(
          const Text('Should not show'), 
          AppRoutes.dashboard,
        ));
        await tester.pump();

        // Verify loading UI
        expect(find.byType(Scaffold), findsWidgets);
        expect(find.byType(CircularProgressIndicator), findsOneWidget);
        expect(find.text('Checking authentication...'), findsOneWidget);
        
        // Check spinner styling
        final progressIndicator = tester.widget<CircularProgressIndicator>(
          find.byType(CircularProgressIndicator),
        );
        expect(progressIndicator.valueColor?.value, Colors.deepPurple);
      });

      testWidgets('should center loading content properly', (tester) async {
        authBloc.emit(const AuthLoading());

        await tester.pumpWidget(makeTestableWidget(
          const Text('Should not show'), 
          AppRoutes.settings,
        ));
        await tester.pump();

        // Check layout structure
        expect(find.byType(Center), findsOneWidget);
        expect(find.byType(Column), findsOneWidget);
        
        final column = tester.widget<Column>(find.byType(Column));
        expect(column.mainAxisAlignment, MainAxisAlignment.center);
      });
    });

    group('State Transitions', () {
      testWidgets('should handle state changes correctly', (tester) async {
        final testWidget = Container(
          key: const Key('protected_content'),
          child: const Text('Dashboard Content'),
        );

        await tester.pumpWidget(makeTestableWidget(testWidget, AppRoutes.dashboard));

        // Start with loading
        authBloc.emit(const AuthLoading());
        await tester.pump();
        expect(find.text('Checking authentication...'), findsOneWidget);
        expect(find.byKey(const Key('protected_content')), findsNothing);

        // Change to authenticated
        authBloc.emit(AuthAuthenticated(tUser));
        await tester.pump();
        expect(find.byKey(const Key('protected_content')), findsOneWidget);
        expect(find.text('Dashboard Content'), findsOneWidget);

        // Change to unauthenticated
        authBloc.emit(const AuthUnauthenticated());
        await tester.pump();
        expect(find.text('Checking authentication...'), findsOneWidget); // Loading guard
        expect(find.byKey(const Key('protected_content')), findsNothing);
      });
    });
  });
}