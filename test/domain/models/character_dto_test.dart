import 'package:flutter_test/flutter_test.dart';
import 'package:harry_potter_sorting_flutter/domain/models/character_dto.dart';

void main() {
  const fullJson = {
    'id': 'abc-123',
    'name': 'Harry Potter',
    'image': 'https://example.com/harry.jpg',
    'house': 'Gryffindor',
    'dateOfBirth': '31-07-1980',
    'actor': 'Daniel Radcliffe',
    'species': 'human',
  };

  const noDateJson = {
    'id': 'abc-123',
    'name': 'Harry Potter',
    'image': 'https://example.com/harry.jpg',
    'house': 'Gryffindor',
    'dateOfBirth': null,
    'actor': 'Daniel Radcliffe',
    'species': 'human',
  };

  group('CharacterDTO.fromJson', () {
    test('maps all fields correctly', () {
      final dto = CharacterDTO.fromJson(fullJson);

      expect(dto.id, 'abc-123');
      expect(dto.name, 'Harry Potter');
      expect(dto.imageSrc, 'https://example.com/harry.jpg');
      expect(dto.house, 'Gryffindor');
      expect(dto.dateOfBirth, '31-07-1980');
      expect(dto.actor, 'Daniel Radcliffe');
      expect(dto.species, 'human');
    });

    test('maps image key to imageSrc', () {
      final dto = CharacterDTO.fromJson(fullJson);
      expect(dto.imageSrc, fullJson['image']);
    });

    test('accepts null dateOfBirth', () {
      final dto = CharacterDTO.fromJson(noDateJson);
      expect(dto.dateOfBirth, isNull);
    });
  });

  group('CharacterDTO constructor', () {
    test('stores all required fields', () {
      const dto = CharacterDTO(
        id: 'xyz',
        name: 'Hermione Granger',
        imageSrc: 'https://example.com/hermione.jpg',
        house: 'Gryffindor',
        actor: 'Emma Watson',
        species: 'human',
      );

      expect(dto.id, 'xyz');
      expect(dto.name, 'Hermione Granger');
      expect(dto.imageSrc, 'https://example.com/hermione.jpg');
      expect(dto.house, 'Gryffindor');
      expect(dto.dateOfBirth, isNull);
      expect(dto.actor, 'Emma Watson');
      expect(dto.species, 'human');
    });
  });
}
