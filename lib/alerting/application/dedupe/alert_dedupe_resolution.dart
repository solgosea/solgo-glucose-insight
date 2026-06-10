enum AlertDedupeResolutionType { enqueue, suppress, replaceExisting }

class AlertDedupeResolution {
  final AlertDedupeResolutionType type;
  final String? reason;

  const AlertDedupeResolution._(this.type, this.reason);

  const AlertDedupeResolution.enqueue()
    : this._(AlertDedupeResolutionType.enqueue, null);

  const AlertDedupeResolution.suppress(String reason)
    : this._(AlertDedupeResolutionType.suppress, reason);

  const AlertDedupeResolution.replaceExisting()
    : this._(AlertDedupeResolutionType.replaceExisting, null);
}
