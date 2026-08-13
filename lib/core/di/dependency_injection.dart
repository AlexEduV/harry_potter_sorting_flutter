import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:harry_potter_sorting_flutter/data/database/database_provider.dart';
import 'package:harry_potter_sorting_flutter/data/database/database_schema.dart';
import 'package:harry_potter_sorting_flutter/data/network/dio_client.dart';
import 'package:harry_potter_sorting_flutter/data/repositories/character_repository_impl.dart';
import 'package:harry_potter_sorting_flutter/data/services/character_api_service.dart';
import 'package:harry_potter_sorting_flutter/domain/mappers/character_to_providers_mapper.dart';
import 'package:harry_potter_sorting_flutter/domain/usecases/get_characters_usecase.dart';
import 'package:harry_potter_sorting_flutter/domain/usecases/reset_character_stats_usecase.dart';

final getIt = GetIt.instance;

void setupDependencies() {
  if (!getIt.isRegistered<Dio>()) {
    getIt.registerSingleton<Dio>(DioClient.client);
    getIt.registerSingleton<AppDatabase>(DatabaseProvider.getDatabase());
    getIt.registerSingleton<CharacterApiService>(CharacterApiService(getIt<Dio>()));

    getIt.registerLazySingleton(
        () => CharacterRepositoryImpl(getIt<CharacterApiService>(), getIt<AppDatabase>()));

    getIt.registerLazySingleton(() => CharacterToProvidersMapper());

    getIt.registerLazySingleton(() => GetCharactersUseCase(getIt()));
    getIt.registerLazySingleton(() => ResetCharacterStatsUseCase(getIt()));
  }
}
