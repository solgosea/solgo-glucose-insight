import 'analysis_subject.dart';

class ActiveSubjectSnapshot {
  final AnalysisSubject subject;

  const ActiveSubjectSnapshot({required this.subject});

  String get id => subject.id;
  String get displayName => subject.displayName;
  String get sourceLabel => subject.sourceLabel;
  bool get isSelf => subject.isSelf;
}
