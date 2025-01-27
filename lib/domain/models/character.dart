import 'package:harry_potter_sorting_flutter/domain/models/house.dart';

class Character {

  final int id;
  final String name;
  final String imageSrc;
  final House house;
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

}