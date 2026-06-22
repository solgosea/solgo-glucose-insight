import '../application/evidence/aaps_evidence_parser.dart';
import '../domain/detail/status_response_snapshot.dart';
import '../domain/evidence/aaps_evidence.dart';
import '../domain/evidence/nightscout_evidence.dart';

class FakeAapsEvidenceFactory {
  const FakeAapsEvidenceFactory();

  AapsEvidence healthy({DateTime? now}) {
    final timestamp = now ?? DateTime.utc(2026, 6, 15, 12);
    return const AapsEvidenceParser().parse(
      now: timestamp,
      nightscout: NightscoutEvidence(
        configured: true,
        enabled: true,
        sourceLabel: 'Nightscout',
        generatedAt: timestamp,
        status: const StatusResponseSnapshot(
          reachable: true,
          elapsed: Duration(milliseconds: 120),
        ),
        deviceStatus: [
          {
            'created_at': timestamp
                .subtract(const Duration(minutes: 4))
                .toIso8601String(),
            'openaps': {
              'suggested': {'status': 'visible'},
              'iob': {'iob': 1.2},
              'cob': 18,
              'profile': 'Default',
            },
            'pump': {
              'status': 'normal',
              'reservoir': 132,
              'battery': {'percent': 72},
            },
          },
        ],
      ),
    );
  }
}
