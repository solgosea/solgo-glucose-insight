class ReportPrivacyPolicy {
  const ReportPrivacyPolicy();

  String sourceLabel(String? label) {
    final value = (label ?? '').trim();
    if (value.isEmpty) return 'Configured source';
    final lower = value.toLowerCase();
    if (lower.startsWith('http://') ||
        lower.startsWith('https://') ||
        lower.contains('token') ||
        lower.contains('secret') ||
        lower.contains('api_secret') ||
        lower.contains('apikey') ||
        lower.contains('api-key')) {
      return 'Configured source';
    }
    return value;
  }
}
