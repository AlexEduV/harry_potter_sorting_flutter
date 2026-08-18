import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:harry_potter_sorting_flutter/common/constants/api_constants.dart';

class DioClient {
  static final Dio _client = Dio(BaseOptions(baseUrl: ApiConstants.baseUrl));

  static Dio client() => _client;

  static String handleError(DioException e) {
    // Log the exception for debugging purposes
    debugPrint('Error: ${e.toString()}');

    // Handle known errors
    if (e.type == DioExceptionType.connectionTimeout) {
      return 'Connection Error - Timeout';
    } else if (e.type == DioExceptionType.badResponse) {
      return 'Server Error. Please, try again';
    } else if (e.type == DioExceptionType.cancel) {
      return 'Request was canceled';
    }

    // Fallback for unknown errors
    return 'Unknown Error: Please try again later';
  }
}
