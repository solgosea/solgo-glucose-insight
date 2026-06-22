import 'cgm_flat_period.dart';

class CgmFlatPeriodTimelineDataset {
  final DateTime windowStart;
  final DateTime windowEnd;
  final List<CgmFlatPeriod> periods;
  final Duration watchThreshold;
  final Duration issueThreshold;

  const CgmFlatPeriodTimelineDataset({
    required this.windowStart,
    required this.windowEnd,
    required this.periods,
    this.watchThreshold = const Duration(minutes: 30),
    this.issueThreshold = const Duration(minutes: 60),
  });

  Map<String, Object?> toJson() => {
        'windowStartMs': windowStart.millisecondsSinceEpoch,
        'windowEndMs': windowEnd.millisecondsSinceEpoch,
        'periods': periods.map((period) => period.toJson()).toList(),
        'watchThresholdMinutes': watchThreshold.inMinutes,
        'issueThresholdMinutes': issueThreshold.inMinutes,
      };
}
