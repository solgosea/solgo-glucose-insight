import '../../domain/channel/alert_channel.dart';
import '../../domain/event/alert_category.dart';
import '../../domain/event/alert_level.dart';
import '../../domain/rule/alert_rule.dart';
import '../../domain/rule/alert_rule_comparator.dart';
import '../../domain/rule/alert_rule_scope.dart';
import '../../domain/rule/alert_rule_set.dart';
import '../../domain/rule/glucose_alert_default_thresholds.dart';
import '../../domain/sound/alert_sound_loop_mode.dart';
import '../../domain/sound/alert_sound_playback_policy.dart';

class AlertRuleDefaults {
  static const selfDefaultRuleSetKey = 'self_default';

  const AlertRuleDefaults();

  AlertRuleSet selfDefaultRuleSet({
    required String subjectId,
    required DateTime now,
  }) {
    return AlertRuleSet(
      id: 'rule_set:$selfDefaultRuleSetKey:$subjectId',
      ruleSetKey: selfDefaultRuleSetKey,
      scope: AlertRuleScope.self,
      subjectId: subjectId,
      displayName: 'Self glucose alerts',
      enabled: true,
      createdAt: now,
      updatedAt: now,
    );
  }

  List<AlertRule> selfDefaultRules({
    required String ruleSetId,
    required DateTime now,
  }) {
    return [
      _rule(
        ruleSetId: ruleSetId,
        category: AlertCategory.glucoseUrgentLow,
        enabled: true,
        comparator: AlertRuleComparator.lessThan,
        thresholdValue: GlucoseAlertDefaultThresholds.urgentLowMmol,
        thresholdUnit: 'mmol/L',
        level: AlertLevel.critical,
        channels: const {
          AlertChannel.inApp,
          AlertChannel.localNotification,
          AlertChannel.vibration,
          AlertChannel.sound,
        },
        soundPolicy: const AlertSoundPlaybackPolicy(
          mode: AlertSoundLoopMode.continuous,
          repeatCount: 1,
          intervalSeconds: 2,
        ),
        repeatMinutes: 5,
        priority: 100,
        now: now,
      ),
      _rule(
        ruleSetId: ruleSetId,
        category: AlertCategory.glucoseLow,
        enabled: true,
        comparator: AlertRuleComparator.lessThan,
        thresholdValue: GlucoseAlertDefaultThresholds.lowMmol,
        thresholdUnit: 'mmol/L',
        level: AlertLevel.warning,
        channels: const {
          AlertChannel.inApp,
          AlertChannel.localNotification,
          AlertChannel.vibration,
        },
        repeatMinutes: 30,
        priority: 90,
        now: now,
      ),
      _rule(
        ruleSetId: ruleSetId,
        category: AlertCategory.glucoseHigh,
        enabled: true,
        comparator: AlertRuleComparator.greaterThan,
        thresholdValue: GlucoseAlertDefaultThresholds.highMmol,
        thresholdUnit: 'mmol/L',
        level: AlertLevel.warning,
        channels: const {
          AlertChannel.inApp,
          AlertChannel.localNotification,
          AlertChannel.vibration,
        },
        repeatMinutes: 30,
        priority: 70,
        now: now,
      ),
      _rule(
        ruleSetId: ruleSetId,
        category: AlertCategory.glucoseRapidFall,
        enabled: true,
        comparator: AlertRuleComparator.rateBelow,
        thresholdValue: GlucoseAlertDefaultThresholds.rapidFallRateMmolPerMin,
        thresholdUnit: 'mmol/L/min',
        level: AlertLevel.warning,
        channels: const {
          AlertChannel.inApp,
          AlertChannel.localNotification,
          AlertChannel.vibration,
        },
        repeatMinutes: 30,
        priority: 80,
        now: now,
      ),
      _rule(
        ruleSetId: ruleSetId,
        category: AlertCategory.noData,
        enabled: true,
        comparator: AlertRuleComparator.staleForMinutes,
        thresholdValue: GlucoseAlertDefaultThresholds.noDataMinutes,
        thresholdUnit: 'minutes',
        level: AlertLevel.info,
        channels: const {AlertChannel.inApp, AlertChannel.localNotification},
        repeatMinutes: 30,
        priority: 60,
        now: now,
      ),
    ];
  }

  AlertRule _rule({
    required String ruleSetId,
    required AlertCategory category,
    required bool enabled,
    required AlertRuleComparator comparator,
    required double thresholdValue,
    required String thresholdUnit,
    required AlertLevel level,
    required Set<AlertChannel> channels,
    AlertSoundPlaybackPolicy? soundPolicy,
    required int repeatMinutes,
    required int priority,
    required DateTime now,
  }) {
    return AlertRule(
      id: 'rule:$ruleSetId:${category.code}',
      ruleSetId: ruleSetId,
      category: category,
      enabled: enabled,
      comparator: comparator,
      thresholdValue: thresholdValue,
      thresholdUnit: thresholdUnit,
      level: level,
      channels: channels,
      soundPolicy: soundPolicy,
      repeatMinutes: repeatMinutes,
      priority: priority,
      createdAt: now,
      updatedAt: now,
    );
  }
}
