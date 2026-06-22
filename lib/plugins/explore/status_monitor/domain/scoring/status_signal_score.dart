class StatusSignalScore {
  final String ruleId;
  final int score;
  final double weight;
  final bool available;

  const StatusSignalScore({
    required this.ruleId,
    required this.score,
    required this.weight,
    required this.available,
  });
}
