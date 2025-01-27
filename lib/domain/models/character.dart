import 'package:flutter/cupertino.dart';
import 'package:json_annotation/json_annotation.dart';

part 'character.g.dart';

@JsonSerializable()
class Character {

  final String id;
  final String name;

  @JsonKey(name: 'image')
  final String imageSrc;

  final String house;

  final String? dateOfBirth;

  final String actor;
  final String species;

  const Character({
    required this.id,
    required this.name,
    required this.imageSrc,
    required this.house,
    this.dateOfBirth,
    required this.actor,
    required this.species,
  });

  factory Character.fromJson(Map<String, dynamic> json) => _$CharacterFromJson(json);

}