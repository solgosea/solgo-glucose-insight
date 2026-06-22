import 'package:flutter_test/flutter_test.dart';
import 'package:smart_xdrip/plugins/explore/status_monitor/domain/detail/status_probe_message_sanitizer.dart';

void main() {
  const sanitizer = StatusProbeMessageSanitizer();

  test('maps raw Dio and socket failures to user-safe copy', () {
    final message = sanitizer.cleanDisplayMessage(
      'DioException [connection error]: SocketException: Connection refused, '
      'uri=http://127.0.0.1:1337/api/v1/status.json',
    );

    expect(message, 'The endpoint could not be reached from this device.');
    expect(message, isNot(contains('DioException')));
    expect(message, isNot(contains('127.0.0.1')));
  });

  test('maps auth failures without exposing raw transport details', () {
    final message = sanitizer.fromHttpResult(
      reachable: false,
      statusCode: 403,
      error: 'DioException: 403 Forbidden',
    );

    expect(message, 'Authentication was rejected by this endpoint.');
    expect(message, isNot(contains('DioException')));
  });

  test('maps reachable payload failures to readable copy', () {
    final message = sanitizer.fromHttpResult(
      reachable: true,
      statusCode: 200,
      error: const FormatException('Unexpected token'),
    );

    expect(
        message, 'The endpoint responded, but the payload could not be read.');
  });

  test('keeps already-safe display messages unchanged', () {
    final message = sanitizer.cleanDisplayMessage(
      'The endpoint did not respond before the request timed out.',
    );

    expect(
      message,
      'The endpoint did not respond before the request timed out.',
    );
  });
}
