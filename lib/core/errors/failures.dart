abstract class Failure {
  const Failure();
}

class NetworkFailure extends Failure {
  final String message;

  const NetworkFailure({required this.message});
}

class CacheFailure extends Failure {
  final String message;

  const CacheFailure({required this.message});
}

class ServerFailure extends Failure {
  final String message;

  const ServerFailure({required this.message});
}

class AuthFailure extends Failure {
  final String message;

  const AuthFailure({required this.message});
}
