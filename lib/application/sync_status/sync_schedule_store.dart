import 'package:flutter/foundation.dart';

import '../../domain/sync_status/sync_schedule_snapshot.dart';

class SyncScheduleStore extends ChangeNotifier {
  SyncScheduleSnapshot _snapshot = const SyncScheduleSnapshot.unknown();

  SyncScheduleSnapshot get snapshot => _snapshot;

  void update(SyncScheduleSnapshot next) {
    _snapshot = next;
    notifyListeners();
  }

  void clear() {
    update(const SyncScheduleSnapshot.unknown());
  }
}
