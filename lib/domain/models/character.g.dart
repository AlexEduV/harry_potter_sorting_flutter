// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'character.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Character _$CharacterFromJson(Map<String, dynamic> json) => Character(
      id: json['id'] as String,
      name: json['name'] as String,
      imageSrc: json['image'] as String,
      house: json['house'] as String,
      dateOfBirth: json['dateOfBirth'] as String?,
      actor: json['actor'] as String,
      species: json['species'] as String,
    );

Map<String, dynamic> _$CharacterToJson(Character instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'image': instance.imageSrc,
      'house': instance.house,
      'dateOfBirth': instance.dateOfBirth,
      'actor': instance.actor,
      'species': instance.species,
    };
