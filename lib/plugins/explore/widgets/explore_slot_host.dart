import 'package:flutter/widgets.dart';

import '../../../plugin_platform/graph/plugin_slot_key.dart';
import '../../../plugin_platform/rendering/plugin_slot_renderer.dart';

class ExploreSlotHost extends StatelessWidget {
  final PluginSlotKey slot;

  const ExploreSlotHost({
    super.key,
    required this.slot,
  });

  @override
  Widget build(BuildContext context) {
    return PluginSlotRenderer(
      slot: slot,
      separator: const SizedBox(height: 8),
    );
  }
}
