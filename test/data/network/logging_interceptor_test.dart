import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:harry_potter_sorting_flutter/data/network/logging_interceptor.dart';

class _StubAdapter implements HttpClientAdapter {
  _StubAdapter({required this.statusCode, this.body = '[]'});

  final int statusCode;
  final String body;

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<List<int>>? requestStream,
    Future<void>? cancelFuture,
  ) async =>
      ResponseBody.fromString(body, statusCode, headers: {
        Headers.contentTypeHeader: [Headers.jsonContentType],
      });

  @override
  void close({bool force = false}) {}
}

Dio _makeDio(
  List<String?> log, {
  bool isVerbose = false,
  int statusCode = HttpStatus.ok,
  String body = '[]',
}) {
  final dio = Dio(BaseOptions(baseUrl: 'https://example.com'));
  dio.httpClientAdapter = _StubAdapter(statusCode: statusCode, body: body);
  dio.interceptors.add(LoggingInterceptor(logUsing: log.add, isVerbose: isVerbose));
  return dio;
}

void main() {
  group('LoggingInterceptor — onRequest', () {
    test('logs HTTP method', () async {
      final log = <String?>[];
      await _makeDio(log).get('/characters');
      expect(log.first, contains('GET'));
    });

    test('logs request URI', () async {
      final log = <String?>[];
      await _makeDio(log).get('/characters');
      expect(log.first, contains('characters'));
    });

    test('log line starts with →', () async {
      final log = <String?>[];
      await _makeDio(log).get('/characters');
      expect(log.first, startsWith('→'));
    });
  });

  group('LoggingInterceptor — onResponse', () {
    test('logs status code', () async {
      final log = <String?>[];
      await _makeDio(log).get('/characters');
      expect(log.last, contains('200'));
    });

    test('logs response URI', () async {
      final log = <String?>[];
      await _makeDio(log).get('/characters');
      expect(log.last, contains('characters'));
    });

    test('log line starts with ←', () async {
      final log = <String?>[];
      await _makeDio(log).get('/characters');
      expect(log[1], startsWith('←'));
    });

    test('does not log body when isVerbose is false', () async {
      final log = <String?>[];
      await _makeDio(log, isVerbose: false, body: '["secret"]').get('/characters');
      expect(log, hasLength(2)); // request + response line only
      expect(log.any((l) => l?.contains('secret') == true), isFalse);
    });

    test('logs body as third entry when isVerbose is true', () async {
      final log = <String?>[];
      await _makeDio(log, isVerbose: true, body: '["payload"]').get('/characters');
      expect(log, hasLength(3));
      expect(log.last, contains('payload'));
    });
  });

  group('LoggingInterceptor — onError', () {
    Future<void> _fetch(List<String?> log, {int statusCode = HttpStatus.internalServerError}) async {
      try {
        await _makeDio(log, statusCode: statusCode).get('/characters');
      } on DioException catch (_) {}
    }

    test('logs URI on error', () async {
      final log = <String?>[];
      await _fetch(log);
      expect(log.last, contains('characters'));
    });

    test('log line starts with ✗', () async {
      final log = <String?>[];
      await _fetch(log);
      expect(log.last, startsWith('✗'));
    });

    test('logs error type on 500', () async {
      final log = <String?>[];
      await _fetch(log, statusCode: HttpStatus.internalServerError);
      expect(log.last, contains('badResponse'));
    });

    test('logs error type on 404', () async {
      final log = <String?>[];
      await _fetch(log, statusCode: HttpStatus.notFound);
      expect(log.last, contains('badResponse'));
    });

    test('produces exactly two log entries (request + error)', () async {
      final log = <String?>[];
      await _fetch(log);
      expect(log, hasLength(2));
    });
  });
}
