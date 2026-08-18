import 'package:flutter_test/flutter_test.dart';
import 'package:harry_potter_sorting_flutter/domain/usecases/get_characters_usecase.dart';

import '../../helpers/fake_character_repository.dart';

void main() {
  late FakeCharacterRepository repository;
  late GetCharactersUseCase useCase;

  setUp(() {
    repository = FakeCharacterRepository();
    useCase = GetCharactersUseCase(repository);
  });

  group('GetCharactersUseCase', () {
    test('delegates to repository with provided filter', () async {
      await useCase.call('Harry');

      expect(repository.lastGetAllFilter, 'Harry');
    });

    test('returns characters from repository', () async {
      final characters = [
        makeCharacter(id: '1', name: 'Harry Potter'),
        makeCharacter(id: '2', name: 'Hermione Granger'),
      ];
      repository.submittedCharacters = characters;

      final result = await useCase.call('');

      expect(result, equals(characters));
    });

    test('returns empty list when repository has no characters', () async {
      final result = await useCase.call('');

      expect(result, isEmpty);
    });

    test('returns filtered result from repository', () async {
      final harry = makeCharacter(id: '1', name: 'Harry Potter');
      repository.submittedCharacters = [harry];

      final result = await useCase.call('Harry');

      expect(result, [harry]);
      expect(repository.lastGetAllFilter, 'Harry');
    });
  });
}
