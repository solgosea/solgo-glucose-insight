import 'cgm_sudden_jump_event.dart';

class CgmJumpTimelineDataset {
  final DateTime windowStart;
  final DateTime windowEnd;
  final List<CgmSuddenJumpEvent> events;
  final double watchThresholdMmol;
  final double issueThresholdMmol;

  const CgmJumpTimelineDataset({
    required this.windowStart,
    required this.windowEnd,
    required this.events,
    this.watchThresholdMmol = 5,
    this.issueThresholdMmol = 7,
  });

  Map<String, Object?> toJson() => {
        'windowStartMs': windowStart.millisecondsSinceEpoch,
        'windowEndMs': windowEnd.millisecondsSinceEpoch,
        'events': events.map((event) => event.toJson()).toList(),
        'watchThresholdMmol': watchThresholdMmol,
        'issueThresholdMmol': issueThresholdMmol,
      };
}
