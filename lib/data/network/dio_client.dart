import 'package:dio/dio.dart';

class DioClient {

  static final Dio client = Dio();

  static String handleError(DioException e) {
    if (e.type == DioExceptionType.connectionTimeout) {
      return 'Connection Error - Timeout';
    }
    else if (e.type == DioExceptionType.badResponse) {
      return 'Server Error. Please, try again';
    }

    return 'Unknown Error';
  }
}
