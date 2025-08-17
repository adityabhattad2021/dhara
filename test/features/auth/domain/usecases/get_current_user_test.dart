import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:dartz/dartz.dart';
import 'package:dhara/core/errors/failures.dart';
import 'package:dhara/core/usecases/usecase.dart';
import 'package:dhara/features/auth/domain/entities/user.dart';
import 'package:dhara/features/auth/domain/usecases/get_current_user.dart';

import 'sign_in_with_google_test.mocks.dart';

void main() {
  late GetCurrentUser usecase;
  late MockAuthRepository mockAuthRepository;

  setUp(() {
    mockAuthRepository = MockAuthRepository();
    usecase = GetCurrentUser(mockAuthRepository);
  });

  group('GetCurrentUser UseCase', () {
    final tUser = User(
      id: 'test_id',
      email: 'test@example.com',
      displayName: 'Test User',
      createdAt: DateTime.now(),
      lastLoginAt: DateTime.now(),
    );

    test('should return User when repository has authenticated user', () async {
      // arrange
      when(mockAuthRepository.getCurrentUser())
          .thenAnswer((_) async => Right(tUser));

      // act
      final result = await usecase(const NoParams());

      // assert
      expect(result, Right(tUser));
      verify(mockAuthRepository.getCurrentUser()).called(1);
      verifyNoMoreInteractions(mockAuthRepository);
    });

    test('should return null when no user is authenticated', () async {
      // arrange
      when(mockAuthRepository.getCurrentUser())
          .thenAnswer((_) async => const Right(null));

      // act
      final result = await usecase(const NoParams());

      // assert
      expect(result, const Right(null));
      verify(mockAuthRepository.getCurrentUser()).called(1);
      verifyNoMoreInteractions(mockAuthRepository);
    });

    test('should return AuthFailure when repository fails', () async {
      // arrange
      const tAuthFailure = AuthFailure(message: 'Failed to get current user');
      when(mockAuthRepository.getCurrentUser())
          .thenAnswer((_) async => const Left(tAuthFailure));

      // act
      final result = await usecase(const NoParams());

      // assert
      expect(result, const Left(tAuthFailure));
      verify(mockAuthRepository.getCurrentUser()).called(1);
      verifyNoMoreInteractions(mockAuthRepository);
    });

    test('should return AuthFailure when auth service is unavailable', () async {
      // arrange
      const tServiceFailure = AuthFailure(message: 'Authentication service error');
      when(mockAuthRepository.getCurrentUser())
          .thenAnswer((_) async => const Left(tServiceFailure));

      // act
      final result = await usecase(const NoParams());

      // assert
      expect(result, const Left(tServiceFailure));
      verify(mockAuthRepository.getCurrentUser()).called(1);
      verifyNoMoreInteractions(mockAuthRepository);
    });

    test('should call repository exactly once', () async {
      // arrange
      when(mockAuthRepository.getCurrentUser())
          .thenAnswer((_) async => Right(tUser));

      // act
      await usecase(const NoParams());

      // assert
      verify(mockAuthRepository.getCurrentUser()).called(1);
    });
  });
}