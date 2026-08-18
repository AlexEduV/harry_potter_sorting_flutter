import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:harry_potter_sorting_flutter/common/constants/api_constants.dart';

class DioClient {
  static final Dio _client = _createClient();

  static Dio client() => _client;

  static Dio _createClient() {
    final dio = Dio(BaseOptions(baseUrl: ApiConstants.baseUrl));

    dio.interceptors.add(
      LogInterceptor(
        requestBody: true,
        responseBody: true,
        error: true,
        logPrint: (log) => debugPrint(log.toString()),
      ),
    );

    return dio;
  }
}
