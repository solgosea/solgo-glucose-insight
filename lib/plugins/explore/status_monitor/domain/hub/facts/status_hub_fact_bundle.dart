import 'aaps_hub_facts.dart';
import 'cgm_hub_facts.dart';
import 'juggluco_hub_facts.dart';
import 'nightscout_hub_facts.dart';
import 'status_hub_component_facts.dart';
import 'watch_hub_facts.dart';
import 'xdrip_hub_facts.dart';
import '../../trace/status_evidence_trace_chain.dart';

class StatusHubFactBundle {
  final DateTime generatedAt;
  final String sourceKind;
  final String sourceLabel;
  final CgmHubFacts cgm;
  final JugglucoHubFacts juggluco;
  final XdripHubFacts xdrip;
  final NightscoutHubFacts nightscout;
  final AapsHubFacts aaps;
  final WatchHubFacts watch;
  final StatusEvidenceTraceChain traceChain;

  const StatusHubFactBundle({
    required this.generatedAt,
    required this.sourceKind,
    required this.sourceLabel,
    required this.cgm,
    required this.juggluco,
    required this.xdrip,
    required this.nightscout,
    required this.aaps,
    required this.watch,
    this.traceChain = StatusEvidenceTraceChain.empty,
  });

  List<StatusHubComponentFacts> get components => [
        cgm.component,
        juggluco.component,
        xdrip.component,
        nightscout.component,
        aaps.component,
        watch.component,
      ];
}
