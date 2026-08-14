enum House {
  gryffindor,
  slytherin,
  ravenclaw,
  hufflepuff,
  none;

  static House fromString(String value) {
    return switch (value.toLowerCase()) {
      'gryffindor' => House.gryffindor,
      'slytherin' => House.slytherin,
      'ravenclaw' => House.ravenclaw,
      'hufflepuff' => House.hufflepuff,
      _ => House.none,
    };
  }

  String get displayName => switch (this) {
        House.gryffindor => 'Gryffindor',
        House.slytherin => 'Slytherin',
        House.ravenclaw => 'Ravenclaw',
        House.hufflepuff => 'Hufflepuff',
        House.none => 'Not in House',
      };

  String? get imageSrc => switch (this) {
        House.gryffindor => 'assets/house_crests/gryffindor-96.png',
        House.slytherin => 'assets/house_crests/slytherin-96.png',
        House.ravenclaw => 'assets/house_crests/ravenclaw-96.png',
        House.hufflepuff => 'assets/house_crests/hufflepuff-96.png',
        House.none => null,
      };
}
