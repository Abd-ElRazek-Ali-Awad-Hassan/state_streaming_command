import '../interfaces/error.dart';

final class NoneError implements Error {
  const NoneError();
}

final class NetworkError implements Error {}

final class ServerError implements Error {
  ServerError({this.message = ''});

  final String message;
}

final class UnauthorizedAccessError implements Error {}
