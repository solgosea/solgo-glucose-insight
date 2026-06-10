import 'package:flutter_test/flutter_test.dart';
import 'package:smart_xdrip/alerting/application/delivery/alert_delivery_gate.dart';
import 'package:smart_xdrip/alerting/application/delivery/alert_delivery_pipeline.dart';
import 'package:smart_xdrip/alerting/application/delivery/alert_strategy_registry.dart';
import 'package:smart_xdrip/alerting/application/ingress/alerting_center.dart';
import 'package:smart_xdrip/alerting/application/policy/alert_policy_engine.dart';
import 'package:smart_xdrip/alerting/domain/channel/alert_channel.dart';
import 'package:smart_xdrip/alerting/domain/channel/alert_delivery_plan.dart';
import 'package:smart_xdrip/alerting/domain/channel/alert_delivery_result.dart';
import 'package:smart_xdrip/alerting/domain/config/alert_strategy_config.dart';
import 'package:smart_xdrip/alerting/domain/event/alert_category.dart';
import 'package:smart_xdrip/alerting/domain/event/alert_event.dart';
import 'package:smart_xdrip/alerting/domain/event/alert_event_source.dart';
import 'package:smart_xdrip/alerting/domain/event/alert_event_state.dart';
import 'package:smart_xdrip/alerting/domain/event/alert_level.dart';
import 'package:smart_xdrip/alerting/domain/repository/alert_delivery_log_repository.dart';
import 'package:smart_xdrip/alerting/domain/repository/alert_event_repository.dart';
import 'package:smart_xdrip/alerting/domain/repository/alert_strategy_config_repository.dart';
import 'package:smart_xdrip/alerting/suppression/alert_suppression_decision.dart';
import 'package:smart_xdrip/alerting/suppression/alert_suppression_policy.dart';
import 'package:smart_xdrip/alerting/suppression/alert_suppression_policy_registry.dart';

void main() {
  test(
    'AlertingCenter suppresses delivery before loading config or pipeline',
    () async {
      final events = _MemoryAlertEventRepository();
      final suppression =
          AlertSuppressionPolicyRegistry()
            ..register(const _AlwaysSuppressPolicy());
      final center = AlertingCenter(
        eventRepository: events,
        configRepository: _FailingConfigRepository(),
        policyEngine: const AlertPolicyEngine(),
        deliveryGate: AlertDeliveryGate(suppressionRegistry: suppression),
        deliveryPipeline: AlertDeliveryPipeline(
          registry: AlertStrategyRegistry(const []),
          logRepository: _FailingDeliveryLogRepository(),
        ),
      );

      final results = await center.ingest(_event());

      expect(results.single.skipped, isTrue);
      expect((await events.byId('alert-1'))!.state, AlertEventState.suppressed);
    },
  );
}

AlertEvent _event() {
  final now = DateTime(2026, 6, 8, 10);
  return AlertEvent(
    id: 'alert-1',
    source: const AlertEventSource('test'),
    sourceEventId: 'source-alert-1',
    category: AlertCategory.glucoseUrgentLow,
    level: AlertLevel.critical,
    state: AlertEventState.received,
    title: 'Urgent Low',
    body: 'Urgent low glucose',
    payload: const {'personId': 'child-1', 'type': 'urgentLow'},
    occurredAt: now,
    receivedAt: now,
    updatedAt: now,
  );
}

class _AlwaysSuppressPolicy implements AlertSuppressionPolicy {
  const _AlwaysSuppressPolicy();

  @override
  String get id => 'test.suppress';

  @override
  Future<AlertSuppressionDecision> evaluate(AlertEvent event) async {
    return const AlertSuppressionDecision.suppressed('test');
  }
}

class _MemoryAlertEventRepository implements AlertEventRepository {
  final Map<String, AlertEvent> _events = {};

  @override
  Future<void> upsert(AlertEvent event) async {
    _events[event.id] = event;
  }

  @override
  Future<AlertEvent?> byId(String id) async => _events[id];

  @override
  Future<List<AlertEvent>> latest({int limit = 50}) async =>
      _events.values.take(limit).toList(growable: false);

  @override
  Future<void> updateState(String id, AlertEventState state) async {
    final event = _events[id];
    if (event != null) {
      _events[id] = event.copyWith(state: state);
    }
  }
}

class _FailingConfigRepository implements AlertStrategyConfigRepository {
  @override
  Future<AlertStrategyConfigSet> load() {
    throw StateError('Config should not be loaded for suppressed alerts.');
  }

  @override
  Future<void> save(AlertStrategyConfig config) async {}

  @override
  Future<void> saveGlobal(config) async {}
}

class _FailingDeliveryLogRepository implements AlertDeliveryLogRepository {
  @override
  Future<void> insertPlan(AlertDeliveryPlan plan) {
    throw StateError('Pipeline should not run for suppressed alerts.');
  }

  @override
  Future<void> insertResult({
    required String alertEventId,
    required String? planId,
    required String strategyKey,
    required AlertDeliveryResult result,
  }) async {}

  @override
  Future<void> insertSkipped({
    required String alertEventId,
    required String? planId,
    required String strategyKey,
    required AlertChannel channel,
    required String message,
  }) async {}

  @override
  Future<List<Map<String, Object?>>> latestForEvent(
    String alertEventId,
  ) async => const [];
}
