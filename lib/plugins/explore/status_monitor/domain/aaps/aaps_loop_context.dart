class AapsLoopContext {
  final DateTime? observedAt;
  final bool visible;
  final bool partial;
  final String label;
  final String note;

  const AapsLoopContext({
    required this.observedAt,
    required this.visible,
    required this.partial,
    required this.label,
    required this.note,
  });
}
