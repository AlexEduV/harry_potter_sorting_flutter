// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'character_wrapper.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CharacterWrapper _$CharacterWrapperFromJson(Map<String, dynamic> json) =>
    CharacterWrapper(
      results: (json['results'] as List<dynamic>)
          .map((e) => Character.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$CharacterWrapperToJson(CharacterWrapper instance) =>
    <String, dynamic>{
      'results': instance.results,
    };
