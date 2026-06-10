class NightscoutUrlNormalizer {
  const NightscoutUrlNormalizer._();

  static String? normalize(String raw) {
    final trimmed = raw.trim();
    if (trimmed.isEmpty) return null;

    final withScheme =
        _hasScheme(trimmed) ? trimmed : '${_defaultScheme(trimmed)}://$trimmed';
    final uri = Uri.tryParse(withScheme);
    if (uri == null || uri.host.trim().isEmpty) return null;

    return withScheme.endsWith('/')
        ? withScheme.substring(0, withScheme.length - 1)
        : withScheme;
  }

  static bool _hasScheme(String input) {
    final lower = input.toLowerCase();
    return lower.startsWith('http://') || lower.startsWith('https://');
  }

  static String _defaultScheme(String input) {
    final host = _hostCandidate(input).toLowerCase();
    if (host == 'localhost' || host.startsWith('127.')) return 'http';
    if (host.startsWith('192.168.')) return 'http';
    if (host.startsWith('10.')) return 'http';

    final parts = host.split('.');
    if (parts.length == 4) {
      final first = int.tryParse(parts[0]);
      final second = int.tryParse(parts[1]);
      if (first == 172 && second != null && second >= 16 && second <= 31) {
        return 'http';
      }
    }
    return 'https';
  }

  static String _hostCandidate(String input) {
    final withoutPath = input.split('/').first;
    final withoutQuery = withoutPath.split('?').first;
    final withoutHash = withoutQuery.split('#').first;
    return withoutHash.split(':').first;
  }
}
