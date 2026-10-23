import 'exceptions.dart';
import 'failures.dart';

/// Centralized Error Handler to map exceptions into Domain Failures.
abstract class ErrorHandler {
  static Failure handleException(dynamic exception) {
    if (exception is ValidationException) {
      return ValidationFailure(
        message: exception.message,
        fieldErrors: exception.errors,
        statusCode: exception.statusCode,
      );
    } else if (exception is UnauthorizedException) {
      return UnauthorizedFailure(
        message: exception.message,
        statusCode: exception.statusCode,
      );
    } else if (exception is ServerException) {
      return ServerFailure(
        message: exception.message,
        statusCode: exception.statusCode,
      );
    } else if (exception is TimeoutException) {
      return const NetworkFailure(
        message: 'Network request timed out. Please try again.',
      );
    } else if (exception is NetworkException) {
      return NetworkFailure(
        message: exception.message,
        statusCode: exception.statusCode,
      );
    } else if (exception is CacheException) {
      return CacheFailure(message: exception.message);
    } else {
      return UnknownFailure(
        message: exception?.toString() ?? 'An unexpected error occurred.',
      );
    }
  }
}
