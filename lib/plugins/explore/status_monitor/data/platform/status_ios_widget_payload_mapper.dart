import '../../domain/widget/status_widget_snapshot.dart';
import 'status_ios_widget_payload_keys.dart';

class StatusIosWidgetPayloadMapper {
  const StatusIosWidgetPayloadMapper();

  Map<String, Object?> sharedPayload(StatusWidgetSnapshot snapshot) {
    final map = snapshot.toMap();
    return {
      StatusIosWidgetPayloadKeys.subjectId:
          map[StatusIosWidgetPayloadKeys.subjectId],
      StatusIosWidgetPayloadKeys.template:
          map[StatusIosWidgetPayloadKeys.template],
      StatusIosWidgetPayloadKeys.headline:
          map[StatusIosWidgetPayloadKeys.headline],
      StatusIosWidgetPayloadKeys.summary:
          map[StatusIosWidgetPayloadKeys.summary],
      StatusIosWidgetPayloadKeys.sourceLabel:
          map[StatusIosWidgetPayloadKeys.sourceLabel],
      StatusIosWidgetPayloadKeys.updatedLabel:
          map[StatusIosWidgetPayloadKeys.updatedLabel],
      StatusIosWidgetPayloadKeys.freshnessLabel:
          map[StatusIosWidgetPayloadKeys.freshnessLabel],
      StatusIosWidgetPayloadKeys.notificationText:
          map[StatusIosWidgetPayloadKeys.notificationText],
      StatusIosWidgetPayloadKeys.lockScreenText:
          map[StatusIosWidgetPayloadKeys.lockScreenText],
      StatusIosWidgetPayloadKeys.primaryIssueLabel:
          map[StatusIosWidgetPayloadKeys.primaryIssueLabel],
      StatusIosWidgetPayloadKeys.level: map[StatusIosWidgetPayloadKeys.level],
      StatusIosWidgetPayloadKeys.score: map[StatusIosWidgetPayloadKeys.score],
      StatusIosWidgetPayloadKeys.scoreLabel:
          map[StatusIosWidgetPayloadKeys.scoreLabel],
      StatusIosWidgetPayloadKeys.hasConfiguredSource:
          map[StatusIosWidgetPayloadKeys.hasConfiguredSource],
      StatusIosWidgetPayloadKeys.isStale:
          map[StatusIosWidgetPayloadKeys.isStale],
      StatusIosWidgetPayloadKeys.privateMode:
          map[StatusIosWidgetPayloadKeys.privateMode],
      StatusIosWidgetPayloadKeys.sensorToUploader:
          map[StatusIosWidgetPayloadKeys.sensorToUploader],
      StatusIosWidgetPayloadKeys.uploaderToServer:
          map[StatusIosWidgetPayloadKeys.uploaderToServer],
      StatusIosWidgetPayloadKeys.components:
          map[StatusIosWidgetPayloadKeys.components],
    };
  }
}
