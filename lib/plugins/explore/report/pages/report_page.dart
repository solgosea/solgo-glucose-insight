import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../foundation/theme/app_colors.dart';
import '../../../../plugin_platform/runtime/manager/plugin_runtime_manager.dart';
import '../../../../plugin_platform/services/plugin_service_registry.dart';
import '../../../../presentation/common/date_filter/domain/date_filter_preset.dart';
import '../../../../presentation/common/date_filter/domain/date_filter_selection.dart';
import '../../../../presentation/common/date_filter/domain/date_filter_selection_mode.dart';
import '../../../../presentation/common/date_filter/widgets/date_filter_sheet.dart';
import '../../../../presentation/common/formatting/localized_formatters_context.dart';
import '../application/i18n/report_l10n.dart';
import '../controllers/report_controller.dart';
import '../l10n/generated/report_localizations.dart';
import '../models/report_period.dart';
import '../runtime/report_plugin_runtime.dart';
import '../runtime/report_runtime_cache.dart';
import '../widgets/report_body.dart';

class ReportPage extends StatefulWidget {
  const ReportPage({super.key});

  @override
  State<ReportPage> createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> {
  ReportController? _controller;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final existing = _controller;
    if (existing != null) {
      unawaited(existing.updateLocale(context.reportL10n));
      return;
    }
    final services = context.read<PluginServiceRegistry>();
    final runtimeManager = context.read<PluginRuntimeManager>();
    unawaited(
      runtimeManager.resume(ReportPluginRuntime.id),
    );
    _controller = ReportController(
      changeSignal: services.get<Listenable>(),
      runtimeCache: services.get<ReportRuntimeCache>(),
      runtime: services.get<ReportPluginRuntime>(),
      runtimeContext: runtimeManager.context,
    );
    unawaited(_controller!.updateLocale(context.reportL10n));
    _controller!.load();
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = _controller;
    if (controller == null) {
      return const Scaffold(
        backgroundColor: AppColors.bg,
        body: Center(
          child: CircularProgressIndicator(color: AppColors.green),
        ),
      );
    }
    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        final viewModel = controller.viewModel;
        if (viewModel == null) {
          return const Scaffold(
            backgroundColor: AppColors.bg,
            body: Center(
              child: CircularProgressIndicator(color: AppColors.green),
            ),
          );
        }
        return ReportBody(
          viewModel: viewModel,
          loading: controller.loading,
          exporting: controller.exporting,
          onDateFilterPressed: _showDateFilter,
          onRefresh: controller.load,
          onToggleSection: controller.toggleSection,
          onExport: controller.export,
        );
      },
    );
  }

  Future<void> _showDateFilter() async {
    final controller = _controller;
    if (controller == null) return;
    final l10n = context.reportL10n;
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final result = await showModalBottomSheet<DateFilterSelection>(
      context: context,
      isScrollControlled: true,
      enableDrag: false,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return DateFilterSheet(
          initialSelection: controller.dateSelection,
          readingCounts: controller.dayReadingCounts,
          presets: _reportPresets(l10n),
          today: today,
          formatters: context.appFormatters,
          title: l10n.dateFilterTitle,
          subtitle: l10n.dateFilterSubtitle,
          applyLabel: l10n.dateFilterApply,
          resetLabel: l10n.dateFilterReset,
          cancelLabel: l10n.dateFilterCancel,
          selectedDatesLabel: l10n.dateFilterSelectedDates,
          dayLabel: l10n.dateFilterDay,
          daysLabel: l10n.dateFilterDays,
          readingsLabel: l10n.dateFilterReadings,
          dragHintLabel: l10n.dateFilterDragHint,
          selectionMode: DateFilterSelectionMode.singleOrRange,
        );
      },
    );
    if (result == null || !mounted) return;
    await controller.selectDateRange(result);
  }

  List<DateFilterPreset> _reportPresets(ReportLocalizations l10n) {
    return [
      _periodPreset(ReportPeriod.days14, l10n.windowShortLast14Days),
      _periodPreset(ReportPeriod.days30, l10n.windowShortLast30Days),
      _periodPreset(ReportPeriod.days90, l10n.windowShortLast90Days),
    ];
  }

  DateFilterPreset _periodPreset(ReportPeriod period, String label) {
    return DateFilterPreset(
      id: period.label,
      label: label,
      resolve: (now) {
        final today = DateTime(now.year, now.month, now.day);
        return DateFilterSelection(
          start: today.subtract(Duration(days: period.days - 1)),
          end: today,
        );
      },
    );
  }
}
