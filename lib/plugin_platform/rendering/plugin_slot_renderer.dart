import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import '../composition/plugin_composer.dart';
import '../composition/plugin_composition_registry.dart';
import '../graph/plugin_slot_key.dart';
import '../contracts/plugin_entry.dart';
import '../i18n/plugin_entry_localization_registry.dart';
import '../registry/plugin_registry.dart';
import '../runtime/plugin_capability_context_factory.dart';
import '../services/plugin_service_registry.dart';
import 'plugin_render_context.dart';

class PluginSlotRenderer extends StatelessWidget {
  final PluginSlotKey slot;
  final Widget Function(BuildContext context, String title)? labelBuilder;
  final Widget separator;

  const PluginSlotRenderer({
    super.key,
    required this.slot,
    this.labelBuilder,
    this.separator = const SizedBox.shrink(),
  });

  @override
  Widget build(BuildContext context) {
    final composer = PluginComposer(
      registry: context.read<PluginRegistry>(),
      compositionRegistry: context.read<PluginCompositionRegistry>(),
    );
    final result = composer.composeSlot(
      slot,
      context: PluginCapabilityContextFactory.current().create(),
    );
    final services = context.read<PluginServiceRegistry>();
    PluginEntryLocalizationRegistry? entryLocalizers;
    try {
      entryLocalizers = context.read<PluginEntryLocalizationRegistry>();
    } on ProviderNotFoundException {
      entryLocalizers = null;
    }
    final locale = Localizations.localeOf(context);
    final widgets = <Widget>[];
    for (final renderable in result.renderables) {
      final sectionEntry = SectionPluginEntry(
        pluginId: renderable.pluginId.value,
        section: '',
        title: renderable.title,
        subtitle: '',
        order: renderable.order,
      );
      final localizedTitle =
          entryLocalizers?.localizeSection(sectionEntry, locale).title ??
              renderable.title;
      final label = labelBuilder?.call(context, localizedTitle);
      if (label != null) widgets.add(label);
      widgets.add(
        renderable.builder(
          PluginRenderContext(
            buildContext: context,
            services: services,
          ),
        ),
      );
      widgets.add(separator);
    }
    if (widgets.isNotEmpty && separator is! SizedBox) {
      widgets.removeLast();
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: widgets,
    );
  }
}
