import 'alert_banner_item.dart';
import 'alert_banner_severity.dart';

class AlertBannerRotationPolicy {
  const AlertBannerRotationPolicy();

  AlertBannerItem? selectPrimary(List<AlertBannerItem> items) {
    if (items.isEmpty) return null;
    final sorted = [...items]..sort((a, b) {
      final severityCompare = _weight(
        b.severity,
      ).compareTo(_weight(a.severity));
      if (severityCompare != 0) return severityCompare;
      return b.occurredAt.compareTo(a.occurredAt);
    });
    return sorted.first;
  }

  int _weight(AlertBannerSeverity severity) {
    return switch (severity) {
      AlertBannerSeverity.critical => 3,
      AlertBannerSeverity.warning => 2,
      AlertBannerSeverity.info => 1,
    };
  }
}
