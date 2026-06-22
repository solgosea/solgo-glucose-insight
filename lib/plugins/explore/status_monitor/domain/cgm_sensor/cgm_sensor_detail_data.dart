import '../detail/status_component_detail_data.dart';
import '../detail/status_signal_summary.dart';
import '../detail/status_timeline_bucket.dart';
import '../status_level.dart';
import 'cgm_flat_period_timeline_dataset.dart';
import 'cgm_flat_period.dart';
import 'cgm_jump_timeline_dataset.dart';
import 'cgm_sensor_health_score_breakdown.dart';
import 'cgm_sudden_jump_event.dart';

class CgmSensorDetailData extends StatusComponentDetailData {
  static const typeName = 'cgmSensor';

  final List<StatusSignalSummary> signals;
  final List<StatusTimelineBucket> qualityTimeline;
  final String latestReadingAgeLabel;
  final StatusLevel latestReadingLevel;
  final String qualityTimelineSourceLabel;
  final List<CgmSuddenJumpEvent> suddenJumps;
  final CgmJumpTimelineDataset jumpTimeline;
  final List<CgmFlatPeriod> flatPeriods;
  final CgmFlatPeriodTimelineDataset flatTimeline;
  final String sourceModeLabel;
  final String contextLabel;
  final CgmSensorHealthScoreBreakdown? scoreBreakdown;

  const CgmSensorDetailData({
    required this.signals,
    required this.qualityTimeline,
    required this.latestReadingAgeLabel,
    required this.latestReadingLevel,
    required this.qualityTimelineSourceLabel,
    required this.suddenJumps,
    required this.jumpTimeline,
    required this.flatPeriods,
    required this.flatTimeline,
    required this.sourceModeLabel,
    required this.contextLabel,
    this.scoreBreakdown,
  });

  @override
  String get type => typeName;

  @override
  Map<String, Object?> toJson() => {
        'type': type,
        'signals': signals.map((signal) => signal.toJson()).toList(),
        'qualityTimeline':
            qualityTimeline.map((bucket) => bucket.toJson()).toList(),
        'latestReadingAgeLabel': latestReadingAgeLabel,
        'latestReadingLevel': latestReadingLevel.name,
        'qualityTimelineSourceLabel': qualityTimelineSourceLabel,
        'suddenJumps': suddenJumps.map((jump) => jump.toJson()).toList(),
        'jumpTimeline': jumpTimeline.toJson(),
        'flatPeriods': flatPeriods.map((period) => period.toJson()).toList(),
        'flatTimeline': flatTimeline.toJson(),
        'sourceModeLabel': sourceModeLabel,
        'contextLabel': contextLabel,
        'scoreBreakdown': scoreBreakdown?.toJson(),
      };

  factory CgmSensorDetailData.fromJson(Map<String, Object?> json) {
    return CgmSensorDetailData(
      signals: const [],
      qualityTimeline: const [],
      latestReadingAgeLabel: 'Unknown',
      latestReadingLevel: StatusLevel.unknown,
      qualityTimelineSourceLabel: '',
      suddenJumps: const [],
      jumpTimeline: CgmJumpTimelineDataset(
        windowStart: DateTime.fromMillisecondsSinceEpoch(0),
        windowEnd: DateTime.fromMillisecondsSinceEpoch(0),
        events: const [],
      ),
      flatPeriods: const [],
      flatTimeline: CgmFlatPeriodTimelineDataset(
        windowStart: DateTime.fromMillisecondsSinceEpoch(0),
        windowEnd: DateTime.fromMillisecondsSinceEpoch(0),
        periods: const [],
      ),
      sourceModeLabel: json['sourceModeLabel']?.toString() ?? '',
      contextLabel: json['contextLabel']?.toString() ?? '',
    );
  }
}
