class ConnectionTestResult {
  final bool success;
  final String message;

  const ConnectionTestResult({required this.success, required this.message});

  const ConnectionTestResult.success([String message = 'Connection verified'])
    : this(success: true, message: message);

  const ConnectionTestResult.failure(String message)
    : this(success: false, message: message);
}
