import 'package:flutter/material.dart';

import '../../../../foundation/theme/app_colors.dart';
import '../../../../presentation/common/date_filter/widgets/date_filter_icon_button.dart';
import '../../../../presentation/common/navigation/safe_navigation.dart';
import '../../../../presentation/common/widgets/page_header.dart';
import '../../../../presentation/common/widgets/section_label.dart';
import '../application/i18n/report_l10n.dart';
import '../models/report_section.dart';
import '../models/report_view_model.dart';
import 'package:smart_xdrip/reporting/application/report_export_action.dart';
import 'report_agp_card.dart';
import 'report_daily_curves_card.dart';
import 'report_export_panel.dart';
import 'report_header_card.dart';
import 'report_metrics_grid.dart';
import 'report_ranges_card.dart';
import 'report_sections_card.dart';

class ReportBody extends StatelessWidget {
  final ReportViewModel viewModel;
  final bool loading;
  final bool exporting;
  final VoidCallback onDateFilterPressed;
  final Future<void> Function() onRefresh;
  final ValueChanged<ReportSectionKey> onToggleSection;
  final ValueChanged<ReportExportAction> onExport;

  const ReportBody({
    super.key,
    required this.viewModel,
    required this.loading,
    required this.exporting,
    required this.onDateFilterPressed,
    required this.onRefresh,
    required this.onToggleSection,
    required this.onExport,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = context.reportL10n;
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: SafeArea(
        child: RefreshIndicator(
          color: AppColors.green,
          backgroundColor: AppColors.bgCard,
          onRefresh: onRefresh,
          child: ListView(
            padding: const EdgeInsets.only(bottom: 32),
            children: [
              PageHeader(
                title: l10n.pluginTitle,
                subtitle: l10n.pageSubtitle,
                onBack: () => context.safePopOrHome(),
                trailing: DateFilterIconButton(
                  onPressed: onDateFilterPressed,
                  tooltip: l10n.dateFilterTooltip,
                ),
              ),
              if (loading)
                const LinearProgressIndicator(
                  minHeight: 2,
                  color: AppColors.green,
                  backgroundColor: Colors.transparent,
                ),
              ReportHeaderCard(viewModel: viewModel.header),
              SectionLabel(l10n.sectionKeyMetrics),
              ReportMetricsGrid(metrics: viewModel.metrics),
              SectionLabel(l10n.sectionTimeInRanges),
              ReportRangesCard(
                ranges: viewModel.ranges,
                targetRangeLabel: viewModel.header.targetRangeLabel,
              ),
              SectionLabel(l10n.sectionAgp),
              ReportAgpCard(viewModel: viewModel),
              SectionLabel(l10n.sectionDailyCurves),
              ReportDailyCurvesCard(days: viewModel.dailyCurves),
              SectionLabel(l10n.sectionIncludeInReport),
              ReportSectionsCard(
                sections: viewModel.sections,
                onToggle: onToggleSection,
              ),
              SectionLabel(l10n.sectionExport),
              ReportExportPanel(
                exporting: exporting,
                enabled: viewModel.hasData,
                onExport: onExport,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
