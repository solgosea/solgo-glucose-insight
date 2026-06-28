import '../../domain/evidence/status_evidence_bundle.dart';
import '../evidence/aaps_evidence_parser.dart';
import '../evidence/juggluco_evidence_reader.dart';
import '../evidence/status_evidence_bundle_factory.dart';
import '../evidence/xdrip_broadcast_evidence_reader.dart';
import 'loaders/cached_reading_evidence_loader.dart';
import 'loaders/nightscout_evidence_loader.dart';
import 'loaders/xdrip_local_evidence_loader.dart';
import '../shared/status_check_shared_context.dart';

class StatusComponentEvidenceBundleBuilder {
  final StatusEvidenceBundleFactory evidenceFactory;
  final XdripBroadcastEvidenceReader xdripBroadcastReader;
  final JugglucoEvidenceReader jugglucoReader;
  final AapsEvidenceParser aapsParser;

  const StatusComponentEvidenceBundleBuilder({
    this.evidenceFactory = const StatusEvidenceBundleFactory(),
    this.xdripBroadcastReader = const XdripBroadcastEvidenceReader(),
    this.jugglucoReader = const JugglucoEvidenceReader(),
    this.aapsParser = const AapsEvidenceParser(),
  });

  Future<StatusEvidenceBundle> buildStatusEvidence(
    StatusCheckSharedContextSeed seed,
  ) async {
    final xdripLocalFuture = XdripLocalEvidenceLoader(
      resolution: seed.plan.xdripLocal,
      now: seed.now,
    ).load();
    final nightscoutFuture = NightscoutEvidenceLoader(
      resolution: seed.plan.nightscout,
      now: seed.now,
    ).load();
    final cachedFuture = CachedReadingEvidenceLoader(
      database: seed.database,
      subjectId: seed.subjectId,
      now: seed.now,
    ).load();
    final xdripBroadcastFuture = xdripBroadcastReader.read(now: seed.now);
    final jugglucoFuture = jugglucoReader.read(now: seed.now);

    final xdripLocal = await xdripLocalFuture;
    final nightscout = await nightscoutFuture;
    final aaps = aapsParser.parse(nightscout: nightscout, now: seed.now);

    return evidenceFactory.build(
      subjectId: seed.subjectId,
      now: seed.now,
      xdripLocal: xdripLocal,
      xdripBroadcast: await xdripBroadcastFuture,
      nightscout: nightscout,
      aaps: aaps,
      juggluco: await jugglucoFuture,
      cached: await cachedFuture,
    );
  }
}
