import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import '../error/failures.dart';

/// Contract for NoParams in UseCases.
class NoParams extends Equatable {
  const NoParams();

  @override
  List<Object?> get props => [];
}

/// Abstract Base UseCase Contract returning Either<Failure, Type>.
abstract class UseCase<Type, Params> {
  Future<Either<Failure, Type>> call(Params params);
}
