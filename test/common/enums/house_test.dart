import 'package:flutter_test/flutter_test.dart';
import 'package:harry_potter_sorting_flutter/common/enums/house.dart';

void main() {
  group('House.fromString', () {
    test('parses exact case-sensitive names', () {
      expect(House.fromString('Gryffindor'), House.gryffindor);
      expect(House.fromString('Slytherin'), House.slytherin);
      expect(House.fromString('Ravenclaw'), House.ravenclaw);
      expect(House.fromString('Hufflepuff'), House.hufflepuff);
    });

    test('parses lowercase names', () {
      expect(House.fromString('gryffindor'), House.gryffindor);
      expect(House.fromString('slytherin'), House.slytherin);
      expect(House.fromString('ravenclaw'), House.ravenclaw);
      expect(House.fromString('hufflepuff'), House.hufflepuff);
    });

    test('parses uppercase names', () {
      expect(House.fromString('GRYFFINDOR'), House.gryffindor);
      expect(House.fromString('SLYTHERIN'), House.slytherin);
    });

    test('returns none for empty string', () {
      expect(House.fromString(''), House.none);
    });

    test('returns none for unknown value', () {
      expect(House.fromString('Durmstrang'), House.none);
    });
  });

  group('House.displayName', () {
    test('returns correct display name for each house', () {
      expect(House.gryffindor.displayName, 'Gryffindor');
      expect(House.slytherin.displayName, 'Slytherin');
      expect(House.ravenclaw.displayName, 'Ravenclaw');
      expect(House.hufflepuff.displayName, 'Hufflepuff');
      expect(House.none.displayName, 'Not in House');
    });

    test('roundtrips through fromString', () {
      for (final house in House.values.where((h) => h != House.none)) {
        expect(House.fromString(house.displayName), house);
      }
    });
  });

  group('House.imageSrc', () {
    test('returns asset path for each named house', () {
      expect(House.gryffindor.imageSrc, 'assets/house_crests/gryffindor-96.png');
      expect(House.slytherin.imageSrc, 'assets/house_crests/slytherin-96.png');
      expect(House.ravenclaw.imageSrc, 'assets/house_crests/ravenclaw-96.png');
      expect(House.hufflepuff.imageSrc, 'assets/house_crests/hufflepuff-96.png');
    });

    test('returns null for none', () {
      expect(House.none.imageSrc, isNull);
    });
  });
}
