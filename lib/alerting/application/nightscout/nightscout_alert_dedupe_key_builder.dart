import '../../../application/nightscout/nightscout_url_normalizer.dart';

class NightscoutAlertDedupeKeyBuilder {
  final Duration bucketSize;

  const NightscoutAlertDedupeKeyBuilder({
    this.bucketSize = const Duration(minutes: 5),
  });

  String? canonicalSourceKey(String? url) {
    final normalized = NightscoutUrlNormalizer.normalize(url ?? '');
    if (normalized == null) return null;
    final uri = Uri.tryParse(normalized);
    if (uri == null || uri.host.trim().isEmpty) return null;
    final normalizedUri = uri.replace(host: uri.host.toLowerCase());
    final text = normalizedUri.toString();
    final trimmed =
        text.endsWith('/') ? text.substring(0, text.length - 1) : text;
    return 'nightscout:$trimmed';
  }

  String? build({
    required String? url,
    required String? alertType,
    required DateTime occurredAt,
  }) {
    final key = canonicalSourceKey(url);
    final type = alertType?.trim();
    if (key == null || type == null || type.isEmpty) return null;
    final bucket =
        occurredAt.millisecondsSinceEpoch ~/ bucketSize.inMilliseconds;
    return '$key:$type:$bucket';
  }
}
