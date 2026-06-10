import 'package:flutter_test/flutter_test.dart';
import 'package:smart_xdrip/alerting/presentation/banner/alert_banner_item.dart';
import 'package:smart_xdrip/alerting/presentation/banner/alert_banner_rotation_policy.dart';
import 'package:smart_xdrip/alerting/presentation/banner/alert_banner_severity.dart';

void main() {
  test('selectPrimary prefers critical and then newer alerts', () {
    final now = DateTime(2026, 1, 1, 12);
    const policy = AlertBannerRotationPolicy();

    final selected = policy.selectPrimary([
      AlertBannerItem(
        id: 'warning-new',
        title: 'Warning',
        message: 'new warning',
        severity: AlertBannerSeverity.warning,
        occurredAt: now,
      ),
      AlertBannerItem(
        id: 'critical-old',
        title: 'Critical',
        message: 'old critical',
        severity: AlertBannerSeverity.critical,
        occurredAt: now.subtract(const Duration(minutes: 10)),
      ),
    ]);

    expect(selected?.id, 'critical-old');
  });

  test('selectPrimary uses newest item within same severity', () {
    final now = DateTime(2026, 1, 1, 12);
    const policy = AlertBannerRotationPolicy();

    final selected = policy.selectPrimary([
      AlertBannerItem(
        id: 'old',
        title: 'Old',
        message: 'old',
        severity: AlertBannerSeverity.warning,
        occurredAt: now.subtract(const Duration(minutes: 10)),
      ),
      AlertBannerItem(
        id: 'new',
        title: 'New',
        message: 'new',
        severity: AlertBannerSeverity.warning,
        occurredAt: now,
      ),
    ]);

    expect(selected?.id, 'new');
  });
}
