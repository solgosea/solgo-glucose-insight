class BackgroundSyncPolicy {
  final Duration syncInterval;

  const BackgroundSyncPolicy({this.syncInterval = const Duration(minutes: 5)});
}
