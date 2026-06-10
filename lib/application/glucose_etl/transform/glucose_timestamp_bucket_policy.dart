class GlucoseTimestampBucketPolicy {
  final Duration bucketSize;

  const GlucoseTimestampBucketPolicy({
    this.bucketSize = const Duration(seconds: 30),
  });

  int bucketMs(DateTime timestamp) {
    final size = bucketSize.inMilliseconds;
    final millis = timestamp.millisecondsSinceEpoch;
    return ((millis + (size ~/ 2)) ~/ size) * size;
  }
}
