import '../../../domain/analysis/status_analysis_context.dart';
import '../../../domain/detail/status_signal_summary.dart';
import '../../../domain/evidence/juggluco_broadcast_evidence.dart';
import '../../../domain/juggluco/juggluco_detail_data.dart';
import '../../../domain/juggluco/juggluco_optional_inspection.dart';
import '../../../domain/juggluco/juggluco_path_state.dart';
import '../../../domain/status_metric.dart';
import 'juggluco_chain_comparison_builder.dart';
import 'juggluco_path_state_calculator.dart';

class JugglucoDetailDataBuilder {
  final JugglucoPathStateCalculator stateCalculator;
  final JugglucoChainComparisonBuilder chainBuilder;

  const JugglucoDetailDataBuilder({
    this.stateCalculator = const JugglucoPathStateCalculator(),
    this.chainBuilder = const JugglucoChainComparisonBuilder(),
  });

  JugglucoDetailData build({
    required StatusAnalysisContext context,
    required List<StatusMetric> metrics,
  }) {
    final evidence = context.evidence.jugglucoEvidence;
    final state = stateCalculator.calculate(
      receiverConfigured: evidence.receiverConfigured,
      broadcastObserved: evidence.broadcastObserved,
      xdripCompatibleObserved: evidence.hasXdripCompatiblePath,
      age: evidence.latestXdripCompatibleAge(context.now),
    );
    final latestLabel =
        _latestLabel(evidence.latestXdripCompatibleAge(context.now));
    final latestGlucoseLabel = _latestGlucoseLabel(evidence);
    final chain = chainBuilder.build(context: context, state: state);
    final observedPathLabel = _observedPathLabel(evidence);
    return JugglucoDetailData(
      pathState: state,
      stateLabel: _stateLabel(state),
      latestLabel: latestLabel,
      latestGlucoseLabel: latestGlucoseLabel,
      observedPathLabel: observedPathLabel,
      xdripCompatiblePathObserved: evidence.hasXdripCompatiblePath,
      receiverLabel:
          evidence.receiverConfigured ? 'Receiver ready' : 'Not configured',
      signals: metrics
          .map(
            (metric) => StatusSignalSummary(
              id: metric.id,
              label: metric.label,
              valueLabel: metric.valueLabel,
              level: metric.level,
              note: metric.note,
            ),
          )
          .toList(growable: false),
      timeline: evidence.timeline,
      chainComparison: chain,
      optionalInspection: const JugglucoOptionalInspection(
        webServerConfigured: false,
        stateLabel: 'Optional',
        message:
            'Juggluco Web Server can improve history inspection, but it is not required for the normal Juggluco -> xDrip+ path.',
      ),
      supportSummary: _supportSummary(
        state: state,
        latestLabel: latestLabel,
        formatLabel: observedPathLabel,
        chainFocus: chain.focus.label,
        chainMessage: chain.message,
      ),
    );
  }

  String _supportSummary({
    required JugglucoPathState state,
    required String latestLabel,
    required String formatLabel,
    required String chainFocus,
    required String chainMessage,
  }) {
    return [
      'Status Monitor - Juggluco',
      'Juggluco broadcast: ${_stateLabel(state).toLowerCase()}',
      'Latest Juggluco reading: $latestLabel',
      'Broadcast format: $formatLabel',
      'Likely focus: $chainFocus',
      chainMessage,
      'Juggluco Web Server: optional / not required',
      'Private URLs and tokens hidden.',
    ].join('\n');
  }

  String _latestLabel(Duration? age) {
    if (age == null) return 'Never received';
    if (age.inMinutes < 1) return '${age.inSeconds}s ago';
    if (age.inHours < 1) return '${age.inMinutes}m ago';
    return '${age.inHours}h ago';
  }

  String _latestGlucoseLabel(JugglucoBroadcastEvidence evidence) {
    final snapshot = evidence.latestXdripCompatiblePath;
    final glucose = snapshot?.glucose ?? evidence.latestGlucose;
    final unit = snapshot?.unit ?? evidence.unit ?? 'mg/dL';
    if (glucose == null) return 'No glucose payload';
    return '${_formatGlucose(glucose)} $unit';
  }

  String _formatGlucose(double value) {
    if (value == value.roundToDouble()) return value.toStringAsFixed(0);
    return value.toStringAsFixed(1);
  }

  String _stateLabel(JugglucoPathState state) {
    return switch (state) {
      JugglucoPathState.fresh => 'Fresh',
      JugglucoPathState.delayed => 'Delayed',
      JugglucoPathState.stale => 'Stale',
      JugglucoPathState.unavailable => 'Unavailable',
      JugglucoPathState.waitingForFirstBroadcast =>
        'Waiting for first broadcast',
      JugglucoPathState.directOnly => 'Direct broadcast only',
      JugglucoPathState.notConfigured => 'Not configured',
      JugglucoPathState.unknown => 'Unknown',
    };
  }

  String _observedPathLabel(JugglucoBroadcastEvidence evidence) {
    if (evidence.latestByPath.isEmpty) return 'No broadcast observed';
    final labels = evidence.latestByPath
        .map((snapshot) => snapshot.path.label)
        .where((label) => label != 'Unknown')
        .toSet()
        .toList(growable: false);
    return labels.isEmpty ? 'Unknown' : labels.join(', ');
  }
}
