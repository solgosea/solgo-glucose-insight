import '../../../domain/analysis/status_analysis_context.dart';
import '../../../domain/cgm_sensor/cgm_flat_period.dart';
import '../../../domain/cgm_sensor/cgm_flat_period_timeline_dataset.dart';

class CgmFlatTimelineDatasetBuilder {
  const CgmFlatTimelineDatasetBuilder();

  CgmFlatPeriodTimelineDataset build({
    required StatusAnalysisContext context,
    required List<CgmFlatPeriod> periods,
  }) {
    final windowEnd = context.now;
    return CgmFlatPeriodTimelineDataset(
      windowStart: windowEnd.subtract(const Duration(hours: 24)),
      windowEnd: windowEnd,
      periods: periods,
    );
  }
}
