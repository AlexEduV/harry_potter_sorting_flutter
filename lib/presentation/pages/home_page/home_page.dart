import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:harry_potter_sorting_flutter/presentation/pages/home_page/nav_pages/list_nav_page/notifiers/character_list_notifier.dart';
import 'package:harry_potter_sorting_flutter/presentation/pages/home_page/nav_pages/list_nav_page/notifiers/filter_value_notifier.dart';
import 'package:harry_potter_sorting_flutter/presentation/pages/home_page/notifiers/bottom_nav_index_notifier.dart';
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

    //if in list
    if (newIndex == 1) {
      context.read<CharacterListNotifier>().getInitCombinedStats();

      final filterValue = context.read<FilterValueNotifier>().value;
      context.read<CharacterListNotifier>().fetchCharacters(filter: filterValue);

    }
  }
}
