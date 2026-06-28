import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smart_xdrip/foundation/theme/app_colors.dart';
import 'package:smart_xdrip/presentation/common/sync_status/sync_status_meta_line.dart';
import 'package:smart_xdrip/presentation/common/sync_status/sync_status_view_model.dart';

void main() {
  testWidgets('notifies when countdown is due', (tester) async {
    var dueCount = 0;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          backgroundColor: AppColors.bg,
          body: SyncStatusMetaLine(
            viewModel: SyncStatusViewModel(
              label: 'Nightscout API',
              title: 'Sync',
              detail: 'Sync',
              semanticLabel: 'Sync',
              color: AppColors.green,
              pulsing: false,
              icon: Icons.timer_outlined,
              nextSyncAt: DateTime.now().subtract(const Duration(seconds: 1)),
            ),
            onCountdownDue: () => dueCount++,
          ),
        ),
      ),
    );

    expect(find.text('next due'), findsOneWidget);
    expect(dueCount, greaterThanOrEqualTo(1));
  });
}
