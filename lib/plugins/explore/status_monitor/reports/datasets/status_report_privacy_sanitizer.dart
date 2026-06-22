class StatusReportPrivacySanitizer {
  const StatusReportPrivacySanitizer();

  String text(String value, {String replacement = 'Configured source'}) {
    final trimmed = value.trim();
    if (trimmed.isEmpty) return trimmed;
    final lower = trimmed.toLowerCase();
    if (lower.contains('http://') ||
        lower.contains('https://') ||
        lower.contains('token') ||
        lower.contains('secret') ||
        lower.contains('api_secret') ||
        lower.contains('apikey') ||
        lower.contains('api-key')) {
      return replacement;
    }
    return trimmed;
  }
}
