import 'package:flutter_test/flutter_test.dart';
import 'package:harry_potter_sorting_flutter/domain/entities/info_stats_entity.dart';

void main() {
  group('InfoStatsEntity', () {
    test('stores all counts correctly', () {
      const stats = InfoStatsEntity(
        totalCount: 10,
        successCount: 7,
        failCount: 3,
      );

      expect(stats.totalCount, 10);
      expect(stats.successCount, 7);
      expect(stats.failCount, 3);
    });

    test('accepts zero values', () {
      const stats = InfoStatsEntity(
        totalCount: 0,
        successCount: 0,
        failCount: 0,
      );

      expect(stats.totalCount, 0);
      expect(stats.successCount, 0);
      expect(stats.failCount, 0);
    });

    test('successCount and failCount can sum to totalCount', () {
      const stats = InfoStatsEntity(
        totalCount: 5,
        successCount: 2,
        failCount: 3,
      );

      expect(stats.successCount + stats.failCount, stats.totalCount);
    });
  });
}
