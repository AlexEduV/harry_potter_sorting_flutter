// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'character.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Character _$CharacterFromJson(Map<String, dynamic> json) => Character(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      imageSrc: json['imageSrc'] as String,
      house: json['house'] as String,
      dateOfBirth: json['dateOfBirth'] as String,
      actor: json['actor'] as String,
      species: json['species'] as String,
    );

Map<String, dynamic> _$CharacterToJson(Character instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'imageSrc': instance.imageSrc,
      'house': instance.house,
      'dateOfBirth': instance.dateOfBirth,
      'actor': instance.actor,
      'species': instance.species,
    };
