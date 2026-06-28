class StatusHubPathScoreWeights {
  final double freshness;
  final double delay;
  final double evidence;
  final double confidence;
  final double pathHealth;

  const StatusHubPathScoreWeights({
    this.freshness = .30,
    this.delay = .25,
    this.evidence = .20,
    this.confidence = .15,
    this.pathHealth = .10,
  });
}
