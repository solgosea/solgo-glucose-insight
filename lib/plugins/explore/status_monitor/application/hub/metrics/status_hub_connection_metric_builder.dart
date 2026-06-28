import '../../../domain/hub/facts/status_hub_fact_bundle.dart';
import '../../../domain/hub/status_hub_enums.dart';
import '../../../domain/hub/status_hub_models.dart';
import 'cgm_xdrip_metric_builder.dart';
import 'juggluco_xdrip_metric_builder.dart';
import 'xdrip_aaps_metric_builder.dart';
import 'xdrip_nightscout_metric_builder.dart';

class StatusHubConnectionMetricBuilder {
  final CgmXdripMetricBuilder cgmXdrip;
  final JugglucoXdripMetricBuilder jugglucoXdrip;
  final XdripNightscoutMetricBuilder xdripNightscout;
  final XdripAapsMetricBuilder xdripAaps;

  const StatusHubConnectionMetricBuilder({
    this.cgmXdrip = const CgmXdripMetricBuilder(),
    this.jugglucoXdrip = const JugglucoXdripMetricBuilder(),
    this.xdripNightscout = const XdripNightscoutMetricBuilder(),
    this.xdripAaps = const XdripAapsMetricBuilder(),
  });

  List<StatusHubMetricFact> build(
    StatusHubConnectionId connectionId,
    StatusHubFactBundle facts,
  ) {
    return switch (connectionId) {
      StatusHubConnectionId.cgmToXdrip => cgmXdrip.build(facts),
      StatusHubConnectionId.jugglucoToXdrip => jugglucoXdrip.build(facts),
      StatusHubConnectionId.xdripToNightscout => xdripNightscout.build(facts),
      StatusHubConnectionId.xdripToAaps => xdripAaps.build(facts),
      StatusHubConnectionId.xdripToWatch => const [],
    };
  }
}
