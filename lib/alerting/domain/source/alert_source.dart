import 'alert_source_id.dart';
import 'alert_source_sink.dart';

abstract interface class AlertSource {
  AlertSourceId get sourceId;

  Future<void> start(AlertSourceSink sink);

  Future<void> stop();
}
