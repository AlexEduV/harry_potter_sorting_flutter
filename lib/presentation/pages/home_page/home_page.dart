import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:harry_potter_sorting_flutter/presentation/pages/home_page/nav_pages/home_nav_page/home_nav_page.dart';
import 'package:harry_potter_sorting_flutter/presentation/pages/home_page/nav_pages/list_nav_page/list_nav_page.dart';
import 'package:harry_potter_sorting_flutter/presentation/pages/home_page/notifiers/bottom_nav_index_notifier.dart';
import 'package:harry_potter_sorting_flutter/presentation/pages/home_page/widgets/home_bottom_bar.dart';
import 'package:provider/provider.dart';

@RoutePage()
class HomePage extends StatelessWidget {
  const HomePage({super.key});

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
          bottomNavigationBar: const HomeBottomBar(),
        );
      },
    );
  }
}
