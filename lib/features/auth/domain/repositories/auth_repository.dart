import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/user.dart';

abstract class AuthRepository {
  Future<Either<AuthFailure, User>> signInWithGoogle();

  Future<Either<AuthFailure, void>> signOut();

  Future<Either<AuthFailure, User?>> getCurrentUser();

  Stream<User?> get authStateChanges;
}