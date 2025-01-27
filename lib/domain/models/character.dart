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

  @JsonKey(fromJson: _dateFromJson)
  final DateTime? dateOfBirth;

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

  static DateTime? _dateFromJson(String? date) {
    if (date == null || date.isEmpty) return null;

    try {
      final parts = date.split('-');
      if (parts.length == 3) {
        final day = int.parse(parts[0]);
        final month = int.parse(parts[1]);
        final year = int.parse(parts[2]);
        return DateTime(year, month, day);
      }
    } catch (e) {
      debugPrint('Failed to parse date: $date, error: $e');
    }

    throw FormatException('Invalid date format: $date');
  }

}