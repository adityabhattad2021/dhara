import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dhara/features/auth/presentation/pages/sign_in_page.dart';
import 'package:dhara/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:dhara/features/auth/presentation/bloc/auth_state.dart';
import 'package:dhara/core/usecases/usecase.dart';
import 'package:dartz/dartz.dart';

import '../bloc/auth_bloc_test.mocks.dart';

void main() {
  group('SignInPage Simple Widget Tests', () {
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

    Widget makeTestableWidget() {
      return MaterialApp(
        home: BlocProvider<AuthBloc>.value(
          value: authBloc,
          child: const SignInPage(),
        ),
      );
    }

    testWidgets('should display basic UI elements', (tester) async {
      // Act
      await tester.pumpWidget(makeTestableWidget());
      await tester.pumpAndSettle(); // Wait for all animations and state changes

      // Assert - Check basic UI elements are present
      expect(find.byIcon(Icons.account_balance_wallet), findsOneWidget);
      expect(find.text('Dhara'), findsOneWidget);
      expect(find.text('Where Money Flows.'), findsOneWidget);
      
      // Look for button-related widgets more broadly
      expect(find.textContaining('Sign in'), findsWidgets);
    });

    testWidgets('should have correct scaffold structure', (tester) async {
      await tester.pumpWidget(makeTestableWidget());
      await tester.pumpAndSettle();

      // Verify main structure components
      expect(find.byType(Scaffold), findsOneWidget);
      expect(find.byType(SafeArea), findsOneWidget);
      expect(find.byType(Column), findsWidgets);
    });

    testWidgets('should show loading state correctly', (tester) async {
      // Pre-set the state to loading
      authBloc.emit(const AuthLoading());
      
      await tester.pumpWidget(makeTestableWidget());
      await tester.pump(); // Trigger one frame to update UI

      // Assert loading states
      expect(find.text('Signing In...'), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('should show error state with snackbar', (tester) async {
      await tester.pumpWidget(makeTestableWidget());
      await tester.pumpAndSettle();

      // Emit error state
      authBloc.emit(const AuthError('Test error message'));
      await tester.pump(); // Update UI
      await tester.pump(const Duration(milliseconds: 500)); // Wait for SnackBar

      // Assert error is shown
      expect(find.byType(SnackBar), findsOneWidget);
      expect(find.text('Test error message'), findsOneWidget);
    });

    testWidgets('should have proper icon styling', (tester) async {
      await tester.pumpWidget(makeTestableWidget());
      await tester.pumpAndSettle();

      // Check wallet icon
      final iconWidget = find.byIcon(Icons.account_balance_wallet);
      expect(iconWidget, findsOneWidget);
      
      final icon = tester.widget<Icon>(iconWidget);
      expect(icon.color, Colors.deepPurple);
      expect(icon.size, 80);
    });

    testWidgets('should have BlocBuilder and BlocListener', (tester) async {
      await tester.pumpWidget(makeTestableWidget());
      await tester.pumpAndSettle();

      // Verify that BlocBuilder and BlocListener are present
      expect(find.byType(BlocBuilder<AuthBloc, AuthState>), findsOneWidget);
      expect(find.byType(BlocListener<AuthBloc, AuthState>), findsWidgets); // Multiple listeners are ok
    });
  });
}