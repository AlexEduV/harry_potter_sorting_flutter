import 'package:dio/dio.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:harry_potter_sorting_flutter/core/di/dependency_injection.dart';
import 'package:harry_potter_sorting_flutter/data/database/database_schema.dart';
import 'package:harry_potter_sorting_flutter/data/services/character_api_service.dart';
import 'package:harry_potter_sorting_flutter/domain/data_sources/local/character_local_storage.dart';
import 'package:harry_potter_sorting_flutter/domain/mappers/character_to_providers_mapper.dart';
import 'package:harry_potter_sorting_flutter/domain/repositories/character_repository.dart';
import 'package:harry_potter_sorting_flutter/domain/usecases/get_characters_usecase.dart';
import 'package:harry_potter_sorting_flutter/domain/usecases/reset_character_stats_usecase.dart';

void main() {
  setUp(() async {
    await getIt.reset(dispose: true);
    setupDependencies(database: AppDatabase.forTesting(NativeDatabase.memory()));
  });

  tearDown(() async => getIt<AppDatabase>().close());

  tearDownAll(() async => getIt.reset(dispose: true));

  group('setupDependencies — registration', () {
    test('registers Dio', () => expect(getIt.isRegistered<Dio>(), isTrue));
    test('registers AppDatabase', () => expect(getIt.isRegistered<AppDatabase>(), isTrue));
    test('registers CharacterApiService',
        () => expect(getIt.isRegistered<CharacterApiService>(), isTrue));
    test('registers CharacterLocalStorage',
        () => expect(getIt.isRegistered<CharacterLocalStorage>(), isTrue));
    test('registers CharacterRepository',
        () => expect(getIt.isRegistered<CharacterRepository>(), isTrue));
    test('registers CharacterToProvidersMapper',
        () => expect(getIt.isRegistered<CharacterToProvidersMapper>(), isTrue));
    test('registers GetCharactersUseCase',
        () => expect(getIt.isRegistered<GetCharactersUseCase>(), isTrue));
    test('registers ResetCharacterStatsUseCase',
        () => expect(getIt.isRegistered<ResetCharacterStatsUseCase>(), isTrue));
  });

  group('setupDependencies — singleton identity', () {
    test('Dio is the same instance on repeated resolution', () {
      expect(getIt<Dio>(), same(getIt<Dio>()));
    });

    test('AppDatabase is the same instance on repeated resolution', () {
      expect(getIt<AppDatabase>(), same(getIt<AppDatabase>()));
    });

    test('CharacterRepository is the same instance on repeated resolution', () {
      expect(getIt<CharacterRepository>(), same(getIt<CharacterRepository>()));
    });

    test('GetCharactersUseCase is the same instance on repeated resolution', () {
      expect(getIt<GetCharactersUseCase>(), same(getIt<GetCharactersUseCase>()));
    });
  });

  group('setupDependencies — double-registration guard', () {
    test('calling setupDependencies twice does not throw', () {
      expect(setupDependencies, returnsNormally);
    });

    test('second call does not create a second Dio instance', () {
      final first = getIt<Dio>();
      setupDependencies();
      expect(getIt<Dio>(), same(first));
    });
  });
}
