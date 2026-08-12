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

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CharacterEntity &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name &&
          imageSrc == other.imageSrc &&
          house == other.house &&
          dateOfBirth == other.dateOfBirth &&
          actor == other.actor &&
          species == other.species;

  @override
  int get hashCode => Object.hash(id, name, imageSrc, house, dateOfBirth, actor, species);

}