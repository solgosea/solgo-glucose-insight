class SmartGlucoseSyncChunk {
  final DateTime from;
  final DateTime to;
  final int index;

  const SmartGlucoseSyncChunk({
    required this.from,
    required this.to,
    required this.index,
  });

  Duration get duration => to.difference(from);
}
