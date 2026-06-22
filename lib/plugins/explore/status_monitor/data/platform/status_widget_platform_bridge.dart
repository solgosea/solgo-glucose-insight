import '../../domain/widget/status_widget_snapshot.dart';

abstract class StatusWidgetPlatformBridge {
  bool get isSupported;

  Future<void> publish(StatusWidgetSnapshot snapshot);
}
