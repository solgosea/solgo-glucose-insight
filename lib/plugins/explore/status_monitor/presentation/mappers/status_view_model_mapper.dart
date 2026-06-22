import '../../application/freshness/status_component_freshness_resolver.dart';
import '../../domain/status_component_kind.dart';
import '../../domain/status_report.dart';
import '../../l10n/generated/status_monitor_localizations.dart';
import '../models/status_view_models.dart';

class StatusViewModelMapper {
  final StatusComponentFreshnessResolver freshnessResolver;

  const StatusViewModelMapper({
    this.freshnessResolver = const StatusComponentFreshnessResolver(),
  });

  StatusDashboardViewModel dashboard(
    StatusReport report, {
    StatusMonitorLocalizations? l10n,
  }) {
    return StatusDashboardViewModel(
      report: report,
      components: report.components
          .map(
            (component) => StatusDashboardComponentViewModel(
              component: component,
              freshnessText: freshnessResolver
                  .resolve(
                    report: report,
                    component: component,
                    l10n: l10n,
                  )
                  .label,
            ),
          )
          .toList(growable: false),
    );
  }

  StatusComponentDetailViewModel detail(
    StatusReport report,
    StatusComponentKind kind,
  ) {
    final component = report.component(kind);
    return StatusComponentDetailViewModel(
      component: component,
      metrics: component.metrics,
      history: component.history,
      detailData: component.detailData,
    );
  }
}
