import 'package:flutter/material.dart';
import 'package:harry_potter_sorting_flutter/presentation/pages/home_page/notifiers/bottom_nav_index_notifier.dart';
import 'package:provider/provider.dart';

import '../../../style/app_colors.dart';
import '../nav_pages/list_nav_page/notifiers/character_list_notifier.dart';
import '../nav_pages/list_nav_page/notifiers/filter_value_notifier.dart';

class HomeBottomBarItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final int index;

  const HomeBottomBarItem(
      {super.key, required this.icon, required this.label, required this.index});

  @override
  Widget build(BuildContext context) {
    return Consumer<BottomNavIndexNotifier>(builder: (context, notifier, child) {
      return InkWell(
        borderRadius: BorderRadius.circular(16.0),
        onTap: () => _onItemTapped(context, index),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            spacing: 6.0,
            children: [
              Container(
                padding: const EdgeInsets.all(6.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6.0),
                  color: AppColors.lightGrey,
                ),
                child: Icon(
                  icon,
                  color: Colors.grey,
                ),
              ),
              Text(
                label,
                style: TextStyle(
                    fontSize: 18,
                    color:
                        index == notifier.selectedIndex ? AppColors.gold : AppColors.charcoalGrey),
              ),
            ],
          ),
        ),
      );
    });
  }

  void _onItemTapped(BuildContext context, int newIndex) {
    context.read<BottomNavIndexNotifier>().updateIndex(newIndex);

    //if in list
    if (newIndex == 1) {
      context.read<CharacterListNotifier>().getInitCombinedStats();

      final filterValue = context.read<FilterValueNotifier>().value;
      context.read<CharacterListNotifier>().fetchCharacters(filter: filterValue);
    }
  }
}
