import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:harry_potter_sorting_flutter/core/di/dependency_injection.dart';
import 'package:harry_potter_sorting_flutter/domain/repositories/character_repository.dart';
import 'package:harry_potter_sorting_flutter/domain/usecases/get_characters_usecase.dart';
import 'package:harry_potter_sorting_flutter/presentation/pages/detail_page/notifiers/detail_character_notifier.dart';
import 'package:harry_potter_sorting_flutter/presentation/pages/home_page/nav_pages/home_nav_page/notifiers/character_cache_provider.dart';
import 'package:harry_potter_sorting_flutter/presentation/pages/home_page/nav_pages/home_nav_page/notifiers/character_notifier.dart';
import 'package:harry_potter_sorting_flutter/presentation/pages/home_page/nav_pages/home_nav_page/notifiers/character_stats_notifier.dart';
import 'package:harry_potter_sorting_flutter/presentation/pages/home_page/nav_pages/home_nav_page/notifiers/picker_state_notifier.dart';
import 'package:harry_potter_sorting_flutter/presentation/pages/home_page/nav_pages/list_nav_page/notifiers/character_list_notifier.dart';
import 'package:harry_potter_sorting_flutter/presentation/pages/home_page/nav_pages/list_nav_page/notifiers/filter_value_notifier.dart';
import 'package:harry_potter_sorting_flutter/presentation/pages/home_page/notifiers/bottom_nav_index_notifier.dart';
import 'package:harry_potter_sorting_flutter/presentation/style/app_colors.dart';
import 'package:harry_potter_sorting_flutter/router/router.dart';
import 'package:provider/provider.dart';

void main() {
  if (kReleaseMode) {
    debugPrint = (String? message, {int? wrapWidth}) {};
  }

  setupDependencies();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CharacterNotifier(getIt())),
        ChangeNotifierProvider(create: (_) => BottomNavIndexNotifier()),
        ChangeNotifierProvider(create: (_) => CharacterStatsNotifier(getIt())),
        ChangeNotifierProvider(create: (_) => PickerStateNotifier()),
        ChangeNotifierProvider(create: (_) => DetailCharacterNotifier(getIt())),
        ChangeNotifierProvider(
            create: (_) =>
                CharacterListNotifier(getIt<CharacterRepository>(), getIt<GetCharactersUseCase>())),
        ChangeNotifierProvider(create: (_) => FilterValueNotifier()),
        ChangeNotifierProvider(create: (_) => CharacterCacheProvider(getIt())),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final _router = AppRouter();

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Harry Potter Magic Sorting Hat',
      theme: ThemeData(
          brightness: Brightness.light,
          useMaterial3: true,
          fontFamily: 'HarryP',
          appBarTheme: const AppBarTheme(
            backgroundColor: AppColors.white,
            foregroundColor: AppColors.charcoalGrey,
            centerTitle: true,
          ),
          scaffoldBackgroundColor: AppColors.white,
          bottomNavigationBarTheme: const BottomNavigationBarThemeData(
            backgroundColor: AppColors.white,
            selectedItemColor: AppColors.black,
          )),
      routerConfig: _router.config(),
      debugShowCheckedModeBanner: false,
    );
  }
}
