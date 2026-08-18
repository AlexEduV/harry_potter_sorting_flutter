import 'package:dio/dio.dart';

class LoggingInterceptor implements Interceptor {
  final Function(String?) logUsing;
  final bool isVerbose;

  LoggingInterceptor({required this.logUsing, this.isVerbose = false});

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    logUsing('✗ ${err.type} ${err.requestOptions.uri} — ${err.response?.data}');
    handler.next(err);
  }

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    logUsing('→ ${options.method} ${options.uri}');
    handler.next(options);
  }

  @override
  void onResponse(Response<dynamic> response, ResponseInterceptorHandler handler) {
    logUsing('← ${response.statusCode} ${response.requestOptions.uri}');
    if (isVerbose) logUsing(response.data.toString());
    handler.next(response);
  }
}
