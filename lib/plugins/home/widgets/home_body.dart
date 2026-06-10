import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_xdrip/plugin_platform/placement/home_widget_plugin_resolver.dart';
import 'package:smart_xdrip/plugin_platform/registry/plugin_registry.dart';
import 'package:smart_xdrip/plugin_platform/runtime/plugin_capability_context_factory.dart';
import '../models/home_chart_range.dart';
import '../models/home_view_model.dart';
import 'home_header.dart';
import 'home_hero_glucose_card.dart';
import 'home_insight_banner.dart';
import 'home_range_chart_card.dart';
import 'home_stats_row.dart';
import 'home_tir_section.dart';

class HomeBody extends StatelessWidget {
  final HomeViewModel viewModel;
  final ValueChanged<HomeChartRange> onRangeChanged;
  final VoidCallback onInsightTap;
  final VoidCallback onSwitchBackToSelf;

  const HomeBody({
    super.key,
    required this.viewModel,
    required this.onRangeChanged,
    required this.onInsightTap,
    required this.onSwitchBackToSelf,
  });

  @override
  Widget build(BuildContext context) {
    final pluginContext = PluginCapabilityContextFactory.current().create();
    final registry = context.read<PluginRegistry>();
    final widgets = HomeWidgetPluginResolver(
      registry,
    ).resolve(context: pluginContext);

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            for (final widget in widgets)
              ..._buildHomeWidget(widget.entry.widgetKey),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildHomeWidget(String widgetKey) {
    return switch (widgetKey) {
      'home.header' => [
        HomeHeader(
          viewModel: viewModel,
          onSwitchBackToSelf: onSwitchBackToSelf,
        ),
        const SizedBox(height: 4),
      ],
      'home.hero_glucose' => [
        HomeHeroGlucoseCard(glucose: viewModel.glucose),
        const SizedBox(height: 18),
      ],
      'home.range_chart' => [
        HomeRangeChartCard(
          viewModel: viewModel,
          onRangeChanged: onRangeChanged,
        ),
        const SizedBox(height: 12),
      ],
      'home.stats' => [
        HomeStatsRow(stats: viewModel.stats),
        const SizedBox(height: 12),
      ],
      'home.tir' => [
        HomeTirSection(viewModel: viewModel.tir),
        const SizedBox(height: 12),
      ],
      'home.insight' => [
        HomeInsightBanner(text: viewModel.insightText, onTap: onInsightTap),
      ],
      _ => const <Widget>[],
    };
  }
}
