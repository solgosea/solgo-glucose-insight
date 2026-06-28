import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_xdrip/foundation/theme/app_colors.dart';
import 'package:smart_xdrip/plugin_platform/runtime/manager/plugin_runtime_manager.dart';
import 'package:smart_xdrip/plugin_platform/services/plugin_service_registry.dart';
import 'package:smart_xdrip/presentation/common/date_filter/domain/date_filter_preset.dart';
import 'package:smart_xdrip/presentation/common/date_filter/domain/date_filter_selection.dart';
import 'package:smart_xdrip/presentation/common/date_filter/domain/date_filter_selection_mode.dart';
import 'package:smart_xdrip/presentation/common/date_filter/widgets/date_filter_sheet.dart';
import 'package:smart_xdrip/presentation/common/formatting/localized_formatters_context.dart';
import '../application/i18n/statistics_l10n.dart';
import '../application/statistics_host_services.dart';
import '../controllers/statistics_controller.dart';
import '../runtime/statistics_plugin_runtime.dart';
import '../runtime/statistics_runtime_cache.dart';
import '../widgets/statistics_body.dart';

class StatisticsPage extends StatefulWidget {
  const StatisticsPage({super.key});

  @override
  State<StatisticsPage> createState() => _StatisticsPageState();
}

class _StatisticsPageState extends State<StatisticsPage> {
  late final StatisticsController _controller;
  bool _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_initialized) {
      _controller.updateLocale(context.statisticsL10n);
      return;
    }
    _initialized = true;
    final services = context.read<PluginServiceRegistry>();
    final runtimeManager = context.read<PluginRuntimeManager>();
    unawaited(runtimeManager.resume(StatisticsPluginRuntime.id));
    _controller = StatisticsController(
      hostServices: services.get<StatisticsHostServices>(),
      runtimeCache: services.get<StatisticsRuntimeCache>(),
      runtime: services.get<StatisticsPluginRuntime>(),
    );
    _controller.updateLocale(context.statisticsL10n);
    unawaited(_controller.init());
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: ListenableBuilder(
        listenable: _controller,
        builder: (context, _) {
          final viewModel = _controller.viewModel;
          if (viewModel == null) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.green),
            );
          }
          return StatisticsBody(
            viewModel: viewModel,
            onDateFilterPressed: _showDateFilter,
          );
        },
      ),
    );
  }

  Future<void> _showDateFilter() async {
    final l10n = context.statisticsL10n;
    final formatters = context.appFormatters;
    final result = await showModalBottomSheet<DateFilterSelection>(
      context: context,
      isScrollControlled: true,
      enableDrag: false,
      backgroundColor: Colors.transparent,
      builder: (context) {
        final today = DateTime.now();
        return DateFilterSheet(
          initialSelection: _controller.dateSelection,
          readingCounts: _controller.dayReadingCounts,
          presets: _statisticsPresets(l10n),
          today: DateTime(today.year, today.month, today.day),
          formatters: formatters,
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
    if (result == null) return;
    if (!mounted) return;
    _controller.selectDateRange(
      result,
      rangeLabel: result.isSingleDay
          ? formatters.dateFull(result.start)
          : formatters.dateRange(result.start, result.end),
    );
  }

  List<DateFilterPreset> _statisticsPresets(dynamic l10n) {
    return [
      _daysPreset('24h', l10n.windowShortLast24Hours, 1),
      _daysPreset('3d', l10n.windowShortLast3Days, 3),
      _daysPreset('7d', l10n.windowShortLast7Days, 7),
      _daysPreset('14d', l10n.windowShortLast14Days, 14),
      _daysPreset('30d', l10n.windowShortLast30Days, 30),
      _daysPreset('90d', l10n.windowShortLast90Days, 90),
    ];
  }

  DateFilterPreset _daysPreset(String id, String label, int days) {
    return DateFilterPreset(
      id: id,
      label: label,
      resolve: (now) {
        final today = DateTime(now.year, now.month, now.day);
        return DateFilterSelection(
          start: today.subtract(Duration(days: days - 1)),
          end: today,
        );
      },
    );
  }
}
