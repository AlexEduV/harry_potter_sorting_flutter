import 'package:harry_potter_sorting_flutter/domain/repositories/character_repository.dart';
import 'package:harry_potter_sorting_flutter/domain/usecases/usecase.dart';

class ResetCharacterStatsUseCase extends UseCaseWithParams<String, Future<void>> {
  final CharacterRepository _repository;

  ResetCharacterStatsUseCase(this._repository);

  @override
  Future<void> call(String params) {
    return _repository.resetCharacterAttemptsStatsByName(params);
  }
}
