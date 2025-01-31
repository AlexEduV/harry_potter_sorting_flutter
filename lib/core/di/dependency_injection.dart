import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';
import 'package:harry_potter_sorting_flutter/data/network/dio_client.dart';
import 'package:harry_potter_sorting_flutter/data/repositories/character_repository_impl.dart';
import 'package:harry_potter_sorting_flutter/domain/usecases/get_characters_usecase.dart';
import 'package:harry_potter_sorting_flutter/domain/usecases/reset_character_stats_usecase.dart';

final getIt = GetIt.instance;

void setupDependencies() {
  if (!GetIt.I.isRegistered<Dio>()) {
    getIt.registerSingleton<Dio>(DioClient.client);
    getIt.registerLazySingleton(() => CharacterRepositoryImpl(getIt<Dio>()));
    getIt.registerLazySingleton(() => GetCharactersUseCase(getIt<CharacterRepositoryImpl>()));
    getIt.registerLazySingleton(() => ResetCharacterStatsUseCase(getIt<CharacterRepositoryImpl>()));
  }
}
