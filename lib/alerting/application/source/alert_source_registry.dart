import 'dart:async';

import '../../domain/source/alert_source.dart';
import '../../domain/source/alert_source_id.dart';
import '../../domain/source/alert_source_sink.dart';

class AlertSourceRegistry {
  final Map<AlertSourceId, AlertSource> _sources = {};
  final Set<AlertSourceId> _running = {};
  AlertSourceSink? _activeSink;

  List<AlertSource> get sources => List.unmodifiable(_sources.values);

  void register(AlertSource source) {
    _sources[source.sourceId] = source;
    final sink = _activeSink;
    if (sink != null && !_running.contains(source.sourceId)) {
      unawaited(start(source.sourceId, sink));
    }
  }

  Future<void> unregister(AlertSourceId sourceId) async {
    final source = _sources.remove(sourceId);
    if (source == null) return;
    if (_running.remove(sourceId)) {
      await source.stop();
    }
  }

  Future<void> start(AlertSourceId sourceId, AlertSourceSink sink) async {
    final source = _sources[sourceId];
    if (source == null || _running.contains(sourceId)) return;
    await source.start(sink);
    _running.add(sourceId);
  }

  Future<void> startAll(AlertSourceSink sink) async {
    _activeSink = sink;
    for (final source in _sources.values) {
      await start(source.sourceId, sink);
    }
  }

  Future<void> stop(AlertSourceId sourceId) async {
    final source = _sources[sourceId];
    if (source == null || !_running.remove(sourceId)) return;
    await source.stop();
  }

  Future<void> stopAll() async {
    _activeSink = null;
    final ids = List<AlertSourceId>.from(_running);
    for (final id in ids) {
      await stop(id);
    }
  }
}
