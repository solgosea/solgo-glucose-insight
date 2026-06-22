import 'package:smart_xdrip/application/plugin_text/plugin_text_template_installer.dart';

import '../../data/seed/episode_detail_default_text_templates.dart';
import '../../data/seed/episode_detail_zh_text_templates.dart';
import '../../data/sqlite/episode_detail_template_repository.dart';

class EpisodeDetailTextTemplateInstaller extends PluginTextTemplateInstaller {
  EpisodeDetailTextTemplateInstaller({
    required EpisodeDetailTemplateRepository repository,
  }) : super(
          repository: repository,
          templates: const [
            ...EpisodeDetailDefaultTextTemplates.all,
            ...EpisodeDetailZhTextTemplates.all,
          ],
        );
}
