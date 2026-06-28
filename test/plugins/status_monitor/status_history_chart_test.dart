import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smart_xdrip/plugins/explore/status_monitor/domain/status_component_kind.dart';
import 'package:smart_xdrip/plugins/explore/status_monitor/domain/history/status_component_history_load_state.dart';
import 'package:smart_xdrip/plugins/explore/status_monitor/domain/status_level.dart';
import 'package:smart_xdrip/plugins/explore/status_monitor/presentation/history/models/status_component_history_section_view_model.dart';
import 'package:smart_xdrip/plugins/explore/status_monitor/presentation/history/models/status_component_history_view_model.dart';
import 'package:smart_xdrip/plugins/explore/status_monitor/presentation/history/models/status_history_cell_view_model.dart';
import 'package:smart_xdrip/plugins/explore/status_monitor/presentation/history/models/status_history_view_model.dart';
import 'package:smart_xdrip/plugins/explore/status_monitor/presentation/widgets/status_history_chart.dart';

void main() {
  testWidgets('status history chart renders legend and component cards',
      (tester) async {
    final now = DateTime.utc(2026, 6, 12, 10);
    final component = StatusComponentHistoryViewModel(
      component: StatusComponentKind.nightscout,
      title: 'Nightscout',
      currentLevel: StatusLevel.issue,
      coverage: .5,
      dailyCells: [
        for (var i = 0; i < 7; i++)
          StatusHistoryCellViewModel(
            at: now.subtract(Duration(days: 6 - i)),
            label: i == 6 ? 'Today' : 'Jun ${6 + i}',
            level: i < 4 ? StatusLevel.healthy : StatusLevel.issue,
            reasonLabel: 'Recorded sample',
          ),
      ],
      hourlyRows: [
        for (var day = 0; day < 7; day++)
          [
            for (var hour = 0; hour < 24; hour++)
              StatusHistoryCellViewModel(
                at: now,
                label: day == 6 ? 'Today' : 'Jun ${6 + day}',
                level: hour < 12 ? StatusLevel.healthy : StatusLevel.issue,
                reasonLabel: 'Recorded sample',
              ),
          ],
      ],
    );

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SingleChildScrollView(
            child: StatusHistoryChart(
              viewModel: StatusHistoryViewModel(
                title: '7-Day History',
                subtitle: 'Each row is one day',
                sections: [
                  StatusComponentHistorySectionViewModel(
                    component: component.component,
                    title: component.title,
                    currentLevel: component.currentLevel,
                    state: StatusComponentHistoryLoadState.ready,
                    history: component,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );

    expect(find.text('7-Day History'), findsNothing);
    expect(find.text('Healthy'), findsOneWidget);
    expect(find.text('Watch'), findsOneWidget);
    expect(find.text('Issue'), findsWidgets);
    expect(find.text('Nightscout'), findsWidgets);
    expect(find.text('Daily summary - 7 days'.toUpperCase()), findsOneWidget);
    expect(find.text('Hourly detail'.toUpperCase()), findsOneWidget);
    expect(find.text('Recent status changes'.toUpperCase()), findsNothing);
  });
}
