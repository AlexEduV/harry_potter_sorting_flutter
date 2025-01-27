import 'package:harry_potter_sorting_flutter/domain/models/character.dart';
import 'package:json_annotation/json_annotation.dart';

part 'character_wrapper.g.dart';

@JsonSerializable()
class CharacterWrapper {
  final List<Character> results;

  CharacterWrapper({required this.results});

  factory CharacterWrapper.fromJson(Map<String, dynamic> json) =>
      _$CharacterWrapperFromJson(json);
}