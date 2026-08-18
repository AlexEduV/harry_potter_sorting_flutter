import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:harry_potter_sorting_flutter/common/constants/api_constants.dart';
import 'package:harry_potter_sorting_flutter/data/network/logging_interceptor.dart';

class DioClient {
  static final Dio _client = _createClient();

  static Dio get client => _client;

  static Dio _createClient() {
    final dio = Dio(BaseOptions(
        baseUrl: ApiConstants.baseUrl,
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10)));

    dio.interceptors.add(LoggingInterceptor(logUsing: debugPrint));
    dio.transformer = BackgroundTransformer();

    return dio;
  }
}
