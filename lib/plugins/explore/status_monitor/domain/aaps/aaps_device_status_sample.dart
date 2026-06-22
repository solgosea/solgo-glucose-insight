class AapsDeviceStatusSample {
  final DateTime? observedAt;
  final bool hasLoopContext;
  final bool hasPumpContext;
  final bool hasIobContext;
  final bool hasCobContext;
  final bool hasProfileContext;
  final Map<String, Object?> loop;
  final Map<String, Object?> pump;

  const AapsDeviceStatusSample({
    required this.observedAt,
    required this.hasLoopContext,
    required this.hasPumpContext,
    required this.hasIobContext,
    required this.hasCobContext,
    required this.hasProfileContext,
    this.loop = const {},
    this.pump = const {},
  });
}
