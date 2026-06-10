import 'alert_banner_action.dart';
import 'alert_banner_severity.dart';

class AlertBannerItem {
  final String id;
  final String title;
  final String message;
  final AlertBannerSeverity severity;
  final DateTime occurredAt;
  final DateTime? snoozedUntil;
  final String? countdownLabel;
  final List<AlertBannerAction> actions;
  final Map<String, Object?> metadata;

  const AlertBannerItem({
    required this.id,
    required this.title,
    required this.message,
    required this.severity,
    required this.occurredAt,
    this.snoozedUntil,
    this.countdownLabel,
    this.actions = const [],
    this.metadata = const {},
  });

  bool get snoozed => snoozedUntil != null;
}
