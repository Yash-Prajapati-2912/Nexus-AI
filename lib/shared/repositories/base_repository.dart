import 'package:fpdart/fpdart.dart';
import '../../core/error/error_handler.dart';
import '../../core/error/failures.dart';

/// Base Repository helper for executing network calls safely into Either<Failure, T>.
abstract class BaseRepository {
  Future<Either<Failure, T>> callRemote<T>(Future<T> Function() call) async {
    try {
      final result = await call();
      return Right(result);
    } catch (e) {
      return Left(ErrorHandler.handleException(e));
    }
  }
}
