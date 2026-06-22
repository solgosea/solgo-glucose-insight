class StatusProbeMessageSanitizer {
  const StatusProbeMessageSanitizer();

  String? fromHttpResult({
    required bool reachable,
    required int? statusCode,
    required Object? error,
  }) {
    if (error == null && reachable) return null;

    final code = statusCode;
    if (code == 401 || code == 403) {
      return 'Authentication was rejected by this endpoint.';
    }
    if (code != null && code >= 500) {
      return 'The endpoint returned a server error.';
    }
    if (code != null && code >= 400) {
      return 'The endpoint returned HTTP $code.';
    }
    if (reachable && error != null) {
      return 'The endpoint responded, but the payload could not be read.';
    }

    return _fromRaw(error?.toString().toLowerCase() ?? '');
  }

  String? cleanDisplayMessage(String? message) {
    if (message == null || message.trim().isEmpty) return null;
    final raw = message.trim();
    final lower = raw.toLowerCase();
    if (lower.contains('dioexception') ||
        lower.contains('socketexception') ||
        lower.contains('handshakeexception') ||
        lower.contains('stacktrace') ||
        lower.contains('package:') ||
        lower.contains('uri=') ||
        lower.contains('requestoptions')) {
      return _fromRaw(lower);
    }
    return raw;
  }

  String _fromRaw(String raw) {
    if (raw.contains('401') || raw.contains('403')) {
      return 'Authentication was rejected by this endpoint.';
    }
    if (raw.contains('timeout') || raw.contains('timed out')) {
      return 'The endpoint did not respond before the request timed out.';
    }
    if (raw.contains('connection refused') ||
        raw.contains('connection reset') ||
        raw.contains('failed host lookup') ||
        raw.contains('socketexception') ||
        raw.contains('network is unreachable')) {
      return 'The endpoint could not be reached from this device.';
    }
    if (raw.contains('handshakeexception') ||
        raw.contains('certificate') ||
        raw.contains('ssl') ||
        raw.contains('tls')) {
      return 'The secure connection could not be verified.';
    }
    if (raw.contains('cancel')) {
      return 'The request was cancelled before it completed.';
    }
    return 'The endpoint could not be checked right now.';
  }
}
