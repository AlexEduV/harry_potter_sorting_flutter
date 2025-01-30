import 'package:harry_potter_sorting_flutter/domain/repositories/character_repository.dart';

class ResetCharacterStatsUseCase {
  final CharacterRepository _repository;

  ResetCharacterStatsUseCase(this._repository);

  void execute(String name) {
    return _repository.resetCharacterAttemptsStats(name);
  }
}