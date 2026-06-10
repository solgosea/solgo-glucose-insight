import 'package:flutter/foundation.dart';

import '../../../domain/sync_status/sync_status_snapshot.dart';

class HomeHostServices {
  final Listenable changeSignal;
  final Future<SyncStatusSnapshot> Function() syncStatusSnapshot;
  final Future<void> Function() switchToSelfSubject;

  const HomeHostServices({
    required this.changeSignal,
    required this.syncStatusSnapshot,
    required this.switchToSelfSubject,
  });
}
