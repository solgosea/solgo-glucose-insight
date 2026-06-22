import '../../data/seed/status_monitor_default_text_templates.dart';
import '../../data/seed/status_monitor_zh_text_templates.dart';
import '../../data/sqlite/status_monitor_template_repository.dart';

class StatusTextTemplateInstaller {
  final StatusMonitorTemplateRepository repository;
  bool _installed = false;

  StatusTextTemplateInstaller({
    required this.repository,
  });

  Future<void> ensureInstalled() async {
    if (_installed) return;
    await repository.upsertAll(const [
      ...StatusMonitorDefaultTextTemplates.all,
      ...StatusMonitorZhTextTemplates.all,
    ]);
    _installed = true;
  }
}
