import 'package:harry_potter_sorting_flutter/data/database/database_schema.dart';
import 'package:harry_potter_sorting_flutter/domain/repositories/character_repository.dart';
import 'package:harry_potter_sorting_flutter/domain/usecases/usecase.dart';

class GetCharactersUseCase extends UseCaseWithParams<String, Future<List<Character>>> {
  final CharacterRepository _repository;

  GetCharactersUseCase(this._repository);

  @override
  Future<List<Character>> call(String params) {
    return _repository.getAllSubmittedCharacters(filter: params);
  }
}
