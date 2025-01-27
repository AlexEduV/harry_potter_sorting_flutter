import 'package:json_annotation/json_annotation.dart';

part 'character.g.dart';

@JsonSerializable()
class Character {

  final int id;
  final String name;
  final String imageSrc;
  final String house;
  final String dateOfBirth;
  final String actor;
  final String species;

  const Character({
    required this.id,
    required this.name,
    required this.imageSrc,
    required this.house,
    required this.dateOfBirth,
    required this.actor,
    required this.species,
  });

  factory Character.fromJson(Map<String, dynamic> json) => _$CharacterFromJson(json);

}