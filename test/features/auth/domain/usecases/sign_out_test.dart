import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:dartz/dartz.dart';
import 'package:dhara/core/errors/failures.dart';
import 'package:dhara/core/usecases/usecase.dart';
import 'package:dhara/features/auth/domain/usecases/sign_out.dart';

import 'sign_in_with_google_test.mocks.dart';

void main() {
  late SignOut usecase;
  late MockAuthRepository mockAuthRepository;

  setUp(() {
    mockAuthRepository = MockAuthRepository();
    usecase = SignOut(mockAuthRepository);
  });

  group('SignOut UseCase', () {
    test('should return void when repository sign out is successful', () async {
      // arrange
      when(mockAuthRepository.signOut())
          .thenAnswer((_) async => const Right(null));

      // act
      final result = await usecase(const NoParams());

      // assert
      expect(result, const Right(null));
      verify(mockAuthRepository.signOut()).called(1);
      verifyNoMoreInteractions(mockAuthRepository);
    });

    test('should return AuthFailure when repository sign out fails', () async {
      // arrange
      const tAuthFailure = AuthFailure(message: 'Sign out failed');
      when(mockAuthRepository.signOut())
          .thenAnswer((_) async => const Left(tAuthFailure));

      // act
      final result = await usecase(const NoParams());

      // assert
      expect(result, const Left(tAuthFailure));
      verify(mockAuthRepository.signOut()).called(1);
      verifyNoMoreInteractions(mockAuthRepository);
    });

    test('should return AuthFailure when auth service is unavailable', () async {
      // arrange
      const tServiceFailure = AuthFailure(message: 'Authentication service unavailable');
      when(mockAuthRepository.signOut())
          .thenAnswer((_) async => const Left(tServiceFailure));

      // act
      final result = await usecase(const NoParams());

      // assert
      expect(result, const Left(tServiceFailure));
      verify(mockAuthRepository.signOut()).called(1);
      verifyNoMoreInteractions(mockAuthRepository);
    });

    test('should call repository exactly once', () async {
      // arrange
      when(mockAuthRepository.signOut())
          .thenAnswer((_) async => const Right(null));

      // act
      await usecase(const NoParams());

      // assert
      verify(mockAuthRepository.signOut()).called(1);
    });
  });
}