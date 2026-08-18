import 'package:flutter/material.dart';
import 'package:harry_potter_sorting_flutter/presentation/pages/home_page/widgets/home_bottom_bar_item.dart';
import 'package:harry_potter_sorting_flutter/presentation/style/app_colors.dart';

class HomeBottomBar extends StatelessWidget {
  const HomeBottomBar({super.key});

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration:
          BoxDecoration(borderRadius: BorderRadius.circular(16.0), color: AppColors.lightGrey),
      child: Padding(
        padding: const EdgeInsets.all(4.0).copyWith(bottom: 12.0),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            HomeBottomBarItem(icon: Icons.home, label: 'Home', index: 0),
            HomeBottomBarItem(icon: Icons.list, label: 'List', index: 1),
          ],
        ),
      ),
    );
  }
}
