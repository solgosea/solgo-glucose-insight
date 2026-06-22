import '../../domain/status_level.dart';
import '../../domain/widget/status_widget_connection_state.dart';

class StatusWidgetConnectionMapper {
  const StatusWidgetConnectionMapper();

  StatusWidgetConnectionState between(StatusLevel left, StatusLevel right) {
    if (left == StatusLevel.unknown || right == StatusLevel.unknown) {
      return StatusWidgetConnectionState.unknown;
    }
    if (left == StatusLevel.issue || right == StatusLevel.issue) {
      return StatusWidgetConnectionState.broken;
    }
    if (left == StatusLevel.watch || right == StatusLevel.watch) {
      return StatusWidgetConnectionState.watch;
    }
    return StatusWidgetConnectionState.healthy;
  }
}
