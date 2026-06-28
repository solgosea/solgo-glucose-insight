import '../detail/status_component_detail_data.dart';
import '../detail/status_signal_summary.dart';
import 'juggluco_chain_comparison.dart';
import 'juggluco_freshness_bucket.dart';
import 'juggluco_optional_inspection.dart';
import 'juggluco_path_state.dart';

class JugglucoDetailData extends StatusComponentDetailData {
  final JugglucoPathState pathState;
  final String stateLabel;
  final String latestLabel;
  final String latestGlucoseLabel;
  final String observedPathLabel;
  final bool xdripCompatiblePathObserved;
  final String receiverLabel;
  final List<StatusSignalSummary> signals;
  final List<JugglucoFreshnessBucket> timeline;
  final JugglucoChainComparison chainComparison;
  final JugglucoOptionalInspection optionalInspection;
  final String supportSummary;

  const JugglucoDetailData({
    required this.pathState,
    required this.stateLabel,
    required this.latestLabel,
    required this.latestGlucoseLabel,
    required this.observedPathLabel,
    required this.xdripCompatiblePathObserved,
    required this.receiverLabel,
    required this.signals,
    required this.timeline,
    required this.chainComparison,
    required this.optionalInspection,
    required this.supportSummary,
  });

  @override
  String get type => 'juggluco';

  @override
  Map<String, Object?> toJson() => {
        'type': type,
        'pathState': pathState.name,
        'stateLabel': stateLabel,
        'latestLabel': latestLabel,
        'latestGlucoseLabel': latestGlucoseLabel,
        'observedPathLabel': observedPathLabel,
        'xdripCompatiblePathObserved': xdripCompatiblePathObserved,
        'receiverLabel': receiverLabel,
        'signals': signals.map((signal) => signal.toJson()).toList(),
        'timeline': timeline.map((point) => point.toJson()).toList(),
        'chainComparison': chainComparison.toJson(),
        'optionalInspection': optionalInspection.toJson(),
        'supportSummary': supportSummary,
      };
}
