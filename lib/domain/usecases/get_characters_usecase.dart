import 'package:harry_potter_sorting_flutter/data/database/database_schema.dart';
import 'package:harry_potter_sorting_flutter/domain/repositories/character_repository.dart';

class GetCharactersUseCase {
  final CharacterRepository _repository;

  GetCharactersUseCase(this._repository);

  Future<List<Character>> execute({String filter = ''}) {
    return _repository.getAllSubmittedCharacters(filter: filter);
  }



}