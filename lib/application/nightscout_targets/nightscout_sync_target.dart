import 'nightscout_sync_target_kind.dart';
import 'nightscout_sync_target_status.dart';

class NightscoutSyncTarget {
  final String targetId;
  final NightscoutSyncTargetKind kind;
  final String subjectId;
  final String label;
  final String normalizedUrl;
  final String? accessToken;
  final String? accessTokenFingerprint;
  final String ownerPluginId;
  final NightscoutSyncTargetStatus status;
  final DateTime updatedAt;
  final Map<String, Object?> metadata;

  const NightscoutSyncTarget({
    required this.targetId,
    required this.kind,
    required this.subjectId,
    required this.label,
    required this.normalizedUrl,
    this.accessToken,
    required this.ownerPluginId,
    required this.status,
    required this.updatedAt,
    this.accessTokenFingerprint,
    this.metadata = const {},
  });

  bool get enabled => status == NightscoutSyncTargetStatus.active;

  NightscoutSyncTarget copyWith({
    NightscoutSyncTargetStatus? status,
    DateTime? updatedAt,
  }) {
    return NightscoutSyncTarget(
      targetId: targetId,
      kind: kind,
      subjectId: subjectId,
      label: label,
      normalizedUrl: normalizedUrl,
      accessToken: accessToken,
      accessTokenFingerprint: accessTokenFingerprint,
      ownerPluginId: ownerPluginId,
      status: status ?? this.status,
      updatedAt: updatedAt ?? this.updatedAt,
      metadata: metadata,
    );
  }

  Map<String, Object?> toRuntimePayload() {
    return {
      'targetId': targetId,
      'kind': kind.name,
      'subjectId': subjectId,
      'label': label,
      'normalizedUrl': normalizedUrl,
      'accessToken': accessToken,
      'accessTokenFingerprint': accessTokenFingerprint,
      'ownerPluginId': ownerPluginId,
      'status': status.name,
      'enabled': enabled,
      'updatedAt': updatedAt.toIso8601String(),
      'metadata': metadata,
    };
  }

  static NightscoutSyncTarget? fromRuntimePayload(
    Map<String, Object?> payload,
  ) {
    final targetId = payload['targetId']?.toString();
    final subjectId = payload['subjectId']?.toString();
    final label = payload['label']?.toString();
    final normalizedUrl = payload['normalizedUrl']?.toString();
    final ownerPluginId = payload['ownerPluginId']?.toString();
    if (targetId == null ||
        targetId.isEmpty ||
        subjectId == null ||
        subjectId.isEmpty ||
        label == null ||
        label.isEmpty ||
        normalizedUrl == null ||
        normalizedUrl.isEmpty ||
        ownerPluginId == null ||
        ownerPluginId.isEmpty) {
      return null;
    }
    final kind = _kind(payload['kind']?.toString());
    final status = _status(payload['status']?.toString());
    if (kind == null || status == null) return null;
    return NightscoutSyncTarget(
      targetId: targetId,
      kind: kind,
      subjectId: subjectId,
      label: label,
      normalizedUrl: normalizedUrl,
      accessToken: payload['accessToken']?.toString(),
      accessTokenFingerprint: payload['accessTokenFingerprint']?.toString(),
      ownerPluginId: ownerPluginId,
      status: status,
      updatedAt: DateTime.tryParse(payload['updatedAt']?.toString() ?? '') ??
          DateTime.now(),
      metadata: payload['metadata'] is Map
          ? Map<String, Object?>.from(payload['metadata'] as Map)
          : const {},
    );
  }

  static NightscoutSyncTargetKind? _kind(String? value) {
    return switch (value) {
      'selfDatasource' => NightscoutSyncTargetKind.selfDatasource,
      _ => null,
    };
  }

  static NightscoutSyncTargetStatus? _status(String? value) {
    return switch (value) {
      'active' => NightscoutSyncTargetStatus.active,
      'disabled' => NightscoutSyncTargetStatus.disabled,
      'removed' => NightscoutSyncTargetStatus.removed,
      _ => null,
    };
  }
}
