import 'package:equatable/equatable.dart';

/// Abstract Domain Failure class extending Equatable.
abstract class Failure extends Equatable {
  final String message;
  final int? statusCode;

  const Failure({required this.message, this.statusCode});

  @override
  List<Object?> get props => [message, statusCode];
}

/// Server Failure.
class ServerFailure extends Failure {
  const ServerFailure({required super.message, super.statusCode});
}

/// Network Connection Failure.
class NetworkFailure extends Failure {
  const NetworkFailure({
    super.message = 'No internet connection. Please check your network.',
    super.statusCode,
  });
}

/// Unauthorized Failure.
class UnauthorizedFailure extends Failure {
  const UnauthorizedFailure({
    super.message = 'Session expired. Please log in again.',
    super.statusCode = 401,
  });
}

/// Validation Failure.
class ValidationFailure extends Failure {
  final Map<String, List<String>> fieldErrors;

  const ValidationFailure({
    required super.message,
    required this.fieldErrors,
    super.statusCode = 400,
  });

  @override
  List<Object?> get props => [message, statusCode, fieldErrors];
}

/// Cache Failure.
class CacheFailure extends Failure {
  const CacheFailure({required super.message});
}

/// Unknown Failure.
class UnknownFailure extends Failure {
  const UnknownFailure({
    super.message = 'An unexpected error occurred. Please try again.',
  });
}
