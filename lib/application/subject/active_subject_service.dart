import '../../domain/subject/active_subject_snapshot.dart';
import '../../domain/subject/analysis_subject.dart';
import 'active_subject_store.dart';

class ActiveSubjectService {
  final ActiveSubjectStore store;

  const ActiveSubjectService({required this.store});

  AnalysisSubject get current => store.current;

  ActiveSubjectSnapshot snapshot() =>
      ActiveSubjectSnapshot(subject: store.current);

  Future<void> restore() async {
    await store.restore();
  }

  Future<void> switchTo(AnalysisSubject subject) async {
    await store.set(subject);
  }

  Future<void> switchToSelf() async {
    await store.reset();
  }
}
