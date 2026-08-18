class InfoStatsEntity {
  final int totalCount;
  final int successCount;
  final int failCount;

  const InfoStatsEntity({
    required this.totalCount,
    required this.successCount,
    required this.failCount,
  });

  factory InfoStatsEntity.initial() {
    return const InfoStatsEntity(totalCount: 0, successCount: 0, failCount: 0);
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
