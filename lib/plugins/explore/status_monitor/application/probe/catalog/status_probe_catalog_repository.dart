import '../../../domain/probe/status_probe_catalog.dart';

abstract interface class StatusProbeCatalogRepository {
  Future<void> installDefault(StatusProbeCatalog catalog);

  Future<StatusProbeCatalog> load();
}
