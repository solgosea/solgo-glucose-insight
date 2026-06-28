import '../../../domain/probe/status_probe_context.dart';
import '../../../domain/probe/status_probe_result.dart';
import '../contracts/status_probe_driver.dart';

class StatusProbeRunner {
  final DateTime Function() now;

  const StatusProbeRunner({
    DateTime Function()? now,
  }) : now = now ?? DateTime.now;

  Future<StatusProbeResult> run(
    StatusProbeDriver driver,
    StatusProbeContext context,
  ) async {
    final started = now();
    try {
      return await driver.run(context).timeout(driver.definition.timeout);
    } catch (error) {
      return StatusProbeResult.error(
        definition: driver.definition,
        observedAt: now(),
        error: error,
        elapsed: now().difference(started),
      );
    }
  }
}
