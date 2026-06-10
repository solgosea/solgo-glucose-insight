import '../event/alert_event.dart';
import '../event/alert_event_state.dart';

abstract class AlertEventRepository {
  Future<void> upsert(AlertEvent event);
  Future<AlertEvent?> byId(String id);
  Future<List<AlertEvent>> latest({int limit = 50});
  Future<void> updateState(String id, AlertEventState state);
}
