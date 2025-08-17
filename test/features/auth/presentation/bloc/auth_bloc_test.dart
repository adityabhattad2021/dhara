import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:dartz/dartz.dart';
import 'package:dhara/core/errors/failures.dart';
import 'package:dhara/core/usecases/usecase.dart';
import 'package:dhara/features/auth/domain/entities/user.dart';
import 'package:dhara/features/auth/domain/usecases/get_current_user.dart';
import 'package:dhara/features/auth/domain/usecases/sign_in_with_google.dart';
import 'package:dhara/features/auth/domain/usecases/sign_out.dart';
import 'package:dhara/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:dhara/features/auth/presentation/bloc/auth_event.dart';
import 'package:dhara/features/auth/presentation/bloc/auth_state.dart';

import 'auth_bloc_test.mocks.dart';

@GenerateMocks([SignInWithGoogle, SignOut, GetCurrentUser])
void main() {
  late AuthBloc authBloc;
  late MockSignInWithGoogle mockSignInWithGoogle;
  late MockSignOut mockSignOut;
  late MockGetCurrentUser mockGetCurrentUser;

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

  group('AuthBloc', () {
    final tUser = User(
      id: 'test_id',
      email: 'test@example.com',
      displayName: 'Test User',
      createdAt: DateTime.now(),
      lastLoginAt: DateTime.now(),
    );

    test('initial state should be AuthInitial', () {
      expect(authBloc.state, const AuthInitial());
    });

    group('AuthStarted', () {
      blocTest<AuthBloc, AuthState>(
        'should emit [AuthLoading, AuthAuthenticated] when user is already signed in',
        build: () {
          when(mockGetCurrentUser(const NoParams()))
              .thenAnswer((_) async => Right(tUser));
          return authBloc;
        },
        act: (bloc) => bloc.add(const AuthStarted()),
        expect: () => [
          const AuthLoading(),
          AuthAuthenticated(tUser),
        ],
        verify: (_) {
          verify(mockGetCurrentUser(const NoParams())).called(1);
        },
      );

      blocTest<AuthBloc, AuthState>(
        'should emit [AuthLoading, AuthUnauthenticated] when no user is signed in',
        build: () {
          when(mockGetCurrentUser(const NoParams()))
              .thenAnswer((_) async => const Right(null));
          return authBloc;
        },
        act: (bloc) => bloc.add(const AuthStarted()),
        expect: () => [
          const AuthLoading(),
          const AuthUnauthenticated(),
        ],
        verify: (_) {
          verify(mockGetCurrentUser(const NoParams())).called(1);
        },
      );

      blocTest<AuthBloc, AuthState>(
        'should emit [AuthLoading, AuthError] when getCurrentUser fails',
        build: () {
          when(mockGetCurrentUser(const NoParams()))
              .thenAnswer((_) async => const Left(AuthFailure(message: 'Auth service error')));
          return authBloc;
        },
        act: (bloc) => bloc.add(const AuthStarted()),
        expect: () => [
          const AuthLoading(),
          const AuthError('Auth service error'),
        ],
        verify: (_) {
          verify(mockGetCurrentUser(const NoParams())).called(1);
        },
      );
    });

    group('AuthSignInWithGoogleRequested', () {
      blocTest<AuthBloc, AuthState>(
        'should emit [AuthLoading, AuthAuthenticated] when sign in is successful',
        build: () {
          when(mockSignInWithGoogle(const NoParams()))
              .thenAnswer((_) async => Right(tUser));
          return authBloc;
        },
        act: (bloc) => bloc.add(const AuthSignInWithGoogleRequested()),
        expect: () => [
          const AuthLoading(),
          AuthAuthenticated(tUser),
        ],
        verify: (_) {
          verify(mockSignInWithGoogle(const NoParams())).called(1);
        },
      );

      blocTest<AuthBloc, AuthState>(
        'should emit [AuthLoading, AuthError] when sign in fails',
        build: () {
          when(mockSignInWithGoogle(const NoParams()))
              .thenAnswer((_) async => const Left(AuthFailure(message: 'Sign in cancelled')));
          return authBloc;
        },
        act: (bloc) => bloc.add(const AuthSignInWithGoogleRequested()),
        expect: () => [
          const AuthLoading(),
          const AuthError('Sign in cancelled'),
        ],
        verify: (_) {
          verify(mockSignInWithGoogle(const NoParams())).called(1);
        },
      );

      blocTest<AuthBloc, AuthState>(
        'should emit [AuthLoading, AuthError] when network error occurs',
        build: () {
          when(mockSignInWithGoogle(const NoParams()))
              .thenAnswer((_) async => const Left(AuthFailure(message: 'No internet connection')));
          return authBloc;
        },
        act: (bloc) => bloc.add(const AuthSignInWithGoogleRequested()),
        expect: () => [
          const AuthLoading(),
          const AuthError('No internet connection'),
        ],
        verify: (_) {
          verify(mockSignInWithGoogle(const NoParams())).called(1);
        },
      );
    });

    group('AuthSignOutRequested', () {
      blocTest<AuthBloc, AuthState>(
        'should emit [AuthLoading, AuthUnauthenticated] when sign out is successful',
        build: () {
          when(mockSignOut(const NoParams()))
              .thenAnswer((_) async => const Right(null));
          return authBloc;
        },
        act: (bloc) => bloc.add(const AuthSignOutRequested()),
        expect: () => [
          const AuthLoading(),
          const AuthUnauthenticated(),
        ],
        verify: (_) {
          verify(mockSignOut(const NoParams())).called(1);
        },
      );

      blocTest<AuthBloc, AuthState>(
        'should emit [AuthLoading, AuthError] when sign out fails',
        build: () {
          when(mockSignOut(const NoParams()))
              .thenAnswer((_) async => const Left(AuthFailure(message: 'Sign out failed')));
          return authBloc;
        },
        act: (bloc) => bloc.add(const AuthSignOutRequested()),
        expect: () => [
          const AuthLoading(),
          const AuthError('Sign out failed'),
        ],
        verify: (_) {
          verify(mockSignOut(const NoParams())).called(1);
        },
      );
    });

    group('AuthUserChanged', () {
      blocTest<AuthBloc, AuthState>(
        'should emit [AuthAuthenticated] when user is found',
        build: () {
          when(mockGetCurrentUser(const NoParams()))
              .thenAnswer((_) async => Right(tUser));
          return authBloc;
        },
        act: (bloc) => bloc.add(const AuthUserChanged()),
        expect: () => [
          AuthAuthenticated(tUser),
        ],
        verify: (_) {
          verify(mockGetCurrentUser(const NoParams())).called(1);
        },
      );

      blocTest<AuthBloc, AuthState>(
        'should emit [AuthUnauthenticated] when no user is found',
        build: () {
          when(mockGetCurrentUser(const NoParams()))
              .thenAnswer((_) async => const Right(null));
          return authBloc;
        },
        act: (bloc) => bloc.add(const AuthUserChanged()),
        expect: () => [
          const AuthUnauthenticated(),
        ],
        verify: (_) {
          verify(mockGetCurrentUser(const NoParams())).called(1);
        },
      );

      blocTest<AuthBloc, AuthState>(
        'should emit [AuthError] when getCurrentUser fails',
        build: () {
          when(mockGetCurrentUser(const NoParams()))
              .thenAnswer((_) async => const Left(AuthFailure(message: 'User state error')));
          return authBloc;
        },
        act: (bloc) => bloc.add(const AuthUserChanged()),
        expect: () => [
          const AuthError('User state error'),
        ],
        verify: (_) {
          verify(mockGetCurrentUser(const NoParams())).called(1);
        },
      );
    });

    group('State Transitions', () {
      blocTest<AuthBloc, AuthState>(
        'should handle multiple rapid events correctly',
        build: () {
          when(mockSignInWithGoogle(const NoParams()))
              .thenAnswer((_) async => Right(tUser));
          when(mockSignOut(const NoParams()))
              .thenAnswer((_) async => const Right(null));
          return authBloc;
        },
        act: (bloc) {
          bloc.add(const AuthSignInWithGoogleRequested());
          bloc.add(const AuthSignOutRequested());
        },
        expect: () => [
          const AuthLoading(),
          AuthAuthenticated(tUser),
          const AuthLoading(),
          const AuthUnauthenticated(),
        ],
        verify: (_) {
          verify(mockSignInWithGoogle(const NoParams())).called(1);
          verify(mockSignOut(const NoParams())).called(1);
        },
      );
    });
  });
}