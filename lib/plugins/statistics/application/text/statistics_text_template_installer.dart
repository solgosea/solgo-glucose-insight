import 'package:smart_xdrip/application/plugin_text/plugin_text_template_installer.dart';

import '../../data/seed/statistics_default_text_templates.dart';
import '../../data/seed/statistics_zh_text_templates.dart';
import '../../data/sqlite/statistics_template_repository.dart';

class StatisticsTextTemplateInstaller extends PluginTextTemplateInstaller {
  StatisticsTextTemplateInstaller({
    required StatisticsTemplateRepository repository,
  }) : super(
          repository: repository,
          templates: const [
            ...StatisticsDefaultTextTemplates.all,
            ...StatisticsZhTextTemplates.all,
          ],
        );
}
