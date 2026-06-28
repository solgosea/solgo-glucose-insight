enum GlucoseSyncTaskPriority {
  background(10),
  foreground(30),
  setup(70),
  manual(100);

  final int weight;

  const GlucoseSyncTaskPriority(this.weight);
}
