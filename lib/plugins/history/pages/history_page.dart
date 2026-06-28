import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:smart_xdrip/foundation/theme/app_colors.dart';
import 'package:smart_xdrip/plugin_platform/runtime/manager/plugin_runtime_manager.dart';
import 'package:smart_xdrip/plugin_platform/services/plugin_service_registry.dart';
import 'package:smart_xdrip/presentation/common/date_filter/domain/date_filter_selection.dart';
import 'package:smart_xdrip/presentation/common/date_filter/domain/date_filter_selection_mode.dart';
import 'package:smart_xdrip/presentation/common/date_filter/widgets/date_filter_sheet.dart';
import 'package:smart_xdrip/presentation/common/formatting/localized_formatters_context.dart';
import '../controllers/history_controller.dart';
import '../application/i18n/history_l10n.dart';
import '../application/history_host_services.dart';
import '../runtime/history_plugin_runtime.dart';
import '../runtime/history_runtime_cache.dart';
import '../widgets/history_body.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  late final HistoryController _controller;
  bool _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_initialized) {
      _controller.updateLocale(context.historyL10n);
      return;
    }
    _initialized = true;
    final services = context.read<PluginServiceRegistry>();
    final runtimeManager = context.read<PluginRuntimeManager>();
    unawaited(runtimeManager.resume(HistoryPluginRuntime.id));
    _controller = HistoryController(
      hostServices: services.get<HistoryHostServices>(),
      runtimeCache: services.get<HistoryRuntimeCache>(),
      runtime: services.get<HistoryPluginRuntime>(),
    );
    _controller.updateLocale(context.historyL10n);
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
          return HistoryBody(
            viewModel: viewModel,
            onPreviousDay: _controller.prevDay,
            onNextDay: _controller.nextDay,
            onTimeSelected: _controller.selectTimeFilter,
            onClearTimeFilter: _controller.clearTimeFilter,
            onDateFilterPressed: _showDateFilter,
            onRouteSelected: context.push,
          );
        },
      ),
    );
  }

  Future<void> _showDateFilter() async {
    final l10n = context.historyL10n;
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
          presets: const [],
          today: DateTime(today.year, today.month, today.day),
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
          selectionMode: DateFilterSelectionMode.singleDay,
        );
      },
    );
    if (result == null) return;
    _controller.selectDateRange(result);
  }
}
