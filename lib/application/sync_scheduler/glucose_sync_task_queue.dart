import 'glucose_sync_task.dart';

class GlucoseSyncTaskQueue {
  final List<GlucoseSyncTask> _tasks = <GlucoseSyncTask>[];

  void add(GlucoseSyncTask task) {
    final existingIndex = _tasks.indexWhere(
      (candidate) => candidate.target.targetId == task.target.targetId,
    );
    if (existingIndex >= 0) {
      final existing = _tasks[existingIndex];
      if (existing.priority.weight > task.priority.weight ||
          (existing.priority.weight == task.priority.weight &&
              !existing.dueAt.isAfter(task.dueAt))) {
        return;
      }
      _tasks.removeAt(existingIndex);
    }
    _tasks.add(task);
  }

  bool get isEmpty => _tasks.isEmpty;

  int get length => _tasks.length;

  GlucoseSyncTask? nextDue(DateTime now) {
    final due = _tasks
        .where((task) => !task.dueAt.isAfter(now))
        .toList(growable: false);
    if (due.isEmpty) return null;
    due.sort((a, b) {
      final priority = b.priority.weight.compareTo(a.priority.weight);
      if (priority != 0) return priority;
      final dueOrder = a.dueAt.compareTo(b.dueAt);
      if (dueOrder != 0) return dueOrder;
      final ownerOrder = a.target.owner.index.compareTo(b.target.owner.index);
      if (ownerOrder != 0) return ownerOrder;
      return a.sequence.compareTo(b.sequence);
    });
    final task = due.first;
    _tasks.remove(task);
    return task;
  }

  List<GlucoseSyncTask> dueBatch(DateTime now, {required int limit}) {
    if (limit <= 0) return const [];
    final due = _tasks
        .where((task) => !task.dueAt.isAfter(now))
        .toList(growable: false);
    if (due.isEmpty) return const [];
    due.sort(_compare);
    final selected = due.take(limit).toList(growable: false);
    for (final task in selected) {
      _tasks.remove(task);
    }
    return selected;
  }

  int _compare(GlucoseSyncTask a, GlucoseSyncTask b) {
    final priority = b.priority.weight.compareTo(a.priority.weight);
    if (priority != 0) return priority;
    final dueOrder = a.dueAt.compareTo(b.dueAt);
    if (dueOrder != 0) return dueOrder;
    final ownerOrder = a.target.owner.index.compareTo(b.target.owner.index);
    if (ownerOrder != 0) return ownerOrder;
    return a.sequence.compareTo(b.sequence);
  }
}
