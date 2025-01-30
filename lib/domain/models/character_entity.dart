class CharacterEntity {

  final String id;
  final String name;
  final String imageSrc;

  final String house;

  final String? dateOfBirth;

  final String actor;
  final String species;

  const CharacterEntity({
    required this.id,
    required this.name,
    required this.imageSrc,
    required this.house,
    required this.dateOfBirth,
    required this.actor,
    required this.species,
  });

}