import '../mappers/insights_view_model_mapper.dart';
import '../runtime/insights_runtime_cache.dart';
import 'insights_host_services.dart';

class InsightsSnapshotPreheater {
  final InsightsHostServices hostServices;
  final InsightsViewModelMapper mapper;
  final DateTime Function() now;

  InsightsSnapshotPreheater({
    required this.hostServices,
    InsightsViewModelMapper? mapper,
    DateTime Function()? now,
  }) : mapper = mapper ?? InsightsViewModelMapper(),
       now = now ?? DateTime.now;

  Future<InsightsRuntimeSnapshot> preheat() async {
    final facade = hostServices.facadeProvider();
    return InsightsRuntimeSnapshot(
      subjectId: facade.activeSubject.id,
      viewModel: mapper.map(facade: facade),
      updatedAt: now(),
    );
  }
}
