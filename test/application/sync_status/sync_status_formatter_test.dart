import 'package:flutter_test/flutter_test.dart';
import 'package:smart_xdrip/application/sync_status/sync_status_formatter.dart';
import 'package:smart_xdrip/domain/sync_status/sync_status_level.dart';
import 'package:smart_xdrip/domain/sync_status/sync_status_snapshot.dart';

void main() {
  group('SyncStatusFormatter', () {
    const formatter = SyncStatusFormatter();

    test('shows active source and relative freshness', () {
      final snapshot = SyncStatusSnapshot(
        sourceLabel: 'xDrip+ Local',
        level: SyncStatusLevel.fresh,
        active: true,
        lastSuccessAt: DateTime.now().subtract(const Duration(minutes: 5)),
      );

      expect(formatter.compactText(snapshot), 'xDrip+ Local - 5m');
    });

    test('does not pretend unconfigured inactive sources are syncing', () {
      final text = formatter.metaTextForSource(
        sourceLabel: 'Nightscout API',
        active: false,
        configured: false,
      );

      expect(text, 'Not configured');
    });

    test('keeps configured inactive sources distinct from active sync', () {
      final text = formatter.metaTextForSource(
        sourceLabel: 'Nightscout API',
        active: false,
        configured: true,
      );

      expect(text, 'Configured, not syncing');
    });
  });
}
