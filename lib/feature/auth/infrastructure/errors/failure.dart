abstract class Failure {
  final String message;
  Failure(this.message);
}

class ServerFailure extends Failure {
  final int code;
  ServerFailure(this.code, String message) : super(message);
}

class CacheFailure extends Failure {
  CacheFailure(String message) : super(message);
}

class InvalidInputFailure extends Failure {
  InvalidInputFailure(String message) : super(message);
}
