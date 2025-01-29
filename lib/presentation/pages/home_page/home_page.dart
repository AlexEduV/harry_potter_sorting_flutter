import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:harry_potter_sorting_flutter/data/database/database_schema.dart';
import 'package:harry_potter_sorting_flutter/domain/notifiers/bottom_nav_index_notifier.dart';
import 'package:harry_potter_sorting_flutter/domain/notifiers/character_notifier.dart';
import 'package:harry_potter_sorting_flutter/presentation/pages/home_page/nav_pages/home_nav_page/home_nav_page.dart';
import 'package:harry_potter_sorting_flutter/presentation/pages/home_page/nav_pages/list_nav_page/list_nav_page.dart';
import 'package:provider/provider.dart';

@RoutePage()
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  int _selectedNavigationIndex = 0;
  Character? selectedCharacter;

  @override
  Widget build(BuildContext context) {

    return Consumer<BottomNavIndexNotifier>(
      builder: (context, notifier, child) {

        return Scaffold(
          body: IndexedStack(
            index: notifier.selectedIndex,
            children: const [
              HomeNavPage(),
              ListNavPage(),
            ],
          ),
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: notifier.selectedIndex,
            onTap: onItemTapped,
            items: const [
              BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
              BottomNavigationBarItem(icon: Icon(Icons.list), label: 'List'),
            ],
          ),
        );

      },
    );
  }

  void onItemTapped(int newIndex) {
    context.read<BottomNavIndexNotifier>().updateIndex(newIndex);
  }
}
