class AppException implements Exception {
  final String message;
  final String? code;

  AppException({required this.message, this.code});

  @override
  String toString() =>
      'AppException: $message' + (code != null ? ' (Code: $code)' : '');
}

class NetworkException extends AppException {
  NetworkException({String message = 'Network error occurred'})
    : super(message: message, code: 'NETWORK_ERROR');
}

class TimeoutException extends AppException {
  TimeoutException({String message = 'Request timeout'})
    : super(message: message, code: 'TIMEOUT');
}

class NotFoundException extends AppException {
  NotFoundException({String message = 'Resource not found'})
    : super(message: message, code: 'NOT_FOUND');
}

class ServerException extends AppException {
  ServerException({String message = 'Server error'})
    : super(message: message, code: 'SERVER_ERROR');
}
