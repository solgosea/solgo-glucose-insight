import '../../../domain/sync_target/glucose_sync_target.dart';

class GlucoseSyncHostKey {
  final String value;

  const GlucoseSyncHostKey(this.value);

  factory GlucoseSyncHostKey.fromTarget(GlucoseSyncTarget target) {
    final url = target.metadata.nightscoutUrl;
    if (url == null || url.trim().isEmpty) {
      return GlucoseSyncHostKey('${target.kind.code}:${target.targetId}');
    }
    final parsed = Uri.tryParse(url.trim());
    if (parsed == null || parsed.host.isEmpty) {
      return GlucoseSyncHostKey('${target.kind.code}:${url.trim()}');
    }
    final port = parsed.hasPort ? ':${parsed.port}' : '';
    return GlucoseSyncHostKey('${parsed.scheme}://${parsed.host}$port');
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GlucoseSyncHostKey &&
          runtimeType == other.runtimeType &&
          value == other.value;

  @override
  int get hashCode => value.hashCode;

  @override
  String toString() => value;
}
