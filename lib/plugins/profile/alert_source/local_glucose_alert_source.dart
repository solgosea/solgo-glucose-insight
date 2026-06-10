import '../../../alerting/application/event/alert_event_payload_codec.dart';
import '../../../alerting/application/event/alert_event_queue_message_types.dart';
import '../../../alerting/application/dedupe/alert_source_priority.dart';
import '../../../alerting/application/nightscout/nightscout_alert_dedupe_key_builder.dart';
import '../../../alerting/application/rule/alert_rule_engine.dart';
import '../../../alerting/application/rule/alert_rule_provider.dart';
import '../../../alerting/domain/event/alert_event.dart';
import '../../../alerting/domain/event/alert_event_source.dart';
import '../../../alerting/domain/event/alert_event_state.dart';
import '../../../alerting/domain/event/alert_level.dart';
import '../../../alerting/domain/queue/alert_queue_priority.dart';
import '../../../alerting/domain/rule/alert_rule.dart';
import '../../../alerting/domain/rule/alert_rule_evaluation_result.dart';
import '../../../alerting/domain/source/alert_input.dart';
import '../../../alerting/domain/source/alert_input_origin.dart';
import '../../../alerting/domain/source/alert_source.dart';
import '../../../alerting/domain/source/alert_source_id.dart';
import '../../../alerting/domain/source/alert_source_sink.dart';
import '../../../alerting/shared/alert_id_generator.dart';
import '../../../data/local/glucose_database.dart';
import '../../../domain/entities/app_settings.dart';
import '../../../domain/entities/glucose_reading.dart';
import '../../../domain/subject/glucose_subject.dart';
import 'local_alert_source_eligibility_policy.dart';

class LocalGlucoseAlertSource implements AlertSource {
  static const id = AlertSourceId('profile.datasource.local_analysis');

  final GlucoseDatabase database;
  final AppSettings Function() settingsProvider;
  final String Function() subjectIdProvider;
  final AlertRuleProvider ruleProvider;
  final AlertRuleEngine ruleEngine;
  final NightscoutAlertDedupeKeyBuilder nightscoutDedupeKeyBuilder;
  final AlertEventPayloadCodec codec;
  final AlertIdGenerator idGenerator;
  final LocalAlertSourceEligibilityPolicy eligibilityPolicy;
  final DateTime Function() clock;

  AlertSourceSink? _sink;

  LocalGlucoseAlertSource({
    required this.database,
    required this.settingsProvider,
    required this.subjectIdProvider,
    required this.ruleProvider,
    this.ruleEngine = const AlertRuleEngine(),
    this.nightscoutDedupeKeyBuilder = const NightscoutAlertDedupeKeyBuilder(),
    this.codec = const AlertEventPayloadCodec(),
    this.idGenerator = const AlertIdGenerator(),
    this.eligibilityPolicy = const LocalAlertSourceEligibilityPolicy(),
    DateTime Function()? clock,
  }) : clock = clock ?? DateTime.now;

  @override
  AlertSourceId get sourceId => id;

  @override
  Future<void> start(AlertSourceSink sink) async {
    _sink = sink;
  }

  @override
  Future<void> stop() async {
    _sink = null;
  }

  Future<void> evaluateCurrentSubject({String trigger = 'manual'}) async {
    final sink = _sink;
    if (sink == null) return;
    final subjectId = subjectIdProvider();
    final settings = settingsProvider();
    if (!eligibilityPolicy.canEvaluate(
      subjectId: subjectId,
      settings: settings,
    )) {
      return;
    }
    final now = clock();
    final readings = await database.range(
      now.subtract(const Duration(minutes: 45)),
      now,
      subjectId: subjectId,
    );
    final rules = await ruleProvider.selfDefaultRules(subjectId);
    final event = _buildEvent(
      readings: readings,
      rules: rules,
      subjectId: subjectId,
      source: settings.nightscoutBaseUrl == null
          ? AlertEventSource.xdripLocal
          : AlertEventSource.nightscout,
      trigger: trigger,
      now: now,
    );
    if (event == null) return;
    await sink.ingest(_inputFor(event, settings));
  }

  AlertEvent? _buildEvent({
    required List<GlucoseReading> readings,
    required List<AlertRule> rules,
    required String subjectId,
    required AlertEventSource source,
    required String trigger,
    required DateTime now,
  }) {
    final results = ruleEngine.evaluate(
      readings: readings,
      rules: rules.cast(),
      now: now,
    );
    if (results.isEmpty) return null;
    return _event(
      subjectId: subjectId,
      result: results.first,
      source: source,
      trigger: trigger,
      now: now,
    );
  }

  AlertEvent _event({
    required String subjectId,
    required AlertRuleEvaluationResult result,
    required AlertEventSource source,
    required String trigger,
    required DateTime now,
  }) {
    final sourceEventId =
        '$subjectId:${result.type}:${result.occurredAt.millisecondsSinceEpoch}';
    return AlertEvent(
      id: idGenerator.stableId('local_alert', sourceEventId),
      source: source,
      sourceEventId: sourceEventId,
      category: result.category,
      level: result.level,
      state: AlertEventState.received,
      title: result.title,
      body: result.body,
      payload: {
        'subjectId': subjectId,
        'type': result.type,
        'value': result.value,
        'trigger': trigger,
        'requestedChannels':
            result.rule.channels.map((channel) => channel.code).toList(),
        if (result.rule.soundPolicy != null)
          'soundPolicy': result.rule.soundPolicy!.toJson(),
      },
      occurredAt: result.occurredAt,
      receivedAt: now,
      updatedAt: now,
    );
  }

  AlertInput _inputFor(AlertEvent event, AppSettings settings) {
    final alertType = event.payload['type']?.toString();
    final dedupeKey = nightscoutDedupeKeyBuilder.build(
      url: settings.nightscoutBaseUrl,
      alertType: alertType,
      occurredAt: event.occurredAt,
    );
    final canonicalSourceKey = nightscoutDedupeKeyBuilder.canonicalSourceKey(
      settings.nightscoutBaseUrl,
    );
    return AlertInput(
      sourceId: sourceId,
      origin: AlertInputOrigin.localAnalysis,
      messageType: AlertEventQueueMessageTypes.directEvent,
      subjectId:
          event.payload['subjectId']?.toString() ?? GlucoseSubject.selfId,
      alertEventId: event.id,
      alertType: alertType,
      priority: event.level == AlertLevel.critical
          ? AlertQueuePriority.critical
          : AlertQueuePriority.high,
      payload: {'event': codec.encode(event)},
      dedupeKey: dedupeKey ?? 'local:${event.sourceEventId}',
      canonicalSourceKey: canonicalSourceKey,
      dedupeScope: canonicalSourceKey == null ? 'local' : 'nightscout',
      sourcePriority: AlertSourcePriority.localDatasource,
    );
  }
}
