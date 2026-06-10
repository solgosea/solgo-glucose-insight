import 'package:smart_xdrip/domain/entities/glucose_reading.dart';
import 'package:smart_xdrip/domain/glucose_etl/raw_glucose_reading.dart';
import 'package:smart_xdrip/domain/glucose_trend/glucose_trend_enrichment_service.dart';

import '../transform/glucose_timestamp_bucket_policy.dart';
import 'source_record_identity_policy.dart';

class RawGlucoseReadingNormalizer {
  final SourceRecordIdentityPolicy identityPolicy;
  final GlucoseTimestampBucketPolicy bucketPolicy;
  final GlucoseTrendEnrichmentService trendEnrichmentService;

  const RawGlucoseReadingNormalizer({
    this.identityPolicy = const SourceRecordIdentityPolicy(),
    this.bucketPolicy = const GlucoseTimestampBucketPolicy(),
    this.trendEnrichmentService = const GlucoseTrendEnrichmentService(),
  });

  List<RawGlucoseReading> normalize({
    required String source,
    required List<GlucoseReading> readings,
    DateTime? receivedAt,
  }) {
    final received = receivedAt ?? DateTime.now();
    final enrichedReadings = trendEnrichmentService.enrichReadings(readings);
    return enrichedReadings.map((reading) {
      final sourceRecordId = identityPolicy.sourceRecordId(
        source: source,
        reading: reading,
      );
      return RawGlucoseReading(
        id: identityPolicy.rawId(
          source: source,
          sourceRecordId: sourceRecordId,
        ),
        source: source,
        sourceRecordId: sourceRecordId,
        timestamp: reading.timestamp,
        bucketMs: bucketPolicy.bucketMs(reading.timestamp),
        value: reading.value,
        ratePerMin: reading.ratePerMin,
        receivedAt: received,
      );
    }).toList();
  }
}
