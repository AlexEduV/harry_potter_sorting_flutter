import 'package:harry_potter_sorting_flutter/domain/entities/character_entity.dart';
import 'package:harry_potter_sorting_flutter/domain/repositories/character_repository.dart';
import 'package:harry_potter_sorting_flutter/domain/usecases/usecase.dart';

class GetCharactersUseCase extends UseCaseWithParams<String, Future<List<CharacterEntity>>> {
  final CharacterRepository _repository;

  GetCharactersUseCase(this._repository);

  @override
  Future<List<CharacterEntity>> call(String params) {
    return _repository.getAllSubmittedCharacters(filter: params);
  }
}
