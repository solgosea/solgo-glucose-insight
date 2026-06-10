import '../../../domain/entities/app_settings.dart';
import '../services/settings_export_service.dart';
import 'settings_host_services.dart';

class SettingsExportActions {
  final SettingsHostServices hostServices;
  final SettingsExportService exportService;

  const SettingsExportActions({
    required this.hostServices,
    this.exportService = const SettingsExportService(),
  });

  Future<String?> exportReadingsCsv(AppSettings settings) async {
    final readings = await hostServices.readingsForDays(settings.retentionDays);
    return exportService.exportReadingsCsv(readings, unit: settings.unit);
  }
}
