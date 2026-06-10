import '../channel/alert_channel.dart';
import '../event/alert_category.dart';
import '../event/alert_level.dart';
import '../sound/alert_sound_playback_policy.dart';
import 'alert_rule_comparator.dart';

class AlertRule {
  final String id;
  final String ruleSetId;
  final AlertCategory category;
  final bool enabled;
  final AlertRuleComparator comparator;
  final double? thresholdValue;
  final String? thresholdUnit;
  final AlertLevel level;
  final Set<AlertChannel> channels;
  final AlertSoundPlaybackPolicy? soundPolicy;
  final int repeatMinutes;
  final int priority;
  final Map<String, Object?> metadata;
  final DateTime createdAt;
  final DateTime updatedAt;

  const AlertRule({
    required this.id,
    required this.ruleSetId,
    required this.category,
    required this.enabled,
    required this.comparator,
    this.thresholdValue,
    this.thresholdUnit,
    required this.level,
    required this.channels,
    this.soundPolicy,
    required this.repeatMinutes,
    required this.priority,
    this.metadata = const {},
    required this.createdAt,
    required this.updatedAt,
  });
}
