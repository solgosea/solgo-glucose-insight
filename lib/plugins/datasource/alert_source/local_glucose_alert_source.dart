import 'dart:ui';

import 'package:smart_xdrip/alerting/application/dedupe/alert_source_priority.dart';
import 'package:smart_xdrip/alerting/application/event/alert_event_factory.dart';
import 'package:smart_xdrip/alerting/application/event/alert_event_payload_codec.dart';
import 'package:smart_xdrip/alerting/application/event/alert_event_queue_message_types.dart';
import 'package:smart_xdrip/alerting/application/nightscout/nightscout_alert_dedupe_key_builder.dart';
import 'package:smart_xdrip/alerting/application/rule/alert_rule_engine.dart';
import 'package:smart_xdrip/alerting/application/rule/alert_rule_provider.dart';
import 'package:smart_xdrip/alerting/application/text/alert_text_render_context.dart';
import 'package:smart_xdrip/alerting/application/text/alert_text_renderer_registry.dart';
import 'package:smart_xdrip/alerting/application/text/core_alert_text_renderer_registrar.dart';
import 'package:smart_xdrip/alerting/domain/event/alert_event.dart';
import 'package:smart_xdrip/alerting/domain/event/alert_event_source.dart';
import 'package:smart_xdrip/alerting/domain/event/alert_level.dart';
import 'package:smart_xdrip/alerting/domain/queue/alert_queue_priority.dart';
import 'package:smart_xdrip/alerting/domain/rule/alert_rule.dart';
import 'package:smart_xdrip/alerting/domain/rule/alert_rule_evaluation_result.dart';
import 'package:smart_xdrip/alerting/domain/source/alert_input.dart';
import 'package:smart_xdrip/alerting/domain/source/alert_input_origin.dart';
import 'package:smart_xdrip/alerting/domain/source/alert_source.dart';
import 'package:smart_xdrip/alerting/domain/source/alert_source_id.dart';
import 'package:smart_xdrip/alerting/domain/source/alert_source_sink.dart';
import 'package:smart_xdrip/data/local/glucose_database.dart';
import 'package:smart_xdrip/domain/entities/app_settings.dart';
import 'package:smart_xdrip/domain/entities/glucose_reading.dart';
import 'package:smart_xdrip/domain/subject/glucose_subject.dart';

import 'local_alert_source_eligibility_policy.dart';

class LocalGlucoseAlertSource implements AlertSource {
  static const id = AlertSourceId('datasource.local_analysis');

  final GlucoseDatabase database;
  final AppSettings Function() settingsProvider;
  final String Function() subjectIdProvider;
  final AlertRuleProvider ruleProvider;
  final AlertEventFactory eventFactory;
  final AlertRuleEngine ruleEngine;
  final NightscoutAlertDedupeKeyBuilder nightscoutDedupeKeyBuilder;
  final AlertEventPayloadCodec codec;
  final LocalAlertSourceEligibilityPolicy eligibilityPolicy;
  final DateTime Function() clock;
  final Locale? Function()? localeProvider;

  AlertSourceSink? _sink;

  LocalGlucoseAlertSource({
    required this.database,
    required this.settingsProvider,
    required this.subjectIdProvider,
    required this.ruleProvider,
    AlertEventFactory? eventFactory,
    this.ruleEngine = const AlertRuleEngine(),
    this.nightscoutDedupeKeyBuilder = const NightscoutAlertDedupeKeyBuilder(),
    this.codec = const AlertEventPayloadCodec(),
    this.eligibilityPolicy = const LocalAlertSourceEligibilityPolicy(),
    this.localeProvider,
    DateTime Function()? clock,
  })  : eventFactory = eventFactory ?? _defaultEventFactory(),
        clock = clock ?? DateTime.now;

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
      settings: settings,
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
    required AppSettings settings,
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
      settings: settings,
    );
  }

  AlertEvent _event({
    required String subjectId,
    required AlertRuleEvaluationResult result,
    required AlertEventSource source,
    required String trigger,
    required DateTime now,
    required AppSettings settings,
  }) {
    return eventFactory.createFromRuleResult(
      subjectId: subjectId,
      result: result,
      source: source,
      trigger: trigger,
      receivedAt: now,
      textContext: AlertTextRenderContext(
        unit: settings.unit,
        source: source,
        locale: localeProvider?.call(),
      ),
    );
  }

  AlertInput _inputFor(AlertEvent event, AppSettings settings) {
    final alertType = event.payload['type']?.toString();
    final dedupeKey = nightscoutDedupeKeyBuilder.build(
      url: settings.nightscoutBaseUrl,
      alertType: alertType,
      occurredAt: event.occurredAt,
    );
    final canonicalSourceKey = nightscoutDedupeKeyBuilder
        .canonicalSourceKey(settings.nightscoutBaseUrl);
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

  static AlertEventFactory _defaultEventFactory() {
    final registry = AlertTextRendererRegistry();
    const CoreAlertTextRendererRegistrar().register(registry);
    return AlertEventFactory(textRegistry: registry);
  }
}
