import 'package:flutter/foundation.dart';

import '../application/checking/models/status_check_session_state.dart';
import '../domain/status_report.dart';

class StatusMonitorRuntimeCache extends ChangeNotifier {
  final Map<String, StatusReport> _reports = {};
  String? _activeSubjectId;
  Object? _error;
  bool _loading = false;
  StatusCheckSessionState? _sessionState;

  StatusReport? get report {
    final subjectId = _activeSubjectId;
    if (subjectId == null) return null;
    return _reports[subjectId];
  }

  StatusReport? reportFor(String subjectId) => _reports[subjectId];

  String? get activeSubjectId => _activeSubjectId;
  Object? get error => _error;
  bool get loading => _loading;
  StatusCheckSessionState? get sessionState => _sessionState;

  void markLoading({required String subjectId}) {
    _activeSubjectId = subjectId;
    _loading = true;
    _error = null;
    _sessionState = null;
    notifyListeners();
  }

  void updateSession(StatusCheckSessionState state) {
    _activeSubjectId = state.subjectId;
    _sessionState = state;
    _loading = true;
    _error = null;
    notifyListeners();
  }

  void update(StatusReport report) {
    _activeSubjectId = report.subjectId;
    _reports[report.subjectId] = report;
    _error = null;
    _loading = false;
    _sessionState = null;
    notifyListeners();
  }

  void markError(Object error) {
    _error = error;
    _loading = false;
    notifyListeners();
  }
}
