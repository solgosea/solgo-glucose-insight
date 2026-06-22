import '../status_level.dart';
import 'status_widget_connection_state.dart';
import 'status_widget_template.dart';

class StatusWidgetComponentSnapshot {
  final String title;
  final String levelLabel;
  final StatusLevel level;
  final String detail;
  final int? score;
  final String scoreLabel;

  const StatusWidgetComponentSnapshot({
    required this.title,
    required this.levelLabel,
    required this.level,
    required this.detail,
    required this.score,
    required this.scoreLabel,
  });

  Map<String, Object?> toMap() => {
        'title': title,
        'levelLabel': levelLabel,
        'level': level.name,
        'detail': detail,
        'score': score,
        'scoreLabel': scoreLabel,
      };
}

class StatusWidgetSnapshot {
  final String subjectId;
  final StatusWidgetTemplate template;
  final String headline;
  final String summary;
  final String sourceLabel;
  final String updatedLabel;
  final String freshnessLabel;
  final String notificationText;
  final String lockScreenText;
  final String primaryIssueLabel;
  final StatusLevel level;
  final int? score;
  final String scoreLabel;
  final bool hasConfiguredSource;
  final bool isStale;
  final bool privateMode;
  final List<StatusWidgetComponentSnapshot> components;
  final StatusWidgetConnectionState sensorToUploader;
  final StatusWidgetConnectionState uploaderToServer;

  const StatusWidgetSnapshot({
    required this.subjectId,
    required this.template,
    required this.headline,
    required this.summary,
    required this.sourceLabel,
    required this.updatedLabel,
    required this.freshnessLabel,
    required this.notificationText,
    required this.lockScreenText,
    required this.primaryIssueLabel,
    required this.level,
    required this.score,
    required this.scoreLabel,
    required this.hasConfiguredSource,
    required this.isStale,
    required this.privateMode,
    required this.components,
    required this.sensorToUploader,
    required this.uploaderToServer,
  });

  Map<String, Object?> toMap() => {
        'subjectId': subjectId,
        'template': template.code,
        'headline': privateMode ? 'Status available' : headline,
        'summary': privateMode ? 'Open SolgoInsight to view details' : summary,
        'sourceLabel': sourceLabel,
        'updatedLabel': updatedLabel,
        'freshnessLabel': freshnessLabel,
        'notificationText': privateMode ? 'Status available' : notificationText,
        'lockScreenText': privateMode ? 'Status available' : lockScreenText,
        'primaryIssueLabel': primaryIssueLabel,
        'level': level.name,
        'score': score,
        'scoreLabel': privateMode ? '--' : scoreLabel,
        'hasConfiguredSource': hasConfiguredSource,
        'isStale': isStale,
        'privateMode': privateMode,
        'sensorToUploader': sensorToUploader.code,
        'uploaderToServer': uploaderToServer.code,
        'components': components.map((component) => component.toMap()).toList(),
      };
}
