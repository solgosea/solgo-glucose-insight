import 'package:dio/dio.dart';

class GlucoseSyncErrorClassifier {
  const GlucoseSyncErrorClassifier();

  String classify(Object error) {
    if (error is DioException) {
      final status = error.response?.statusCode;
      if (status == 401 || status == 403) return 'auth_failed';
      if (status == 404) return 'endpoint_not_found';
      if (status == 429) return 'rate_limited';
      if (status != null && status >= 500) return 'server_error';
      return switch (error.type) {
        DioExceptionType.connectionTimeout => 'connection_timeout',
        DioExceptionType.receiveTimeout => 'receive_timeout',
        DioExceptionType.sendTimeout => 'send_timeout',
        DioExceptionType.connectionError => 'connection_error',
        DioExceptionType.badCertificate => 'bad_certificate',
        DioExceptionType.badResponse => 'bad_response',
        DioExceptionType.cancel => 'request_cancelled',
        DioExceptionType.unknown => 'network_error',
      };
    }
    return 'sync_failed';
  }

  bool isRetryable(Object error) {
    if (error is! DioException) return false;
    final status = error.response?.statusCode;
    if (status == 429) return true;
    if (status != null && status >= 500) return true;
    return switch (error.type) {
      DioExceptionType.connectionTimeout ||
      DioExceptionType.receiveTimeout ||
      DioExceptionType.sendTimeout ||
      DioExceptionType.connectionError ||
      DioExceptionType.unknown => true,
      DioExceptionType.badCertificate ||
      DioExceptionType.badResponse ||
      DioExceptionType.cancel => false,
    };
  }
}
