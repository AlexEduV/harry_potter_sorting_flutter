import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:harry_potter_sorting_flutter/data/services/character_api_service.dart';

// ---------------------------------------------------------------------------
// Minimal Dio adapter that returns a pre-configured response without touching
// the network.
// ---------------------------------------------------------------------------
class _StubAdapter implements HttpClientAdapter {
  _StubAdapter({required this.statusCode, required this.body});

  final int statusCode;
  final String body;

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<List<int>>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    return ResponseBody.fromString(
      body,
      statusCode,
      headers: {
        Headers.contentTypeHeader: [Headers.jsonContentType],
      },
    );
  }

  @override
  void close({bool force = false}) {}
}

// ---------------------------------------------------------------------------
// Helpers
// ---------------------------------------------------------------------------
const _baseUrl = 'https://hp-api.onrender.com/api';

Map<String, dynamic> _characterJson({
  String id = 'abc-1',
  String name = 'Harry Potter',
  String house = 'Gryffindor',
  String? dateOfBirth = '31-07-1980',
}) =>
    {
      'id': id,
      'name': name,
      'image': 'https://example.com/$id.jpg',
      'house': house,
      'dateOfBirth': dateOfBirth,
      'actor': 'Daniel Radcliffe',
      'species': 'human',
    };

CharacterApiService _makeService(HttpClientAdapter adapter) {
  final dio = Dio(BaseOptions(baseUrl: _baseUrl));
  dio.httpClientAdapter = adapter;
  return CharacterApiService(dio);
}

void main() {
  group('CharacterApiService.getAllCharacters', () {
    test('deserializes a list of characters from JSON', () async {
      final adapter = _StubAdapter(
        statusCode: HttpStatus.ok,
        body: jsonEncode([
          _characterJson(id: '1', name: 'Harry Potter'),
          _characterJson(id: '2', name: 'Hermione Granger', house: 'Gryffindor'),
        ]),
      );

      final service = _makeService(adapter);
      final result = await service.getAllCharacters();

      expect(result, hasLength(2));
      expect(result[0].name, 'Harry Potter');
      expect(result[0].id, '1');
      expect(result[0].house, 'Gryffindor');
      expect(result[1].name, 'Hermione Granger');
    });

    test('maps the image field to imageSrc', () async {
      final adapter = _StubAdapter(
        statusCode: HttpStatus.ok,
        body: jsonEncode([_characterJson(id: '1')]),
      );

      final result = await _makeService(adapter).getAllCharacters();
      expect(result.first.imageSrc, 'https://example.com/1.jpg');
    });

    test('accepts null dateOfBirth', () async {
      final adapter = _StubAdapter(
        statusCode: HttpStatus.ok,
        body: jsonEncode([_characterJson(dateOfBirth: null)]),
      );

      final result = await _makeService(adapter).getAllCharacters();
      expect(result.first.dateOfBirth, isNull);
    });

    test('returns an empty list when the API responds with an empty array', () async {
      final adapter = _StubAdapter(
        statusCode: HttpStatus.ok,
        body: jsonEncode([]),
      );

      final result = await _makeService(adapter).getAllCharacters();
      expect(result, isEmpty);
    });

    test('throws DioException on a 500 response', () async {
      final adapter = _StubAdapter(
        statusCode: HttpStatus.internalServerError,
        body: 'Internal Server Error',
      );

      expect(
        () => _makeService(adapter).getAllCharacters(),
        throwsA(isA<DioException>()),
      );
    });

    test('throws DioException on a 404 response', () async {
      final adapter = _StubAdapter(
        statusCode: HttpStatus.notFound,
        body: 'Not Found',
      );

      expect(
        () => _makeService(adapter).getAllCharacters(),
        throwsA(isA<DioException>()),
      );
    });
  });
}
