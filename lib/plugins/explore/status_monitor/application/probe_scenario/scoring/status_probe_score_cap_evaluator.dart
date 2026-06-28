class StatusProbeScoreCapEvaluator {
  const StatusProbeScoreCapEvaluator();

  int apply(int score, Iterable<int> caps) {
    var result = score;
    for (final cap in caps) {
      if (cap < result) result = cap;
    }
    return result.clamp(0, 100);
  }
}
