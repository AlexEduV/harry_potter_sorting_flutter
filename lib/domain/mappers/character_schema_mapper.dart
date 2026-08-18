import 'package:harry_potter_sorting_flutter/data/database/database_schema.dart';
import 'package:harry_potter_sorting_flutter/domain/entities/character_entity.dart';
import 'package:harry_potter_sorting_flutter/domain/entities/info_stats_entity.dart';

import '../../common/enums/house.dart';

extension CharacterSchemaMapper on Character {
  CharacterEntity toEntity() => CharacterEntity(
        id: longId,
        name: name,
        imageSrc: imageSrc,
        house: House.fromString(house),
        dateOfBirth: dateOfBirth,
        actor: actor,
        species: species,
        infoStatsEntity: InfoStatsEntity(
          totalCount: totalCount,
          successCount: successCount,
          failCount: failCount,
        ),
      );
}
