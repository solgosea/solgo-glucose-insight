import 'package:flutter/material.dart';

import '../domain/date_filter_day_bucket.dart';
import '../domain/date_filter_selection.dart';
import '../domain/date_filter_selection_mode.dart';
import 'date_filter_day_cell.dart';

class DateFilterCalendarGrid extends StatefulWidget {
  final List<DateFilterDayBucket> days;
  final DateFilterSelection selection;
  final ValueChanged<DateFilterSelection> onSelectionChanged;
  final List<String> weekdayLabels;
  final DateTime today;
  final DateFilterSelectionMode selectionMode;

  const DateFilterCalendarGrid({
    super.key,
    required this.days,
    required this.selection,
    required this.onSelectionChanged,
    required this.weekdayLabels,
    required this.today,
    this.selectionMode = DateFilterSelectionMode.singleOrRange,
  });

  @override
  State<DateFilterCalendarGrid> createState() => _DateFilterCalendarGridState();
}

class _DateFilterCalendarGridState extends State<DateFilterCalendarGrid> {
  final List<GlobalKey> _cellKeys = [];
  DateTime? _dragStart;

  @override
  void didUpdateWidget(covariant DateFilterCalendarGrid oldWidget) {
    super.didUpdateWidget(oldWidget);
    _syncKeys();
  }

  @override
  void initState() {
    super.initState();
    _syncKeys();
  }

  @override
  Widget build(BuildContext context) {
    final firstWeekday =
        widget.days.isEmpty ? 1 : widget.days.first.date.weekday;
    final leading = firstWeekday - 1;
    final cells = <Widget>[
      for (var i = 0; i < leading; i++) const SizedBox(height: 50),
      for (var i = 0; i < widget.days.length; i++)
        DateFilterDayCell(
          key: _cellKeys[i],
          bucket: widget.days[i],
          selected: _isSelected(widget.days[i].date),
          inRange: _isInRangeBody(widget.days[i].date),
          rangeStart: widget.selection.isStart(widget.days[i].date),
          rangeEnd: widget.selection.isEnd(widget.days[i].date),
          today: _sameDay(widget.days[i].date, widget.today),
          onTap: () => _selectSingle(widget.days[i].date),
        ),
    ];
    return Listener(
      behavior: HitTestBehavior.opaque,
      onPointerDown: (event) => _startDrag(event.position),
      onPointerMove: (event) => _updateDrag(event.position),
      onPointerUp: (_) => _dragStart = null,
      onPointerCancel: (_) => _dragStart = null,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 11),
        child: Column(
          children: [
            Row(
              children: [
                for (final label in widget.weekdayLabels)
                  Expanded(
                    child: Text(
                      label,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontFamily: 'JetBrainsMono',
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF4D7264),
                        letterSpacing: 0.6,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 7),
            const Divider(height: 1, thickness: 1, color: Color(0x246EE89E)),
            const SizedBox(height: 8),
            GridView.count(
              crossAxisCount: 7,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: 5,
              crossAxisSpacing: 5,
              childAspectRatio: 0.95,
              children: cells,
            ),
          ],
        ),
      ),
    );
  }

  void _syncKeys() {
    while (_cellKeys.length < widget.days.length) {
      _cellKeys.add(GlobalKey());
    }
    if (_cellKeys.length > widget.days.length) {
      _cellKeys.removeRange(widget.days.length, _cellKeys.length);
    }
  }

  void _selectSingle(DateTime day) {
    widget.onSelectionChanged(DateFilterSelection.single(day));
  }

  void _startDrag(Offset globalPosition) {
    final day = _dateAt(globalPosition);
    if (day == null) return;
    _dragStart = day;
    widget.onSelectionChanged(DateFilterSelection.single(day));
  }

  void _updateDrag(Offset globalPosition) {
    if (widget.selectionMode == DateFilterSelectionMode.singleDay) return;
    final start = _dragStart;
    if (start == null) return;
    final end = _dateAt(globalPosition);
    if (end == null) return;
    widget.onSelectionChanged(DateFilterSelection(start: start, end: end));
  }

  DateTime? _dateAt(Offset globalPosition) {
    for (var i = 0; i < widget.days.length; i++) {
      final bucket = widget.days[i];
      if (bucket.disabled) continue;
      final context = _cellKeys[i].currentContext;
      if (context == null) continue;
      final box = context.findRenderObject() as RenderBox?;
      if (box == null || !box.hasSize) continue;
      final local = box.globalToLocal(globalPosition);
      if ((Offset.zero & box.size).contains(local)) return bucket.date;
    }
    return null;
  }

  bool _isSelected(DateTime day) {
    return widget.selection.isSingleDay && widget.selection.isStart(day);
  }

  bool _isInRangeBody(DateTime day) {
    if (widget.selection.isSingleDay) return false;
    return widget.selection.contains(day) &&
        !widget.selection.isStart(day) &&
        !widget.selection.isEnd(day);
  }

  bool _sameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;
}
