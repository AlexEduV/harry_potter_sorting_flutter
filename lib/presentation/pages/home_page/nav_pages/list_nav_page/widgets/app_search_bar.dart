import 'package:flutter/material.dart';

import '../../../../../style/app_colors.dart';

class AppSearchBar extends StatelessWidget {
  final FocusNode searchFocusNode;
  final Function(String) onChanged;

  const AppSearchBar({
    required this.searchFocusNode,
    required this.onChanged,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SearchBar(
      focusNode: searchFocusNode,
      padding: WidgetStateProperty.all(const EdgeInsets.symmetric(horizontal: 16.0)),
      backgroundColor: WidgetStateProperty.resolveWith<Color?>((Set<WidgetState> states) {
        if (states.contains(WidgetState.focused)) {
          return AppColors.white;
        }
        return AppColors.lightGrey; // Default color
      }),
      side: WidgetStateProperty.resolveWith<BorderSide?>((Set<WidgetState> states) {
        if (states.contains(WidgetState.focused)) {
          return const BorderSide(color: AppColors.lightGrey, width: 3.0);
        }
        return null; // Default color
      }),
      shadowColor: const WidgetStatePropertyAll(AppColors.white),
      elevation: const WidgetStatePropertyAll(0),
      hintText: 'Filter Characters',
      hintStyle: WidgetStateProperty.all(const TextStyle(fontSize: 24)),
      textStyle: WidgetStateProperty.all(const TextStyle(fontSize: 24)),
      leading: const Icon(Icons.search),
      keyboardType: TextInputType.name,
      onChanged: onChanged,
    );
  }
}
