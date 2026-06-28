import '../../../../domain/probe/status_probe_kind.dart';
import '../../../../domain/probe/status_probe_suite_definition.dart';
import '../../contracts/status_probe_driver.dart';
import '../../contracts/status_probe_suite.dart';
import 'probes/aaps_devicestatus_evidence_probe.dart';
import 'probes/aaps_loop_context_evidence_probe.dart';
import 'probes/aaps_package_probe.dart';
import 'probes/aaps_xdrip_bg_source_evidence_probe.dart';
import 'probes/aaps_xdrip_output_evidence_probe.dart';

class AapsProbeSuite implements StatusProbeSuite {
  AapsProbeSuite({
    List<StatusProbeDriver>? drivers,
  }) : drivers = drivers ??
            [
              AapsPackageProbe(),
              AapsXdripBgSourceEvidenceProbe(),
              AapsXdripOutputEvidenceProbe(),
              AapsDevicestatusEvidenceProbe(),
              AapsLoopContextEvidenceProbe(),
            ];

  @override
  final List<StatusProbeDriver> drivers;

  @override
  StatusProbeSuiteDefinition get definition => StatusProbeSuiteDefinition(
        id: 'aaps',
        label: 'AAPS',
        kind: StatusProbeKind.aaps,
        probes: drivers.map((driver) => driver.definition).toList(),
      );
}
