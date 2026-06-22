import '../../../domain/analysis/status_analysis_context.dart';
import '../../../domain/cgm_sensor/cgm_jump_timeline_dataset.dart';
import '../../../domain/cgm_sensor/cgm_sudden_jump_event.dart';

class CgmJumpTimelineDatasetBuilder {
  const CgmJumpTimelineDatasetBuilder();

  CgmJumpTimelineDataset build({
    required StatusAnalysisContext context,
    required List<CgmSuddenJumpEvent> events,
  }) {
    final windowEnd = context.now;
    return CgmJumpTimelineDataset(
      windowStart: windowEnd.subtract(const Duration(hours: 24)),
      windowEnd: windowEnd,
      events: events,
    );
  }
}
