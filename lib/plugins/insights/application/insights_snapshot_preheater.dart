import 'insights_service.dart';
import '../mappers/insights_view_model_mapper.dart';
import '../runtime/insights_runtime_cache.dart';
import 'insights_host_services.dart';

class InsightsSnapshotPreheater {
  final InsightsHostServices hostServices;
  final InsightsService? service;
  final InsightsViewModelMapper mapper;
  final DateTime Function() now;

  InsightsSnapshotPreheater({
    required this.hostServices,
    this.service,
    InsightsViewModelMapper? mapper,
    DateTime Function()? now,
  })  : mapper = mapper ?? InsightsViewModelMapper(),
        now = now ?? DateTime.now;

  Future<InsightsRuntimeSnapshot> preheat() async {
    final output =
        (service ?? InsightsService(hostServices: hostServices)).load();
    return InsightsRuntimeSnapshot(
      subjectId: output.query.subjectId,
      output: output,
      viewModel: mapper.map(output),
      updatedAt: now(),
    );
  }
}
