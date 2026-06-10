import 'package:flutter/foundation.dart';

import '../../domain/sync_status/sync_status_snapshot.dart';

class SyncStatusStore extends ChangeNotifier {
  SyncStatusSnapshot? _snapshot;

  SyncStatusSnapshot? get snapshot => _snapshot;

  void update(SyncStatusSnapshot next) {
    _snapshot = next;
    notifyListeners();
  }

  void clear() {
    _snapshot = null;
    notifyListeners();
  }
}
