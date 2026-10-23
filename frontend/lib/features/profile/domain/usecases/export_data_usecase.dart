import 'package:fpdart/fpdart.dart';
import 'package:nexus_ai/core/error/failures.dart';
import 'package:nexus_ai/core/usecases/usecase.dart';
import '../repositories/i_profile_repository.dart';

class ExportDataUseCase implements UseCase<String, NoParams> {
  final IProfileRepository repository;

  ExportDataUseCase(this.repository);

  @override
  Future<Either<Failure, String>> call(NoParams params) {
    return repository.exportUserData();
  }
}
