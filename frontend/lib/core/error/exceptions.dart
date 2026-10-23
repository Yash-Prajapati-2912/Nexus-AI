/// Base Network Exception class.
class NetworkException implements Exception {
  final String message;
  final int? statusCode;
  final String? type;
  final String? detail;

  const NetworkException({
    required this.message,
    this.statusCode,
    this.type,
    this.detail,
  });

  @override
  String toString() => 'NetworkException(statusCode: $statusCode, message: $message)';
}

/// Server Exception (5xx).
class ServerException extends NetworkException {
  const ServerException({
    required super.message,
    super.statusCode,
    super.type,
    super.detail,
  });
}

/// Unauthorized Exception (401).
class UnauthorizedException extends NetworkException {
  const UnauthorizedException({
    required super.message,
    super.statusCode = 401,
    super.type,
    super.detail,
  });
}

/// Forbidden Exception (403).
class ForbiddenException extends NetworkException {
  const ForbiddenException({
    required super.message,
    super.statusCode = 403,
    super.type,
    super.detail,
  });
}

/// NotFound Exception (404).
class NotFoundException extends NetworkException {
  const NotFoundException({
    required super.message,
    super.statusCode = 404,
    super.type,
    super.detail,
  });
}

/// Validation Exception (400).
class ValidationException extends NetworkException {
  final Map<String, List<String>> errors;

  const ValidationException({
    required super.message,
    required this.errors,
    super.statusCode = 400,
    super.type,
    super.detail,
  });
}

/// Timeout Exception.
class TimeoutException extends NetworkException {
  const TimeoutException({
    required super.message,
  });
}

/// Cache Exception.
class CacheException implements Exception {
  final String message;
  const CacheException({required this.message});

  @override
  String toString() => 'CacheException(message: $message)';
}
