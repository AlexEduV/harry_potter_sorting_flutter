import 'package:flutter_test/flutter_test.dart';
import 'package:harry_potter_sorting_flutter/domain/usecases/reset_character_stats_usecase.dart';

import '../../helpers/fake_character_repository.dart';

void main() {
  late FakeCharacterRepository repository;
  late ResetCharacterStatsUseCase useCase;

  setUp(() {
    repository = FakeCharacterRepository();
    useCase = ResetCharacterStatsUseCase(repository);
  });

  group('ResetCharacterStatsUseCase', () {
    test('delegates to repository with the given name', () {
      useCase.execute('Harry Potter');

      expect(repository.lastResetName, 'Harry Potter');
    });

    test('passes the exact name string to repository', () {
      useCase.execute('Draco Malfoy');

      expect(repository.lastResetName, 'Draco Malfoy');
    });
  });
}
