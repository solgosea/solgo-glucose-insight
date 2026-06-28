import 'package:smart_xdrip/data/local/glucose_database.dart';

import '../../../domain/evidence/cgm_reading_evidence.dart';
import 'status_component_evidence_loader.dart';

class CachedReadingEvidenceLoader
    implements StatusComponentEvidenceLoader<CgmReadingEvidence> {
  final GlucoseDatabase database;
  final String subjectId;
  final DateTime now;

  const CachedReadingEvidenceLoader({
    required this.database,
    required this.subjectId,
    required this.now,
  });

  @override
  Future<CgmReadingEvidence> load() async {
    try {
      final readings = await database.range(
        now.subtract(const Duration(hours: 24)),
        now,
        subjectId: subjectId,
      );
      return CgmReadingEvidence(
        sourceLabel: 'Cached 24h local readings',
        readings: readings,
        generatedAt: now,
      );
    } catch (_) {
      return const CgmReadingEvidence.none(
        sourceLabel: 'Cached 24h local readings',
        failureLabel: 'Cached local readings are not available.',
      );
    }
  }
}
