import 'package:flutter/material.dart';
import 'package:harry_potter_sorting_flutter/data/network/dio_client.dart';
import 'package:harry_potter_sorting_flutter/data/repositories/character_repository_impl.dart';
import 'package:harry_potter_sorting_flutter/domain/usecases/reset_character_stats_usecase.dart';
import 'package:harry_potter_sorting_flutter/presentation/pages/detail_page/notifiers/detail_character_notifier.dart';
import 'package:harry_potter_sorting_flutter/presentation/pages/home_page/nav_pages/list_nav_page/notifiers/character_list_notifier.dart';
import 'package:harry_potter_sorting_flutter/domain/usecases/get_characters_usecase.dart';
import 'package:harry_potter_sorting_flutter/presentation/pages/home_page/nav_pages/list_nav_page/notifiers/filter_value_notifier.dart';
import 'package:harry_potter_sorting_flutter/presentation/pages/home_page/notifiers/bottom_nav_index_notifier.dart';
import 'package:harry_potter_sorting_flutter/presentation/pages/home_page/nav_pages/home_nav_page/notifiers/character_stats_notifier.dart';
import 'package:harry_potter_sorting_flutter/presentation/pages/home_page/nav_pages/home_nav_page/notifiers/character_notifier.dart';
import 'package:harry_potter_sorting_flutter/presentation/pages/home_page/nav_pages/home_nav_page/notifiers/picker_color_notifier.dart';
import 'package:harry_potter_sorting_flutter/router/router.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CharacterNotifier()),
        ChangeNotifierProvider(create: (_) => BottomNavIndexNotifier()),
        ChangeNotifierProvider(create: (_) => CharacterStatsNotifier(
          ResetCharacterStatsUseCase(
            CharacterRepositoryImpl(DioClient.client),
          ),
        )),
        ChangeNotifierProvider(create: (_) => PickerColorNotifier()),
        ChangeNotifierProvider(create: (_) => DetailCharacterNotifier()),
        ChangeNotifierProvider(create: (_) => CharacterListNotifier(
          GetCharactersUseCase(
              CharacterRepositoryImpl(DioClient.client),
          ),
        )),
        ChangeNotifierProvider(create: (_) => FilterValueNotifier()),
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
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          centerTitle: true,
        ),
        scaffoldBackgroundColor: Colors.white,
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: Colors.white,
          selectedItemColor: Colors.black,
        )
      ),
      routerConfig: _router.config(),
      debugShowCheckedModeBanner: false,
    );
  }
}
