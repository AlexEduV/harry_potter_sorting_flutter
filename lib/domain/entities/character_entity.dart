import 'package:harry_potter_sorting_flutter/common/enums/house.dart';
import 'package:harry_potter_sorting_flutter/domain/entities/info_stats_entity.dart';

class CharacterEntity {
  final String id;
  final String name;
  final String imageSrc;

  final House house;

  final String? dateOfBirth;

  final String actor;
  final String species;

  final InfoStatsEntity? infoStatsEntity;

  const CharacterEntity({
    required this.id,
    required this.name,
    required this.imageSrc,
    required this.house,
    required this.dateOfBirth,
    required this.actor,
    required this.species,
    this.infoStatsEntity,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CharacterEntity &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name &&
          imageSrc == other.imageSrc &&
          house == other.house &&
          dateOfBirth == other.dateOfBirth &&
          actor == other.actor &&
          species == other.species &&
          infoStatsEntity == other.infoStatsEntity;

  @override
  int get hashCode =>
      Object.hash(id, name, imageSrc, house, dateOfBirth, actor, species, infoStatsEntity);
}
