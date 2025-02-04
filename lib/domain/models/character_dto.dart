import 'package:json_annotation/json_annotation.dart';

part 'character_dto.g.dart';

@JsonSerializable()
class CharacterDTO {

  final String id;
  final String name;

  @JsonKey(name: 'image')
  final String imageSrc;

  final String house;

  final String? dateOfBirth;

  final String actor;
  final String species;

  const CharacterDTO({
    required this.id,
    required this.name,
    required this.imageSrc,
    required this.house,
    this.dateOfBirth,
    required this.actor,
    required this.species,
  });

  factory CharacterDTO.fromJson(Map<String, dynamic> json) => _$CharacterDTOFromJson(json);

}