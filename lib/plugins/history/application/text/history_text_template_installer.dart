import 'package:smart_xdrip/application/plugin_text/plugin_text_template_installer.dart';

import '../../data/seed/history_default_text_templates.dart';
import '../../data/seed/history_zh_text_templates.dart';
import '../../data/sqlite/history_template_repository.dart';

class HistoryTextTemplateInstaller extends PluginTextTemplateInstaller {
  HistoryTextTemplateInstaller({
    required HistoryTemplateRepository repository,
  }) : super(
          repository: repository,
          templates: const [
            ...HistoryDefaultTextTemplates.all,
            ...HistoryZhTextTemplates.all,
          ],
        );
}
