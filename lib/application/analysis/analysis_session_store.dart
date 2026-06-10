import 'analysis_refresh_result.dart';
import '../../domain/analysis/analysis_snapshot.dart';
import '../../domain/entities/app_settings.dart';
import '../../domain/insight/narrative_insight.dart';
import '../../domain/subject/analysis_subject.dart';
import '../subject/active_subject_defaults.dart';

class AnalysisSessionStore {
  static final AnalysisSessionStore instance = AnalysisSessionStore._();

  AnalysisSessionStore._();

  AnalysisSnapshot? _snapshot;
  List<NarrativeInsight> _insights = const [];
  AppSettings _settings = const AppSettings();
  AnalysisSubject _activeSubject = ActiveSubjectDefaults.self;

  AnalysisSnapshot? get snapshot => _snapshot;

  List<NarrativeInsight> get insights => List.unmodifiable(_insights);

  bool get hasSnapshot => _snapshot != null;

  AppSettings get settings => _settings;

  AnalysisSubject get activeSubject => _activeSubject;

  void update(
    AnalysisRefreshResult result, {
    AppSettings? settings,
    AnalysisSubject? subject,
  }) {
    _snapshot = result.snapshot;
    _insights = List.unmodifiable(result.insights);
    if (settings != null) _settings = settings;
    if (subject != null) _activeSubject = subject;
  }

  void updateSettings(AppSettings settings) {
    _settings = settings;
  }

  void setActiveSubject(AnalysisSubject subject) {
    _activeSubject = subject;
  }

  void clear() {
    _snapshot = null;
    _insights = const [];
  }
}
