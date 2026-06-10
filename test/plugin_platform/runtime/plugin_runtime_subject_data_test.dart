import 'package:flutter_test/flutter_test.dart';
import 'package:smart_xdrip/plugin_platform/runtime/events/plugin_runtime_event.dart';
import 'package:smart_xdrip/plugin_platform/runtime/events/plugin_runtime_event_type.dart';
import 'package:smart_xdrip/plugin_platform/runtime/events/plugin_runtime_subject_data.dart';

void main() {
  test('subject data helper reads payload subject ids', () {
    final event = PluginRuntimeEvent(
      type: PluginRuntimeEventType.subjectDataChanged,
      occurredAt: DateTime(2026, 6, 9, 12),
      payload: PluginRuntimeSubjectData.payload(
        subjectIds: const {'self', 'child-a'},
        activeSubjectId: 'child-a',
        trigger: 'test',
      ),
    );

    expect(PluginRuntimeSubjectData.subjectIdsOf(event), {'self', 'child-a'});
    expect(PluginRuntimeSubjectData.affects(event, 'child-a'), isTrue);
    expect(PluginRuntimeSubjectData.affects(event, 'child-b'), isFalse);
  });

  test('empty subject payload is treated as broad refresh', () {
    final event = PluginRuntimeEvent(
      type: PluginRuntimeEventType.subjectDataChanged,
      occurredAt: DateTime(2026, 6, 9, 12),
    );

    expect(PluginRuntimeSubjectData.subjectIdsOf(event), isEmpty);
    expect(PluginRuntimeSubjectData.affects(event, 'self'), isTrue);
  });
}
