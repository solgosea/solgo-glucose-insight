import 'package:flutter/material.dart';
import 'package:smart_xdrip/application/i18n/app_formatters.dart';
import 'package:smart_xdrip/domain/time/date_range_granularity.dart';

import '../../../../foundation/theme/app_colors.dart';
import '../application/date_filter_month_builder.dart';
import '../domain/date_filter_preset.dart';
import '../domain/date_filter_selection.dart';
import '../domain/date_filter_selection_mode.dart';
import 'date_filter_calendar_grid.dart';
import 'date_filter_preset_row.dart';

class DateFilterSheet extends StatefulWidget {
  final DateFilterSelection initialSelection;
  final Map<DateTime, int> readingCounts;
  final List<DateFilterPreset> presets;
  final DateTime today;
  final AppFormatters formatters;
  final String title;
  final String subtitle;
  final String applyLabel;
  final String resetLabel;
  final String cancelLabel;
  final String selectedDatesLabel;
  final String dayLabel;
  final String daysLabel;
  final String readingsLabel;
  final String dragHintLabel;
  final DateFilterSelectionMode selectionMode;

  const DateFilterSheet({
    super.key,
    required this.initialSelection,
    required this.readingCounts,
    required this.presets,
    required this.today,
    required this.formatters,
    required this.title,
    required this.subtitle,
    required this.applyLabel,
    required this.resetLabel,
    required this.cancelLabel,
    required this.selectedDatesLabel,
    required this.dayLabel,
    required this.daysLabel,
    required this.readingsLabel,
    required this.dragHintLabel,
    this.selectionMode = DateFilterSelectionMode.singleOrRange,
  });

  @override
  State<DateFilterSheet> createState() => _DateFilterSheetState();
}

class _DateFilterSheetState extends State<DateFilterSheet> {
  late DateFilterSelection _selection;
  late DateTime _visibleMonth;
  final _monthBuilder = const DateFilterMonthBuilder();

  @override
  void initState() {
    super.initState();
    _selection = widget.initialSelection;
    _visibleMonth = DateTime(_selection.start.year, _selection.start.month);
  }

  @override
  Widget build(BuildContext context) {
    final days = _monthBuilder.build(
      month: _visibleMonth,
      readingCounts: widget.readingCounts,
      maxDate: widget.today,
    );
    return SafeArea(
      top: false,
      child: Align(
        alignment: Alignment.bottomCenter,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 430),
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFA1D2D26), Color(0xFC101A15)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(24),
              ),
              border: Border.all(color: AppColors.borderMid),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.38),
                  blurRadius: 48,
                  offset: const Offset(0, -20),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 10, 16, 18),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: AppColors.textSoft.withValues(alpha: 0.28),
                      borderRadius: BorderRadius.circular(999),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 12, 0, 12),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.title,
                                style: const TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 17,
                                  fontWeight: FontWeight.w800,
                                  color: AppColors.text,
                                ),
                              ),
                              const SizedBox(height: 3),
                              Text(
                                widget.subtitle,
                                style: const TextStyle(
                                  fontFamily: 'JetBrainsMono',
                                  fontSize: 10,
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.textDim,
                                  letterSpacing: 0.6,
                                ),
                              ),
                            ],
                          ),
                        ),
                        _IconAction(
                          icon: Icons.close_rounded,
                          onTap: () => Navigator.of(context).pop(),
                        ),
                      ],
                    ),
                  ),
                  DateFilterPresetRow(
                    presets: widget.presets,
                    selection: _selection,
                    now: widget.today,
                    onSelected: (selection) => setState(() {
                      _selection = selection;
                      _visibleMonth =
                          DateTime(selection.start.year, selection.start.month);
                    }),
                  ),
                  const SizedBox(height: 13),
                  if (widget.selectionMode ==
                      DateFilterSelectionMode.singleOrRange) ...[
                    _DragHint(label: widget.dragHintLabel),
                    const SizedBox(height: 11),
                  ],
                  Padding(
                    padding: EdgeInsets.zero,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(18),
                        gradient: LinearGradient(
                          colors: [
                            AppColors.bgCard2.withValues(alpha: 0.55),
                            AppColors.bg.withValues(alpha: 0.50),
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                        border: Border.all(color: AppColors.border),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.white.withValues(alpha: 0.04),
                            blurRadius: 0,
                            offset: const Offset(0, 1),
                          ),
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.36),
                            blurRadius: 18,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        child: Column(
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 12),
                              child: Row(
                                children: [
                                  _IconAction(
                                    icon: Icons.chevron_left_rounded,
                                    onTap: _previousMonth,
                                  ),
                                  Expanded(
                                    child: Text(
                                      _monthLabel(_visibleMonth),
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                        fontFamily: 'Inter',
                                        fontSize: 14,
                                        fontWeight: FontWeight.w800,
                                        color: AppColors.text,
                                      ),
                                    ),
                                  ),
                                  _IconAction(
                                    icon: Icons.chevron_right_rounded,
                                    onTap: _canGoNext ? _nextMonth : null,
                                    dim: !_canGoNext,
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 10),
                            DateFilterCalendarGrid(
                              days: days,
                              selection: _selection,
                              weekdayLabels: _weekdayLabels(),
                              today: widget.today,
                              selectionMode: widget.selectionMode,
                              onSelectionChanged: (selection) =>
                                  setState(() => _selection = selection),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  _SelectionSummary(
                    label: widget.selectedDatesLabel,
                    value: _selectionLabel(_selection),
                    meta: _selectionMeta(_selection),
                  ),
                  Padding(
                    padding: EdgeInsets.zero,
                    child: Row(
                      children: [
                        Expanded(
                          flex: 96,
                          child: OutlinedButton(
                            onPressed: () => setState(() {
                              _selection =
                                  DateFilterSelection.single(widget.today);
                              _visibleMonth = DateTime(
                                  widget.today.year, widget.today.month);
                            }),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: AppColors.textSoft,
                              side: const BorderSide(color: AppColors.border),
                              minimumSize: const Size.fromHeight(44),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(13),
                              ),
                              backgroundColor:
                                  AppColors.textSoft.withValues(alpha: 0.08),
                            ),
                            child: Text(widget.resetLabel),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          flex: 220,
                          child: FilledButton(
                            onPressed: () =>
                                Navigator.of(context).pop(_selection),
                            style: FilledButton.styleFrom(
                              backgroundColor: AppColors.green,
                              foregroundColor: const Color(0xFF07120D),
                              minimumSize: const Size.fromHeight(44),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(13),
                              ),
                              textStyle: const TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 13,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            child: Text(widget.applyLabel),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _previousMonth() {
    setState(() {
      _visibleMonth = DateTime(_visibleMonth.year, _visibleMonth.month - 1);
    });
  }

  void _nextMonth() {
    if (!_canGoNext) return;
    setState(() {
      _visibleMonth = DateTime(_visibleMonth.year, _visibleMonth.month + 1);
    });
  }

  bool get _canGoNext {
    final current = DateTime(widget.today.year, widget.today.month);
    return _visibleMonth.isBefore(current);
  }

  String _monthLabel(DateTime month) {
    return widget.formatters.dateRange(
      month,
      month,
      granularity: DateRangeGranularity.month,
    );
  }

  String _selectionLabel(DateFilterSelection selection) {
    if (selection.isSingleDay) {
      return widget.formatters.dateFull(selection.start);
    }
    return widget.formatters.dateRange(selection.start, selection.end);
  }

  String _selectionMeta(DateFilterSelection selection) {
    final days = selection.end.difference(selection.start).inDays + 1;
    var readings = 0;
    for (var i = 0; i < days; i++) {
      final day = selection.start.add(Duration(days: i));
      readings +=
          widget.readingCounts[DateTime(day.year, day.month, day.day)] ?? 0;
    }
    final dayWord = days == 1 ? widget.dayLabel : widget.daysLabel;
    return '$days $dayWord\n$readings ${widget.readingsLabel}';
  }

  List<String> _weekdayLabels() {
    final base = DateTime(2024, 1, 1);
    return List.generate(
      7,
      (index) => widget.formatters.dateTime.weekdayShort(
        base.add(Duration(days: index)),
      ),
    );
  }
}

class _DragHint extends StatelessWidget {
  final String label;

  const _DragHint({required this.label});

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.blue.withValues(alpha: 0.07),
        borderRadius: BorderRadius.circular(13),
        border: Border.all(color: AppColors.blue.withValues(alpha: 0.18)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 9),
        child: Row(
          children: [
            const Icon(
              Icons.swipe_rounded,
              size: 15,
              color: AppColors.blue,
            ),
            const SizedBox(width: 7),
            Expanded(
              child: Text(
                label,
                style: const TextStyle(
                  fontFamily: 'JetBrainsMono',
                  fontSize: 10,
                  height: 1.35,
                  color: AppColors.textSoft,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SelectionSummary extends StatelessWidget {
  final String label;
  final String value;
  final String meta;

  const _SelectionSummary({
    required this.label,
    required this.value,
    required this.meta,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 12),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
      decoration: BoxDecoration(
        color: AppColors.green.withValues(alpha: 0.07),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.green.withValues(alpha: 0.18)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontFamily: 'JetBrainsMono',
                    fontSize: 9,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textDim,
                    letterSpacing: 1,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  value,
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                    color: AppColors.text,
                  ),
                ),
              ],
            ),
          ),
          Text(
            meta,
            textAlign: TextAlign.right,
            style: const TextStyle(
              fontFamily: 'JetBrainsMono',
              fontSize: 10,
              fontWeight: FontWeight.w800,
              height: 1.45,
              color: AppColors.green,
            ),
          ),
        ],
      ),
    );
  }
}

class _IconAction extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;
  final bool dim;

  const _IconAction({
    required this.icon,
    required this.onTap,
    this.dim = false,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: SizedBox(
          width: 36,
          height: 36,
          child: Icon(
            icon,
            size: 20,
            color: dim ? AppColors.textDim : AppColors.textSoft,
          ),
        ),
      ),
    );
  }
}
