import 'alert_input.dart';

abstract interface class AlertSourceSink {
  Future<void> ingest(AlertInput input);
}
