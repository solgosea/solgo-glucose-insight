import 'plugin_runtime_event.dart';

class PluginRuntimeSubjectData {
  const PluginRuntimeSubjectData._();

  static const subjectIdsKey = 'subjectIds';
  static const activeSubjectIdKey = 'activeSubjectId';
  static const triggerKey = 'trigger';

  static Set<String> subjectIdsOf(PluginRuntimeEvent event) {
    final value = event.payload[subjectIdsKey];
    if (value is Iterable) {
      return value
          .whereType<Object>()
          .map((item) => item.toString().trim())
          .where((item) => item.isNotEmpty)
          .toSet();
    }
    final single = event.payload['subjectId'];
    if (single == null) return const {};
    final subjectId = single.toString().trim();
    return subjectId.isEmpty ? const {} : {subjectId};
  }

  static bool affects(PluginRuntimeEvent event, String subjectId) {
    final ids = subjectIdsOf(event);
    return ids.isEmpty || ids.contains(subjectId);
  }

  static Map<String, Object?> payload({
    required Iterable<String> subjectIds,
    required String trigger,
    String? activeSubjectId,
    Map<String, Object?> extra = const {},
  }) {
    final normalized = subjectIds
        .map((subjectId) => subjectId.trim())
        .where((subjectId) => subjectId.isNotEmpty)
        .toSet()
        .toList(growable: false);
    return {
      ...extra,
      subjectIdsKey: normalized,
      triggerKey: trigger,
      if (activeSubjectId != null) activeSubjectIdKey: activeSubjectId,
    };
  }
}
