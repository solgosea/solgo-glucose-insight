import '../../../domain/probe/status_probe_context.dart';
import '../../../domain/probe/status_probe_definition.dart';
import '../../../domain/probe/status_probe_result.dart';

abstract interface class StatusProbeDriver {
  StatusProbeDefinition get definition;

  Future<StatusProbeResult> run(StatusProbeContext context);
}
