import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smart_xdrip/plugin_platform/contracts/plugin_entry.dart';
import 'package:smart_xdrip/plugin_platform/contracts/plugin_id.dart';
import 'package:smart_xdrip/plugin_platform/contracts/plugin_runtime_state.dart';
import 'package:smart_xdrip/plugin_platform/contracts/plugin_runtime_status.dart';
import 'package:smart_xdrip/plugin_platform/widgets/plugin_entry_card.dart';

void main() {
  testWidgets('PluginEntryCard shows runtime reason when disabled', (
    tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: PluginEntryCard(
            entry: ExplorePluginEntry(
              section: 'TEST',
              title: 'High Episode',
              subtitle: 'Available when readings exist',
              route: '/period',
              icon: Icons.bar_chart_rounded,
              order: 1,
            ),
            state: PluginRuntimeState(
              pluginId: PluginId('explore.high_episode'),
              status: PluginRuntimeStatus.noData,
              reason: 'No glucose data available yet',
            ),
          ),
        ),
      ),
    );

    expect(find.text('High Episode'), findsOneWidget);
    expect(find.text('No glucose data available yet'), findsOneWidget);
  });
}
