import '../../common/enums/house.dart';
import '../../data/dto/character_dto.dart';
import '../entities/character_entity.dart';

extension CharacterDtoMapper on CharacterDto {
  CharacterEntity toEntity() => CharacterEntity(
        id: id,
        name: name,
        imageSrc: imageSrc,
        house: House.fromString(house),
        dateOfBirth: dateOfBirth,
        actor: actor,
        species: species,
      );
}
