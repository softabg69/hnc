import 'dart:html';

class CustomException implements Exception {
  final _message;
  final _prefix;

  CustomException(this._message, this._prefix);

  @override
  String toString() {
    return "$_prefix$_message";
  }
}

class FetchDataException extends CustomException {
  FetchDataException([String message = ''])
      : super(message, "Error durante la comunicación");
}

class BadRequestException extends CustomException {
  BadRequestException([String message = ''])
      : super(message, "Petición no válida");
}

class UnauthorizedException extends CustomException {
  UnauthorizedException([String message = ''])
      : super(message, "No autorizado");
}

class InvalidInputException extends CustomException {
  InvalidInputException([String message = ''])
      : super(message, "Entrada no válida");
}
