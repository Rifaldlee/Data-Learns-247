class AppException implements Exception {
  final String? _message;
  final String? _prefix;

  AppException([this._message, this._prefix]);

  @override
  String toString() {
    return "$_prefix$_message";
  }
}

class NoInternetException extends AppException {
  NoInternetException([String? message]) : super(message, "No internet connection ");
}

class TimeoutException extends AppException {
  TimeoutException ([String? message]) : super(message, "Server not responding ");
}

class FetchDataException extends AppException {
  FetchDataException([String? message]) : super(message, "Failed to retrieve data: ");
}

class BadRequestException extends AppException {
  BadRequestException([message]) : super(message, "Invalid request format: ");
}

class InvalidInputException extends AppException {
  InvalidInputException([String? message]) : super(message, "The provided input is invalid: ");
}

class UnauthorizedException extends AppException {
  UnauthorizedException([message]) : super(message, "You are not authorized to access this resource: ");
}

class ForbiddenException extends AppException {
  ForbiddenException([message]) : super(message, "You are not permitted to access this resource: ");
}

class NotFoundException extends AppException {
  NotFoundException([message]) : super(message, "The requested resource could not be found: ");
}

class RequestTimeoutException extends AppException {
  RequestTimeoutException([message]) : super(message, "Unstable network could not send request: ");
}

class InternalServerException extends AppException {
  InternalServerException([message]) : super(message, "Server Error: ");
}

class BadGatewayException extends AppException {
  BadGatewayException([message]) : super(message, "Could not process the request due to a bad gateway: ");
}

class ServiceUnavailableException extends AppException {
  ServiceUnavailableException([message]) : super(message, "Service  is currently unavailable: ");
}

class GatewayTimeoutException extends AppException {
  GatewayTimeoutException([message]) : super(message, "Could not process the request due to high traffic: ");
}

class LoginException extends AppException {
  LoginException([message]) : super (message, "Login Failed: ");
}

class RegisterException extends AppException {
  RegisterException([message]) : super (message, "Register Failed: ");
}