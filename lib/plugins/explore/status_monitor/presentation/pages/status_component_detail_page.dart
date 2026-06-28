import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:smart_xdrip/plugin_platform/runtime/manager/plugin_runtime_manager.dart';
import 'package:smart_xdrip/plugin_platform/services/plugin_service_registry.dart';

import '../../domain/cgm_sensor/cgm_sensor_detail_data.dart';
import '../../domain/aaps/aaps_detail_data.dart';
import '../../domain/detail/status_signal_summary.dart';
import '../../domain/juggluco/juggluco_detail_data.dart';
import '../../domain/nightscout/nightscout_detail_data.dart';
import '../../domain/status_component_kind.dart';
import '../../domain/status_level.dart';
import '../../domain/watch/watch_detail_data.dart';
import '../../domain/xdrip/xdrip_detail_data.dart';
import '../../l10n/generated/status_monitor_localizations.dart';
import '../../runtime/status_monitor_runtime.dart';
import '../../runtime/status_monitor_runtime_cache.dart';
import '../../application/i18n/status_monitor_age_label_localizer.dart';
import '../../application/i18n/status_monitor_l10n.dart';
import '../aaps/widgets/aaps_detail_body.dart';
import '../cgm_sensor/widgets/cgm_sensor_detail_body.dart';
import '../controllers/status_component_detail_controller.dart';
import '../juggluco/widgets/juggluco_detail_body.dart';
import '../nightscout/widgets/nightscout_detail_body.dart';
import '../styles/status_monitor_theme.dart';
import '../widgets/status_direction_card.dart';
import '../widgets/detail/status_detail_shared_widgets.dart';
import '../widgets/status_metric_card.dart';
import '../widgets/status_monitor_page_header.dart';
import '../watch/widgets/watch_detail_body.dart';
import '../xdrip/widgets/xdrip_detail_body.dart';

class StatusComponentDetailPage extends StatefulWidget {
  final StatusComponentKind kind;

  const StatusComponentDetailPage({super.key, required this.kind});

  @override
  State<StatusComponentDetailPage> createState() =>
      _StatusComponentDetailPageState();
}

class _StatusComponentDetailPageState extends State<StatusComponentDetailPage> {
  StatusComponentDetailController? _controller;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_controller != null) return;
    final services = context.read<PluginServiceRegistry>();
    context.read<PluginRuntimeManager>().resume(StatusMonitorRuntime.id);
    _controller = StatusComponentDetailController(
      cache: services.get<StatusMonitorRuntimeCache>(),
      kind: widget.kind,
    );
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = _controller;
    return Scaffold(
      backgroundColor: StatusMonitorTheme.bg,
      body: DecoratedBox(
        decoration: StatusMonitorTheme.pageBackground(),
        child: SafeArea(
          child: controller == null
              ? const Center(
                  child: CircularProgressIndicator(
                    color: StatusMonitorTheme.green,
                  ),
                )
              : ListenableBuilder(
                  listenable: controller,
                  builder: (context, _) {
                    final vm = controller.viewModel;
                    if (controller.loading || vm == null) {
                      return const Center(
                        child: CircularProgressIndicator(
                          color: StatusMonitorTheme.green,
                        ),
                      );
                    }
                    final l10n = context.statusMonitorL10n;
                    final isJuggluco =
                        vm.component.kind == StatusComponentKind.juggluco;
                    final isWatch =
                        vm.component.kind == StatusComponentKind.watchDisplay;
                    return ListView(
                      padding: const EdgeInsets.only(bottom: 32),
                      children: [
                        StatusMonitorPageHeader(
                          eyebrow: l10n.pluginTitle,
                          title: _componentTitle(vm.component.kind, l10n),
                          subtitle: isJuggluco
                              ? null
                              : _modePill(vm.component.kind, l10n),
                          onBack: () => context.pop(),
                          compact: isJuggluco,
                          trailing: isJuggluco ? const _ModePill() : null,
                        ),
                        if (!isJuggluco && !isWatch)
                          _Hero(component: vm.component),
                        if (vm.component.kind ==
                            StatusComponentKind.cgmSensor) ...[
                          CgmSensorDetailBody(component: vm.component),
                        ] else if (vm.component.kind ==
                            StatusComponentKind.juggluco) ...[
                          JugglucoDetailBody(component: vm.component),
                        ] else if (vm.component.kind ==
                            StatusComponentKind.xdrip) ...[
                          XdripDetailBody(component: vm.component),
                        ] else if (vm.component.kind ==
                            StatusComponentKind.nightscout) ...[
                          NightscoutDetailBody(component: vm.component),
                        ] else if (vm.component.kind ==
                            StatusComponentKind.aapsLoop) ...[
                          AapsDetailBody(component: vm.component),
                        ] else if (vm.component.kind ==
                            StatusComponentKind.watchDisplay) ...[
                          WatchDetailBody(component: vm.component),
                        ] else ...[
                          _SectionLabel(l10n.pageCurrentReadings),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: GridView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: vm.metrics.length,
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 8,
                                mainAxisSpacing: 8,
                                childAspectRatio: 1.18,
                              ),
                              itemBuilder: (_, index) =>
                                  StatusMetricCard(metric: vm.metrics[index]),
                            ),
                          ),
                        ],
                        if (!isJuggluco && !isWatch) ...[
                          _SectionLabel(l10n.pagePossibleDirections),
                          StatusDirectionCard(
                            directions: vm.component.directions,
                          ),
                        ],
                        if (vm.component.kind == StatusComponentKind.aapsLoop)
                          const AapsSafetyNotice(),
                      ],
                    );
                  },
                ),
        ),
      ),
    );
  }

  String _modePill(
    StatusComponentKind kind,
    StatusMonitorLocalizations l10n,
  ) {
    return switch (kind) {
      StatusComponentKind.cgmSensor => l10n.pageModeReadingsQuality,
      StatusComponentKind.juggluco => 'Primary path',
      StatusComponentKind.xdrip => l10n.pageModeLocalService,
      StatusComponentKind.nightscout => l10n.pageModeNightscoutApi,
      StatusComponentKind.aapsLoop => l10n.pageModeNightscoutEvidence,
      StatusComponentKind.watchDisplay => 'Display bridge',
    };
  }

  String _componentTitle(
    StatusComponentKind kind,
    StatusMonitorLocalizations l10n,
  ) {
    return switch (kind) {
      StatusComponentKind.cgmSensor => l10n.pageComponentCgmSensor,
      StatusComponentKind.juggluco => 'Juggluco',
      StatusComponentKind.xdrip => l10n.pageComponentXdrip,
      StatusComponentKind.nightscout => l10n.pageComponentNightscout,
      StatusComponentKind.aapsLoop => l10n.pageComponentAapsLoop,
      StatusComponentKind.watchDisplay => 'Watch display',
    };
  }
}

class _ModePill extends StatelessWidget {
  const _ModePill();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 7),
      decoration: BoxDecoration(
        color: StatusMonitorTheme.teal.withOpacity(.09),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: StatusMonitorTheme.teal.withOpacity(.30)),
      ),
      child: Text(
        'PRIMARY PATH',
        style: StatusMonitorTheme.mono.copyWith(
          color: StatusMonitorTheme.teal,
          fontSize: 10,
          fontWeight: FontWeight.w900,
          letterSpacing: 1,
        ),
      ),
    );
  }
}

class _Hero extends StatelessWidget {
  static const _aapsViolet = Color(0xFF9D8CFF);

  final dynamic component;

  const _Hero({required this.component});

  @override
  Widget build(BuildContext context) {
    final l10n = context.statusMonitorL10n;
    final statusColor = StatusMonitorTheme.colorFor(component.level);
    final identityColor = component.kind == StatusComponentKind.aapsLoop
        ? _aapsViolet
        : statusColor;
    final score = component.score;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: identityColor.withOpacity(.27)),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            identityColor.withOpacity(.14),
            StatusMonitorTheme.teal.withOpacity(.07),
            Colors.white.withOpacity(.02),
          ],
        ),
        color: StatusMonitorTheme.card,
        boxShadow: const [
          BoxShadow(
            color: Color(0x3D000000),
            blurRadius: 42,
            offset: Offset(0, 16),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 46,
                      height: 46,
                      decoration: BoxDecoration(
                        color: identityColor.withOpacity(.10),
                        borderRadius: BorderRadius.circular(12),
                        border:
                            Border.all(color: identityColor.withOpacity(.30)),
                      ),
                      child: Icon(
                        _iconFor(component.kind),
                        color: identityColor,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _componentTitle(component.kind, l10n),
                            style: StatusMonitorTheme.inter.copyWith(
                              color: StatusMonitorTheme.text,
                              fontSize: 20,
                              height: 1.05,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            component.takeaway,
                            style: StatusMonitorTheme.inter.copyWith(
                              color: StatusMonitorTheme.soft,
                              fontSize: 12,
                              height: 1.45,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '${score?.value ?? 0}',
                    style: StatusMonitorTheme.mono.copyWith(
                      color: statusColor,
                      fontSize: 34,
                      height: 1,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    _statusLevelLabel(component.level, l10n).toUpperCase(),
                    style: StatusMonitorTheme.mono.copyWith(
                      color: StatusMonitorTheme.soft,
                      fontSize: 10,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1.2,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 15),
          LayoutBuilder(
            builder: (context, constraints) {
              final cards = [
                _SummaryCard(
                  value: _primarySummaryValue(component, l10n),
                  label: _primarySummaryLabel(component.kind, l10n),
                ),
                _SummaryCard(
                  value: score == null
                      ? l10n.pageChecksPassedShort(0, 0)
                      : l10n.pageChecksPassedShort(
                          score.availableSignals,
                          score.totalSignals,
                        ),
                  label: _confidenceSummaryLabel(component.kind, l10n),
                ),
              ];
              return Row(
                children: [
                  Expanded(child: cards[0]),
                  const SizedBox(width: 8),
                  Expanded(child: cards[1]),
                ],
              );
            },
          ),
          StatusSignalStripContent(signals: _signalsFor(component)),
        ],
      ),
    );
  }

  IconData _iconFor(StatusComponentKind kind) {
    return switch (kind) {
      StatusComponentKind.cgmSensor => Icons.sensors_rounded,
      StatusComponentKind.juggluco => Icons.sensors_rounded,
      StatusComponentKind.xdrip => Icons.phone_android_rounded,
      StatusComponentKind.nightscout => Icons.cloud_queue_rounded,
      StatusComponentKind.aapsLoop => Icons.all_inclusive_rounded,
      StatusComponentKind.watchDisplay => Icons.watch_rounded,
    };
  }

  String _primarySummaryValue(
    dynamic component,
    StatusMonitorLocalizations l10n,
  ) {
    if (component.kind == StatusComponentKind.xdrip) {
      return _ageValue(_signalValue(component, 'freshness'), l10n) ??
          component.summary;
    }
    if (component.kind == StatusComponentKind.nightscout) {
      return _ageValue(
            _signalValue(component, 'server_data_freshness'),
            l10n,
          ) ??
          component.summary;
    }
    if (component.kind == StatusComponentKind.cgmSensor) {
      return _ageValue(_signalValue(component, 'sensor_freshness'), l10n) ??
          component.summary;
    }
    if (component.kind == StatusComponentKind.aapsLoop) {
      return _ageValue(
            _signalValue(component, 'aaps_sync_freshness'),
            l10n,
          ) ??
          component.summary;
    }
    if (component.kind == StatusComponentKind.juggluco) {
      return _ageValue(
              _signalValue(component, 'juggluco_broadcast_freshness'), l10n) ??
          component.summary;
    }
    if (component.kind == StatusComponentKind.watchDisplay) {
      return _ageValue(
              _signalValue(component, 'watch.display.evidence'), l10n) ??
          component.summary;
    }
    return component.summary;
  }

  String _componentTitle(
    StatusComponentKind kind,
    StatusMonitorLocalizations l10n,
  ) {
    return switch (kind) {
      StatusComponentKind.cgmSensor => l10n.pageComponentCgmSensor,
      StatusComponentKind.juggluco => 'Juggluco',
      StatusComponentKind.xdrip => l10n.pageComponentXdrip,
      StatusComponentKind.nightscout => l10n.pageComponentNightscout,
      StatusComponentKind.aapsLoop => l10n.pageComponentAapsLoop,
      StatusComponentKind.watchDisplay => 'Watch display',
    };
  }

  String _primarySummaryLabel(
    StatusComponentKind kind,
    StatusMonitorLocalizations l10n,
  ) {
    return switch (kind) {
      StatusComponentKind.xdrip => l10n.metricLastReadingFreshness,
      StatusComponentKind.nightscout => l10n.metricLatestServerReading,
      StatusComponentKind.cgmSensor => l10n.pageLatestSensorReadingObserved,
      StatusComponentKind.juggluco => 'Latest Juggluco broadcast',
      StatusComponentKind.aapsLoop => l10n.metricLatestAapsContext,
      StatusComponentKind.watchDisplay => 'Latest watch evidence',
    };
  }

  String _confidenceSummaryLabel(
    StatusComponentKind kind,
    StatusMonitorLocalizations l10n,
  ) {
    return switch (kind) {
      StatusComponentKind.xdrip => l10n.pageConfidenceAvailableMetrics,
      StatusComponentKind.nightscout => l10n.pageConfidenceAvailableEndpoints,
      StatusComponentKind.cgmSensor => l10n.pageConfidenceAvailableContext,
      StatusComponentKind.juggluco => 'Primary path evidence',
      StatusComponentKind.aapsLoop => l10n.pageConfidenceNightscoutEvidence,
      StatusComponentKind.watchDisplay => 'Display evidence',
    };
  }

  String _statusLevelLabel(
    dynamic level,
    StatusMonitorLocalizations l10n,
  ) {
    return switch (level) {
      StatusLevel.healthy => l10n.pageStatusHealthy,
      StatusLevel.watch => l10n.pageStatusWatch,
      StatusLevel.issue => l10n.pageStatusIssue,
      StatusLevel.unknown => l10n.pageStatusUnknown,
      _ => '$level',
    };
  }

  String? _ageValue(String? value, StatusMonitorLocalizations l10n) {
    if (value == null || value.trim().isEmpty) return null;
    final normalized = value.trim();
    final ageLocalizer = const StatusMonitorAgeLabelLocalizer();
    if (ageLocalizer.parse(normalized) != null) {
      return ageLocalizer.localize(normalized, l10n);
    }
    if (normalized.contains('ahead')) return normalized;
    return normalized;
  }

  String? _signalValue(dynamic component, String id) {
    for (final signal in _signalsFor(component)) {
      if (signal.id == id) return signal.valueLabel;
    }
    return null;
  }

  List<StatusSignalSummary> _signalsFor(dynamic component) {
    final data = component.detailData;
    if (data is CgmSensorDetailData) return data.signals;
    if (data is JugglucoDetailData) return data.signals;
    if (data is XdripDetailData) return data.signals;
    if (data is NightscoutDetailData) return data.signals;
    if (data is AapsDetailData) return data.signals;
    if (data is WatchDetailData) return data.signals;
    return const [];
  }
}

class _SummaryCard extends StatelessWidget {
  final String value;
  final String label;

  const _SummaryCard({
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 104,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: const Color(0x6B08110D),
          borderRadius: BorderRadius.circular(11),
          border: Border.all(color: StatusMonitorTheme.line),
        ),
        // Top-align both cards so the value baselines match, then reserve a
        // fixed 2-line area for the label so a 1-line and a 2-line label still
        // line up across the two cards instead of drifting via spaceBetween.
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 36,
              child: Align(
                alignment: Alignment.topLeft,
                child: Text(
                  value,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: StatusMonitorTheme.mono.copyWith(
                    color: StatusMonitorTheme.text,
                    fontSize: 13.5,
                    height: 1.12,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            SizedBox(
              height: 38,
              child: Align(
                alignment: Alignment.topLeft,
                child: Text(
                  label,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: StatusMonitorTheme.inter.copyWith(
                    color: StatusMonitorTheme.soft,
                    fontSize: 10.5,
                    height: 1.20,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String text;

  const _SectionLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
      child: Text(
        text.toUpperCase(),
        style: StatusMonitorTheme.mono.copyWith(
          color: StatusMonitorTheme.dim,
          fontSize: 10,
          fontWeight: FontWeight.w900,
          letterSpacing: 1.2,
        ),
      ),
    );
  }
}
