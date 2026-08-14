import 'package:flutter_test/flutter_test.dart';
import 'package:harry_potter_sorting_flutter/domain/entities/character_entity.dart';
import 'package:harry_potter_sorting_flutter/domain/entities/house.dart';

void main() {
  group('CharacterEntity', () {
    test('stores all fields correctly', () {
      const entity = CharacterEntity(
        id: 'abc-123',
        name: 'Harry Potter',
        imageSrc: 'https://example.com/harry.jpg',
        house: House.gryffindor,
        dateOfBirth: '31-07-1980',
        actor: 'Daniel Radcliffe',
        species: 'human',
      );

      expect(entity.id, 'abc-123');
      expect(entity.name, 'Harry Potter');
      expect(entity.imageSrc, 'https://example.com/harry.jpg');
      expect(entity.house, House.gryffindor);
      expect(entity.dateOfBirth, '31-07-1980');
      expect(entity.actor, 'Daniel Radcliffe');
      expect(entity.species, 'human');
    });

    test('accepts null dateOfBirth', () {
      const entity = CharacterEntity(
        id: 'abc-123',
        name: 'Unknown',
        imageSrc: '',
        house: House.none,
        dateOfBirth: null,
        actor: '',
        species: '',
      );

      expect(entity.dateOfBirth, isNull);
    });
  });

  group('CharacterEntity equality', () {
    const base = CharacterEntity(
      id: '1',
      name: 'Ron Weasley',
      imageSrc: 'https://example.com/ron.jpg',
      house: House.gryffindor,
      dateOfBirth: '01-03-1980',
      actor: 'Rupert Grint',
      species: 'human',
    );

    test('equal when all fields match', () {
      const other = CharacterEntity(
        id: '1',
        name: 'Ron Weasley',
        imageSrc: 'https://example.com/ron.jpg',
        house: House.gryffindor,
        dateOfBirth: '01-03-1980',
        actor: 'Rupert Grint',
        species: 'human',
      );

      expect(base, equals(other));
    });

    test('not equal when id differs', () {
      const other = CharacterEntity(
        id: '2',
        name: 'Ron Weasley',
        imageSrc: 'https://example.com/ron.jpg',
        house: House.gryffindor,
        dateOfBirth: '01-03-1980',
        actor: 'Rupert Grint',
        species: 'human',
      );

      expect(base, isNot(equals(other)));
    });

    test('not equal when name differs', () {
      const other = CharacterEntity(
        id: '1',
        name: 'Ginny Weasley',
        imageSrc: 'https://example.com/ron.jpg',
        house: House.gryffindor,
        dateOfBirth: '01-03-1980',
        actor: 'Rupert Grint',
        species: 'human',
      );

      expect(base, isNot(equals(other)));
    });

    test('not equal when dateOfBirth differs', () {
      const other = CharacterEntity(
        id: '1',
        name: 'Ron Weasley',
        imageSrc: 'https://example.com/ron.jpg',
        house: House.gryffindor,
        dateOfBirth: null,
        actor: 'Rupert Grint',
        species: 'human',
      );

      expect(base, isNot(equals(other)));
    });

    test('hashCode matches for equal entities', () {
      const other = CharacterEntity(
        id: '1',
        name: 'Ron Weasley',
        imageSrc: 'https://example.com/ron.jpg',
        house: House.gryffindor,
        dateOfBirth: '01-03-1980',
        actor: 'Rupert Grint',
        species: 'human',
      );

      expect(base.hashCode, equals(other.hashCode));
    });

    test('hashCode differs for unequal entities', () {
      const other = CharacterEntity(
        id: '2',
        name: 'Hermione Granger',
        imageSrc: 'https://example.com/hermione.jpg',
        house: House.gryffindor,
        dateOfBirth: '19-09-1979',
        actor: 'Emma Watson',
        species: 'human',
      );

      expect(base.hashCode, isNot(equals(other.hashCode)));
    });
  });
}
