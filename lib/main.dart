import 'package:flutter/material.dart';
import 'package:harry_potter_sorting_flutter/presentation/pages/home_page/notifiers/bottom_nav_index_notifier.dart';
import 'package:harry_potter_sorting_flutter/presentation/pages/home_page/notifiers/character_stats_notifier.dart';
import 'package:harry_potter_sorting_flutter/presentation/pages/home_page/notifiers/character_notifier.dart';
import 'package:harry_potter_sorting_flutter/presentation/pages/home_page/notifiers/picker_color_notifier.dart';
import 'package:harry_potter_sorting_flutter/router/router.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CharacterNotifier()),
        ChangeNotifierProvider(create: (_) => BottomNavIndexNotifier()),
        ChangeNotifierProvider(create: (_) => CharacterStatsNotifier()),
        ChangeNotifierProvider(create: (_) => PickerColorNotifier()),
      ],
      child: MyApp()
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
