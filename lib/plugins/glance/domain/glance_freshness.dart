class GlanceFreshness {
  final DateTime? updatedAt;
  final DateTime evaluatedAt;
  final String label;
  final bool isFresh;
  final bool isStale;

  const GlanceFreshness({
    required this.updatedAt,
    required this.evaluatedAt,
    required this.label,
    required this.isFresh,
    required this.isStale,
  });

  factory GlanceFreshness.evaluate({
    required DateTime? updatedAt,
    required DateTime now,
    Duration freshWindow = const Duration(minutes: 15),
  }) {
    if (updatedAt == null) {
      return GlanceFreshness(
        updatedAt: null,
        evaluatedAt: now,
        label: '--',
        isFresh: false,
        isStale: true,
      );
    }
    final age = now.difference(updatedAt);
    final minutes = age.inMinutes.clamp(0, 100000);
    final label = minutes <= 0 ? '0m' : '${minutes}m';
    return GlanceFreshness(
      updatedAt: updatedAt,
      evaluatedAt: now,
      label: label,
      isFresh: age <= freshWindow,
      isStale: age > freshWindow,
    );
  }
}
