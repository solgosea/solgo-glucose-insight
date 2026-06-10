import 'package:smart_xdrip/application/glucose_etl/glucose_etl_pipeline.dart';

import '../glucose_sync_context.dart';
import '../glucose_sync_step.dart';

class PersistGlucoseReadingsStep extends GlucoseSyncStep {
  const PersistGlucoseReadingsStep();

  @override
  Future<void> execute(GlucoseSyncContext context) async {
    if (context.readings.isEmpty) return;
    context.etlResult = await GlucoseEtlPipeline(
      database: context.database,
    ).run(
      source: context.sourceKey,
      readings: context.readings,
      subjectId: context.subjectId,
    );
  }
}
