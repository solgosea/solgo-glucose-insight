import '../../../domain/sync_target/glucose_sync_target_owner.dart';
import '../glucose_sync_task.dart';
import '../limiters/glucose_sync_host_key.dart';

class GlucoseSyncFairTargetSelector {
  const GlucoseSyncFairTargetSelector();

  List<GlucoseSyncTask> order(List<GlucoseSyncTask> tasks) {
    if (tasks.length <= 2) return tasks;

    final remaining = List<GlucoseSyncTask>.of(tasks);
    final selected = <GlucoseSyncTask>[];
    final ownerCounts = <GlucoseSyncTargetOwner, int>{};
    final hostCounts = <GlucoseSyncHostKey, int>{};

    while (remaining.isNotEmpty) {
      remaining.sort((a, b) {
        final aOwner = ownerCounts[a.target.owner] ?? 0;
        final bOwner = ownerCounts[b.target.owner] ?? 0;
        if (aOwner != bOwner) return aOwner.compareTo(bOwner);

        final aHost = hostCounts[GlucoseSyncHostKey.fromTarget(a.target)] ?? 0;
        final bHost = hostCounts[GlucoseSyncHostKey.fromTarget(b.target)] ?? 0;
        if (aHost != bHost) return aHost.compareTo(bHost);

        final priority = b.priority.weight.compareTo(a.priority.weight);
        if (priority != 0) return priority;
        final due = a.dueAt.compareTo(b.dueAt);
        if (due != 0) return due;
        return a.sequence.compareTo(b.sequence);
      });

      final next = remaining.removeAt(0);
      selected.add(next);
      ownerCounts[next.target.owner] =
          (ownerCounts[next.target.owner] ?? 0) + 1;
      final host = GlucoseSyncHostKey.fromTarget(next.target);
      hostCounts[host] = (hostCounts[host] ?? 0) + 1;
    }

    return selected;
  }
}
