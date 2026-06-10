import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_xdrip/application/subject/active_subject_defaults.dart';
import 'package:smart_xdrip/application/subject/active_subject_store.dart';
import 'package:smart_xdrip/domain/subject/analysis_subject.dart';
import 'package:smart_xdrip/domain/subject/analysis_subject_origin.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  test('persists and restores an external active subject', () async {
    final store = ActiveSubjectStore();
    const child = AnalysisSubject(
      id: 'external:child_1',
      displayName: 'Xiao Ming',
      sourceLabel: 'External Nightscout',
      origin: AnalysisSubjectOrigin('external'),
    );

    await store.set(child);

    final restoredStore = ActiveSubjectStore();
    final restored = await restoredStore.restore();

    expect(restored.id, child.id);
    expect(restored.displayName, child.displayName);
    expect(restored.sourceLabel, child.sourceLabel);
    expect(restored.origin, child.origin);
    expect(restoredStore.current.id, child.id);
  });

  test('restores self after reset', () async {
    final store = ActiveSubjectStore();
    await store.set(
      const AnalysisSubject(
        id: 'external:child_2',
        displayName: 'Child',
        sourceLabel: 'External Nightscout',
        origin: AnalysisSubjectOrigin('external'),
      ),
    );

    await store.reset();

    final restoredStore = ActiveSubjectStore();
    final restored = await restoredStore.restore();

    expect(restored.id, ActiveSubjectDefaults.self.id);
    expect(restored.displayName, ActiveSubjectDefaults.self.displayName);
    expect(restored.origin, ActiveSubjectDefaults.self.origin);
  });
}
