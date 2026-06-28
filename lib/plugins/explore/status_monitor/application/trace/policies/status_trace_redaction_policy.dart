class StatusTraceRedactionPolicy {
  static final _sensitive = RegExp(
    r'(https?://|token|secret|api[_-]?key|subject|password)',
    caseSensitive: false,
  );

  const StatusTraceRedactionPolicy();

  String redact(String value) {
    if (!_sensitive.hasMatch(value)) return value;
    return 'Configured source';
  }
}
