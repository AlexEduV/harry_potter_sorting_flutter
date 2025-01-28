// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'character_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CharacterDTO _$CharacterDTOFromJson(Map<String, dynamic> json) => CharacterDTO(
      id: json['id'] as String,
      name: json['name'] as String,
      imageSrc: json['image'] as String,
      house: json['house'] as String,
      dateOfBirth: json['dateOfBirth'] as String?,
      actor: json['actor'] as String,
      species: json['species'] as String,
    );

Map<String, dynamic> _$CharacterDTOToJson(CharacterDTO instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'image': instance.imageSrc,
      'house': instance.house,
      'dateOfBirth': instance.dateOfBirth,
      'actor': instance.actor,
      'species': instance.species,
    };
