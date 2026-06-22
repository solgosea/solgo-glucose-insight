class StatusComponentScore {
  final int value;
  final String label;
  final double confidence;
  final int availableSignals;
  final int totalSignals;

  const StatusComponentScore({
    required this.value,
    required this.label,
    required this.confidence,
    required this.availableSignals,
    required this.totalSignals,
  });

  String get availabilityLabel =>
      '$availableSignals of $totalSignals checks passed';
}
