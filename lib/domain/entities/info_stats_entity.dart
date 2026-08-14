import '../../data/database/database_schema.dart';

class InfoStatsEntity {
  final int totalCount;
  final int successCount;
  final int failCount;

  const InfoStatsEntity({
    required this.totalCount,
    required this.successCount,
    required this.failCount,
  });

  factory InfoStatsEntity.fromSchema(Character character) {
    return InfoStatsEntity(
      totalCount: character.totalCount,
      successCount: character.successCount,
      failCount: character.failCount,
    );
  }

  factory InfoStatsEntity.fromSchemaResult(
      ({int failCount, int successCount, int totalCount}) result) {
    return InfoStatsEntity(
      totalCount: result.totalCount,
      successCount: result.successCount,
      failCount: result.failCount,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is InfoStatsEntity &&
          runtimeType == other.runtimeType &&
          totalCount == other.totalCount &&
          successCount == other.successCount &&
          failCount == other.failCount;

  @override
  int get hashCode => Object.hash(totalCount, successCount, failCount);
}
