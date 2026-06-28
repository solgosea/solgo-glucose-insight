class StatusProbeResultViewModel {
  final String id;
  final String label;
  final String state;
  final String summary;
  final String confidence;
  final List<String> signals;

  const StatusProbeResultViewModel({
    required this.id,
    required this.label,
    required this.state,
    required this.summary,
    required this.confidence,
    this.signals = const [],
  });
}
