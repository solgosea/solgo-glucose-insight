import '../../../domain/probe/status_probe_catalog.dart';
import '../runtime/status_probe_registry.dart';
import 'status_probe_catalog_repository.dart';

class StatusProbeCatalogService {
  final StatusProbeCatalogRepository repository;
  final StatusProbeCatalog seedCatalog;

  const StatusProbeCatalogService({
    required this.repository,
    this.seedCatalog = const StatusProbeCatalog.empty(),
  });

  Future<void> installDefault(StatusProbeCatalog catalog) {
    return repository.installDefault(catalog);
  }

  Future<StatusProbeCatalog> load() async {
    final catalog = await repository.load();
    if (catalog.suites.isEmpty && seedCatalog.suites.isNotEmpty) {
      return seedCatalog;
    }
    return catalog;
  }

  Future<void> validateAgainstRegistry(StatusProbeRegistry registry) async {
    final catalog = await load();
    final driverIds = {
      for (final suite in registry.suites)
        for (final driver in suite.drivers) driver.definition.id.value,
    };
    final missing = catalog.probes
        .where((probe) => probe.enabled && !driverIds.contains(probe.driverId))
        .toList(growable: false);
    if (missing.isNotEmpty) {
      throw StateError(
        'Probe catalog references missing drivers: '
        '${missing.map((probe) => probe.driverId).join(', ')}',
      );
    }
  }
}
