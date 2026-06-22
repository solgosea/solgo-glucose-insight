import '../../domain/component_health.dart';
import '../../domain/detail/status_component_detail_data.dart';
import '../../domain/status_metric.dart';
import '../../domain/status_report.dart';
import '../../domain/status_timeline_point.dart';

class StatusDashboardViewModel {
  final StatusReport report;
  final List<StatusDashboardComponentViewModel> components;

  const StatusDashboardViewModel({
    required this.report,
    required this.components,
  });
}

class StatusDashboardComponentViewModel {
  final ComponentHealth component;
  final String freshnessText;

  const StatusDashboardComponentViewModel({
    required this.component,
    required this.freshnessText,
  });
}

class StatusComponentDetailViewModel {
  final ComponentHealth component;
  final List<StatusMetric> metrics;
  final List<StatusTimelinePoint> history;
  final StatusComponentDetailData? detailData;

  const StatusComponentDetailViewModel({
    required this.component,
    required this.metrics,
    required this.history,
    this.detailData,
  });
}
