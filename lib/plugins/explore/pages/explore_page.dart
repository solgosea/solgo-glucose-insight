import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:smart_xdrip/foundation/theme/app_colors.dart';
import 'package:smart_xdrip/plugin_platform/runtime/manager/plugin_runtime_manager.dart';
import 'package:smart_xdrip/plugin_platform/services/plugin_service_registry.dart';
import 'package:smart_xdrip/plugin_platform/i18n/plugin_entry_localization_registry.dart';
import 'package:smart_xdrip/plugin_platform/widgets/plugin_entry_card.dart';
import 'package:smart_xdrip/presentation/common/widgets/section_label.dart';
import '../application/i18n/explore_l10n.dart';
import '../controllers/explore_controller.dart';
import '../runtime/explore_entry_state_store.dart';
import '../runtime/explore_plugin_runtime.dart';
import '../widgets/explore_featured_section.dart';

class ExplorePage extends StatefulWidget {
  const ExplorePage({super.key});

  @override
  State<ExplorePage> createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage> {
  ExploreController? _controller;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_controller != null) return;
    final services = context.read<PluginServiceRegistry>();
    context.read<PluginRuntimeManager>().resume(ExplorePluginRuntime.id);
    _controller = ExploreController(
      store: services.get<ExploreEntryStateStore>(),
    );
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = _controller;
    final l10n = context.exploreL10n;
    final entryLocalizers = context.read<PluginEntryLocalizationRegistry>();
    final locale = Localizations.localeOf(context);
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: controller == null
          ? const Center(
              child: CircularProgressIndicator(color: AppColors.green),
            )
          : ListenableBuilder(
              listenable: controller,
              builder: (context, _) {
                return SafeArea(
                  child: ListView(
                    padding: const EdgeInsets.only(bottom: 32),
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 20, 20, 4),
                        child: Text(
                          l10n.pluginTitle,
                          style: const TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 26,
                            fontWeight: FontWeight.w700,
                            color: AppColors.text,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 0, 20, 8),
                        child: Text(
                          l10n.pluginSubtitle,
                          style: const TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 14,
                            color: AppColors.textSoft,
                          ),
                        ),
                      ),
                      if (controller.loading)
                        const Padding(
                          padding: EdgeInsets.only(top: 120),
                          child: Center(
                            child: CircularProgressIndicator(
                              color: AppColors.green,
                            ),
                          ),
                        )
                      else ...[
                        ExploreFeaturedSection(
                          reportEntry: controller.reportFeatured == null
                              ? null
                              : entryLocalizers.localizeExplore(
                                  controller.reportFeatured!.entry,
                                  locale,
                                ),
                          reportState: controller.reportFeatured?.state,
                        ),
                        for (final section in controller.sections) ...[
                          SectionLabel(
                            l10n.sectionTitleFor(section.title),
                          ),
                          for (final resolved in section.resolvedEntries)
                            PluginEntryCard(
                              entry: entryLocalizers.localizeExplore(
                                resolved.entry,
                                locale,
                              ),
                              state: resolved.state,
                            ),
                        ],
                      ],
                    ],
                  ),
                );
              },
            ),
    );
  }
}
