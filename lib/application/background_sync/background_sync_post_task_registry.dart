import 'background_sync_post_task.dart';

class BackgroundSyncPostTaskRegistry {
  final List<BackgroundSyncPostTask> _tasks;

  BackgroundSyncPostTaskRegistry({
    Iterable<BackgroundSyncPostTask> tasks = const [],
  }) : _tasks = List.of(tasks);

  void register(BackgroundSyncPostTask task) {
    if (_tasks.contains(task)) return;
    _tasks.add(task);
  }

  List<BackgroundSyncPostTask> get tasks => List.unmodifiable(_tasks);
}
