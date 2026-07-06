class AppException implements Exception {
  final String message;
  final String? code;

  const AppException(this.message, {this.code});

  @override
  String toString() => 'AppException: $message${code != null ? ' ($code)' : ''}';
}

class NetworkException extends AppException {
  const NetworkException([String message = 'Network error. Please check your connection.'])
      : super(message, code: 'network_error');
}

class AuthException extends AppException {
  const AuthException(String message, {String? code}) : super(message, code: code);
}

class StorageException extends AppException {
  const StorageException([String message = 'Storage error.']) : super(message, code: 'storage_error');
}
