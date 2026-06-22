class AapsIobCobContext {
  final DateTime? observedAt;
  final bool hasIob;
  final bool hasCob;
  final String iobLabel;
  final String cobLabel;
  final String note;

  const AapsIobCobContext({
    required this.observedAt,
    required this.hasIob,
    required this.hasCob,
    required this.iobLabel,
    required this.cobLabel,
    required this.note,
  });
}
