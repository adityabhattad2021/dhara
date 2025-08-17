import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:dartz/dartz.dart';
import 'package:dhara/core/errors/failures.dart';
import 'package:dhara/core/usecases/usecase.dart';
import 'package:dhara/features/auth/domain/entities/user.dart';
import 'package:dhara/features/auth/domain/repositories/auth_repository.dart';
import 'package:dhara/features/auth/domain/usecases/sign_in_with_google.dart';

import 'sign_in_with_google_test.mocks.dart';

@GenerateMocks([AuthRepository])
void main() {
  late SignInWithGoogle usecase;
  late MockAuthRepository mockAuthRepository;

  setUp(() {
    mockAuthRepository = MockAuthRepository();
    usecase = SignInWithGoogle(mockAuthRepository);
  });

  group('SignInWithGoogle UseCase', () {
    final tUser = User(
      id: 'test_id',
      email: 'test@example.com',
      displayName: 'Test User',
      createdAt: DateTime.now(),
      lastLoginAt: DateTime.now(),
    );

    test('should return User when repository sign in is successful', () async {
      // arrange
      when(mockAuthRepository.signInWithGoogle())
          .thenAnswer((_) async => Right(tUser));

      // act
      final result = await usecase(const NoParams());

      // assert
      expect(result, Right(tUser));
      verify(mockAuthRepository.signInWithGoogle()).called(1);
      verifyNoMoreInteractions(mockAuthRepository);
    });

    test('should return AuthFailure when repository sign in fails', () async {
      // arrange
      const tAuthFailure = AuthFailure(message: 'Sign in cancelled');
      when(mockAuthRepository.signInWithGoogle())
          .thenAnswer((_) async => const Left(tAuthFailure));

      // act
      final result = await usecase(const NoParams());

      // assert
      expect(result, const Left(tAuthFailure));
      verify(mockAuthRepository.signInWithGoogle()).called(1);
      verifyNoMoreInteractions(mockAuthRepository);
    });

    test('should return AuthFailure when network error occurs', () async {
      // arrange
      const tNetworkAuthFailure = AuthFailure(message: 'No internet connection');
      when(mockAuthRepository.signInWithGoogle())
          .thenAnswer((_) async => const Left(tNetworkAuthFailure));

      // act
      final result = await usecase(const NoParams());

      // assert
      expect(result, const Left(tNetworkAuthFailure));
      verify(mockAuthRepository.signInWithGoogle()).called(1);
      verifyNoMoreInteractions(mockAuthRepository);
    });

    test('should call repository exactly once', () async {
      // arrange
      when(mockAuthRepository.signInWithGoogle())
          .thenAnswer((_) async => Right(tUser));

      // act
      await usecase(const NoParams());

      // assert
      verify(mockAuthRepository.signInWithGoogle()).called(1);
    });
  });
}