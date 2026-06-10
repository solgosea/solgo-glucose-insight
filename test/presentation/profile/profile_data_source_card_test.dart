import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smart_xdrip/domain/data_source/data_source_action.dart';
import 'package:smart_xdrip/domain/data_source/data_source_kind.dart';
import 'package:smart_xdrip/domain/data_source/data_source_sync_strategy_action.dart';
import 'package:smart_xdrip/plugins/profile/models/profile_view_model.dart';
import 'package:smart_xdrip/plugins/profile/widgets/profile_data_source_card.dart';

void main() {
  group('ProfileDataSourceCard', () {
    testWidgets('strategy switch only invokes strategy action', (tester) async {
      var sourceActions = 0;
      var strategyActions = 0;
      var secondaryActions = 0;

      await tester.pumpWidget(
        _Harness(
          sources: [_source()],
          onSourceAction: (_) => sourceActions++,
          onSourceStrategyAction: (_) => strategyActions++,
          onSourceSecondaryAction: (_) => secondaryActions++,
        ),
      );

      await tester.tap(find.byKey(const Key('source-switch-xdripLocal')));
      await tester.pumpAndSettle();

      expect(strategyActions, 1);
      expect(sourceActions, 0);
      expect(secondaryActions, 0);
    });

    testWidgets('connection pill only invokes connection action', (
      tester,
    ) async {
      var sourceActions = 0;
      var strategyActions = 0;

      await tester.pumpWidget(
        _Harness(
          sources: [_source()],
          onSourceAction: (_) => sourceActions++,
          onSourceStrategyAction: (_) => strategyActions++,
          onSourceSecondaryAction: (_) {},
        ),
      );

      await tester.tap(find.byKey(const Key('source-action-xdripLocal')));
      await tester.pumpAndSettle();

      expect(sourceActions, 1);
      expect(strategyActions, 0);
    });

    testWidgets('Nightscout edit URL invokes secondary action only', (
      tester,
    ) async {
      var sourceActions = 0;
      var strategyActions = 0;
      var secondaryActions = 0;

      await tester.pumpWidget(
        _Harness(
          sources: [
            _source(
              kind: DataSourceKind.nightscout,
              name: 'Nightscout API',
              action: DataSourceConnectionAction.none,
              trailing: 'Configured',
              actionEnabled: false,
              secondaryAction: DataSourceConnectionAction.configure,
            ),
          ],
          onSourceAction: (_) => sourceActions++,
          onSourceStrategyAction: (_) => strategyActions++,
          onSourceSecondaryAction: (_) => secondaryActions++,
        ),
      );

      await tester.tap(find.text('Edit URL'));
      await tester.pumpAndSettle();

      expect(secondaryActions, 1);
      expect(sourceActions, 0);
      expect(strategyActions, 0);
    });
  });
}

class _Harness extends StatelessWidget {
  final List<ProfileDataSourceViewModel> sources;
  final ValueChanged<ProfileDataSourceViewModel> onSourceAction;
  final ValueChanged<ProfileDataSourceViewModel> onSourceStrategyAction;
  final ValueChanged<ProfileDataSourceViewModel> onSourceSecondaryAction;

  const _Harness({
    required this.sources,
    required this.onSourceAction,
    required this.onSourceStrategyAction,
    required this.onSourceSecondaryAction,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: ProfileDataSourceCard(
            sources: sources,
            onSourceAction: onSourceAction,
            onSourceStrategyAction: onSourceStrategyAction,
            onSourceSecondaryAction: onSourceSecondaryAction,
          ),
        ),
      ),
    );
  }
}

ProfileDataSourceViewModel _source({
  DataSourceKind kind = DataSourceKind.xdripLocal,
  String name = 'xDrip+ Local',
  DataSourceConnectionAction action = DataSourceConnectionAction.connect,
  String trailing = 'Connect',
  bool actionEnabled = true,
  DataSourceConnectionAction? secondaryAction,
}) {
  return ProfileDataSourceViewModel(
    kind: kind,
    action: action,
    strategyAction: DataSourceSyncStrategyAction.enable,
    actionStyle: ProfileDataSourceActionStyle.primary,
    strategyActionStyle: ProfileDataSourceActionStyle.primary,
    name: name,
    subtitle: 'Strategy is off - enable before connecting',
    meta: null,
    trailing: trailing,
    strategyTrailing: 'Enable',
    secondaryTrailing: secondaryAction == null ? null : 'Edit URL',
    secondaryAction: secondaryAction,
    secondaryActionStyle: ProfileDataSourceActionStyle.secondary,
    statusColor: Colors.green,
    active: false,
    actionEnabled: actionEnabled,
    strategyActionEnabled: true,
    pulsing: false,
    muted: false,
  );
}
