import 'package:flutter/foundation.dart';

import '../domain/status_report.dart';

class StatusMonitorRuntimeCache extends ChangeNotifier {
  final Map<String, StatusReport> _reports = {};
  String? _activeSubjectId;
  Object? _error;
  bool _loading = false;

  StatusReport? get report {
    final subjectId = _activeSubjectId;
    if (subjectId == null) return null;
    return _reports[subjectId];
  }

  StatusReport? reportFor(String subjectId) => _reports[subjectId];

  String? get activeSubjectId => _activeSubjectId;
  Object? get error => _error;
  bool get loading => _loading;

  void markLoading({required String subjectId}) {
    _activeSubjectId = subjectId;
    _loading = true;
    _error = null;
    notifyListeners();
  }

  void update(StatusReport report) {
    _activeSubjectId = report.subjectId;
    _reports[report.subjectId] = report;
    _error = null;
    _loading = false;
    notifyListeners();
  }

  void markError(Object error) {
    _error = error;
    _loading = false;
    notifyListeners();
  }
}
