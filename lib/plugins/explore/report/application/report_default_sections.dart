import '../models/report_section.dart';
import '../l10n/generated/report_localizations.dart';
import 'i18n/report_l10n_resolver.dart';

class ReportDefaultSections {
  static final values = localized(ReportL10nResolver.fallback);

  static List<ReportSectionToggle> localized(ReportLocalizations l10n) {
    return [
      ReportSectionToggle(
        key: ReportSectionKey.keyMetrics,
        title: l10n.toggleKeyMetricsTitle,
        subtitle: l10n.toggleKeyMetricsSubtitle,
        enabled: true,
      ),
      ReportSectionToggle(
        key: ReportSectionKey.agpChart,
        title: l10n.toggleAgpChartTitle,
        subtitle: l10n.toggleAgpChartSubtitle,
        enabled: true,
      ),
      ReportSectionToggle(
        key: ReportSectionKey.dailyCurves,
        title: l10n.toggleDailyCurvesTitle,
        subtitle: l10n.toggleDailyCurvesSubtitle,
        enabled: true,
      ),
      ReportSectionToggle(
        key: ReportSectionKey.periodAnalysis,
        title: l10n.togglePeriodAnalysisTitle,
        subtitle: l10n.togglePeriodAnalysisSubtitle,
        enabled: false,
      ),
      ReportSectionToggle(
        key: ReportSectionKey.episodesSummary,
        title: l10n.toggleEpisodesSummaryTitle,
        subtitle: l10n.toggleEpisodesSummarySubtitle,
        enabled: false,
      ),
    ];
  }
}
