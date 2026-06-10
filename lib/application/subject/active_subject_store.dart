import '../../domain/subject/analysis_subject.dart';
import '../../domain/subject/analysis_subject_origin.dart';
import 'active_subject_defaults.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ActiveSubjectStore {
  static const _kId = 'active_subject_id';
  static const _kDisplayName = 'active_subject_display_name';
  static const _kSourceLabel = 'active_subject_source_label';
  static const _kOrigin = 'active_subject_origin';

  AnalysisSubject _current = ActiveSubjectDefaults.self;

  AnalysisSubject get current => _current;

  Future<AnalysisSubject> restore() async {
    final sp = await SharedPreferences.getInstance();
    final id = sp.getString(_kId)?.trim();
    if (id == null || id.isEmpty || id == ActiveSubjectDefaults.self.id) {
      _current = ActiveSubjectDefaults.self;
      return _current;
    }

    final origin = _originFromName(sp.getString(_kOrigin));
    _current = AnalysisSubject(
      id: id,
      displayName:
          sp.getString(_kDisplayName)?.trim().isNotEmpty == true
              ? sp.getString(_kDisplayName)!.trim()
              : id,
      sourceLabel:
          sp.getString(_kSourceLabel)?.trim().isNotEmpty == true
              ? sp.getString(_kSourceLabel)!.trim()
              : 'External source',
      origin: origin,
    );
    return _current;
  }

  Future<void> set(AnalysisSubject subject) async {
    _current = subject;
    final sp = await SharedPreferences.getInstance();
    await sp.setString(_kId, subject.id);
    await sp.setString(_kDisplayName, subject.displayName);
    await sp.setString(_kSourceLabel, subject.sourceLabel);
    await sp.setString(_kOrigin, subject.origin.name);
  }

  Future<void> reset() async {
    _current = ActiveSubjectDefaults.self;
    final sp = await SharedPreferences.getInstance();
    await sp.setString(_kId, ActiveSubjectDefaults.self.id);
    await sp.setString(_kDisplayName, ActiveSubjectDefaults.self.displayName);
    await sp.setString(_kSourceLabel, ActiveSubjectDefaults.self.sourceLabel);
    await sp.setString(_kOrigin, ActiveSubjectDefaults.self.origin.name);
  }

  AnalysisSubjectOrigin _originFromName(String? value) {
    return AnalysisSubjectOrigin.fromCode(value);
  }
}
