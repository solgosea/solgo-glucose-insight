class AapsPumpContext {
  final DateTime? observedAt;
  final bool visible;
  final bool partial;
  final String statusLabel;
  final String reservoirLabel;
  final String batteryLabel;
  final String note;

  const AapsPumpContext({
    required this.observedAt,
    required this.visible,
    required this.partial,
    required this.statusLabel,
    required this.reservoirLabel,
    required this.batteryLabel,
    required this.note,
  });
}
