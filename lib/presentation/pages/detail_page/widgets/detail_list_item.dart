import 'package:flutter/material.dart';

import '../../../style/app_colors.dart';

class DetailListItem extends StatelessWidget {
  final String label;
  final String value;

  const DetailListItem({
    required this.label,
    required this.value,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 8.0,
      children: [
        Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 18),
        ),
        Text(
          value.isNotEmpty ? value : ' - ',
          style: const TextStyle(fontSize: 18, color: AppColors.deepGold),
        ),
      ],
    );
  }
}
