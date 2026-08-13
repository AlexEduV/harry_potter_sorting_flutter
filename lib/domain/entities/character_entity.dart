import 'package:harry_potter_sorting_flutter/data/database/database_schema.dart';
import 'package:harry_potter_sorting_flutter/data/dto/character_dto.dart';

class CharacterEntity {
  final String id;
  final String name;
  final String imageSrc;

  final String house;

  final String? dateOfBirth;

  final String actor;
  final String species;

  const CharacterEntity({
    required this.id,
    required this.name,
    required this.imageSrc,
    required this.house,
    required this.dateOfBirth,
    required this.actor,
    required this.species,
  });

  factory CharacterEntity.fromSchema(Character character) {
    return CharacterEntity(
        id: character.longId,
        name: character.name,
        imageSrc: character.imageSrc,
        house: character.house,
        dateOfBirth: character.dateOfBirth,
        actor: character.actor,
        species: character.species);
  }

  factory CharacterEntity.fromDto(CharacterDto dto) {
    return CharacterEntity(
      id: dto.id,
      name: dto.name,
      imageSrc: dto.imageSrc,
      house: dto.house,
      dateOfBirth: dto.dateOfBirth,
      actor: dto.actor,
      species: dto.species,
    );
  }

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
          species == other.species;

  @override
  int get hashCode => Object.hash(id, name, imageSrc, house, dateOfBirth, actor, species);
}
