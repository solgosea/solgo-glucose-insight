import '../../domain/widget/status_widget_snapshot.dart';

class StatusMonitorAndroidWidgetPayloadMapper {
  const StatusMonitorAndroidWidgetPayloadMapper();

  Map<String, Object?> platformPayload(StatusWidgetSnapshot snapshot) {
    return snapshot.toMap();
  }
}
