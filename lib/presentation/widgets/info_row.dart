import 'package:flutter/material.dart';
import 'package:harry_potter_sorting_flutter/domain/entities/info_stats_entity.dart';

import 'info_box.dart';

class InfoRow extends StatelessWidget {
  final InfoStatsEntity infoStats;

  const InfoRow({required this.infoStats, super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      spacing: 16,
      children: [
        InfoBox(value: '${infoStats.totalCount}', description: 'Total'),
        InfoBox(value: '${infoStats.successCount}', description: 'Success'),
        InfoBox(value: '${infoStats.failCount}', description: 'Failed'),
      ],
    );
  }
}
