import 'dart:async';

import '../../domain/component_health.dart';
import '../../domain/history/status_component_history_load_result.dart';
import '../../domain/history/status_component_history_load_state.dart';
import '../../domain/status_report.dart';
import 'status_history_service.dart';

class StatusHistoryParallelLoader {
  final StatusHistoryService historyService;
  final int maxConcurrent;

  const StatusHistoryParallelLoader({
    required this.historyService,
    this.maxConcurrent = 3,
  });

  Stream<StatusComponentHistoryLoadResult> load({
    required StatusReport report,
    required List<ComponentHealth> components,
    required DateTime now,
  }) async* {
    final pending = components.toList();
    final running = <int, Future<_LoadEntry>>{};
    var nextId = 0;

    void startNext() {
      while (pending.isNotEmpty && running.length < maxConcurrent) {
        final component = pending.removeAt(0);
        final id = nextId++;
        running[id] = _loadOne(
          report: report,
          component: component,
          now: now,
        ).then((result) => _LoadEntry(id: id, result: result));
      }
    }

    startNext();
    while (running.isNotEmpty) {
      final entry = await Future.any(running.values);
      running.remove(entry.id);
      yield entry.result;
      startNext();
    }
  }

  Future<StatusComponentHistoryLoadResult> _loadOne({
    required StatusReport report,
    required ComponentHealth component,
    required DateTime now,
  }) async {
    try {
      final result = await historyService.loadComponentForReport(
        report: report,
        component: component,
        now: now,
      );
      return StatusComponentHistoryLoadResult(
        component: component,
        state: result.coverage <= 0
            ? StatusComponentHistoryLoadState.empty
            : StatusComponentHistoryLoadState.ready,
        result: result,
      );
    } catch (error) {
      return StatusComponentHistoryLoadResult(
        component: component,
        state: StatusComponentHistoryLoadState.failed,
        error: error,
      );
    }
  }
}

class _LoadEntry {
  final int id;
  final StatusComponentHistoryLoadResult result;

  const _LoadEntry({
    required this.id,
    required this.result,
  });
}
