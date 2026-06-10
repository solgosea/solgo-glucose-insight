import 'package:flutter/foundation.dart';

import 'explore_runtime_snapshot.dart';

class ExploreEntryStateStore extends ChangeNotifier {
  ExploreRuntimeSnapshot? _snapshot;

  ExploreRuntimeSnapshot? get snapshot => _snapshot;

  bool get hasSnapshot => _snapshot != null;

  void update(ExploreRuntimeSnapshot snapshot) {
    _snapshot = snapshot;
    notifyListeners();
  }
}
