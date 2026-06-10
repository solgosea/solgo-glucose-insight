import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:smart_xdrip/foundation/theme/app_colors.dart';
import 'package:smart_xdrip/plugin_platform/runtime/manager/plugin_runtime_manager.dart';
import 'package:smart_xdrip/plugin_platform/services/plugin_service_registry.dart';
import 'package:smart_xdrip/plugin_platform/widgets/plugin_entry_card.dart';
import 'package:smart_xdrip/presentation/common/widgets/section_label.dart';
import '../controllers/explore_controller.dart';
import '../runtime/explore_entry_state_store.dart';
import '../runtime/explore_plugin_runtime.dart';

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
    return Scaffold(
      backgroundColor: AppColors.bg,
      body:
          controller == null
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
                        const Padding(
                          padding: EdgeInsets.fromLTRB(20, 20, 20, 4),
                          child: Text(
                            'Explore',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 26,
                              fontWeight: FontWeight.w700,
                              color: AppColors.text,
                            ),
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.fromLTRB(20, 0, 20, 8),
                          child: Text(
                            'Deep analysis tools',
                            style: TextStyle(
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
                          for (final section in controller.sections) ...[
                            SectionLabel(section.title),
                            for (final resolved in section.resolvedEntries)
                              PluginEntryCard(
                                entry: resolved.entry,
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
