class GlucoseSourcePriorityPolicy {
  final Duration recentWindow;

  const GlucoseSourcePriorityPolicy({
    this.recentWindow = const Duration(minutes: 30),
  });

  int priority({
    required String source,
    required DateTime readingTime,
    DateTime? now,
  }) {
    final current = now ?? DateTime.now();
    final recent = !readingTime.isBefore(current.subtract(recentWindow));
    if (recent) {
      return switch (source) {
        'xdripHttp' => 100,
        'nightscout' => 90,
        _ => 50,
      };
    }
    return switch (source) {
      'nightscout' => 100,
      'xdripHttp' => 70,
      _ => 50,
    };
  }
}
