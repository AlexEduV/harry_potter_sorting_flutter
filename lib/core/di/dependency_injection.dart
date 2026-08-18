import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:harry_potter_sorting_flutter/data/data_sources/local/character_local_storage_impl.dart';
import 'package:harry_potter_sorting_flutter/data/database/database_schema.dart';
import 'package:harry_potter_sorting_flutter/data/network/dio_client.dart';
import 'package:harry_potter_sorting_flutter/data/repositories/character_repository_impl.dart';
import 'package:harry_potter_sorting_flutter/data/services/character_api_service.dart';
import 'package:harry_potter_sorting_flutter/domain/data_sources/local/character_local_storage.dart';
import 'package:harry_potter_sorting_flutter/domain/repositories/character_repository.dart';
import 'package:harry_potter_sorting_flutter/domain/usecases/get_characters_usecase.dart';
import 'package:harry_potter_sorting_flutter/domain/usecases/reset_character_stats_usecase.dart';

final getIt = GetIt.instance;

void setupDependencies({AppDatabase? database}) {
  if (getIt.isRegistered<Dio>()) return;

  getIt.registerSingleton<Dio>(DioClient.client);
  getIt.registerSingleton<AppDatabase>(database ?? AppDatabase());
  getIt.registerLazySingleton<CharacterApiService>(() => CharacterApiService(getIt()));

  getIt.registerLazySingleton<CharacterLocalStorage>(() => CharacterLocalStorageImpl(getIt()));

  getIt.registerLazySingleton<CharacterRepository>(
      () => CharacterRepositoryImpl(getIt<CharacterApiService>(), getIt<CharacterLocalStorage>()));

  getIt.registerLazySingleton(() => GetCharactersUseCase(getIt()));
  getIt.registerLazySingleton(() => ResetCharacterStatsUseCase(getIt()));
}
