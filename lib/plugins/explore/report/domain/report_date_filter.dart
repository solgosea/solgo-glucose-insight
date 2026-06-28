import 'package:smart_xdrip/presentation/common/date_filter/domain/date_filter_selection.dart';

import '../models/report_period.dart';

class ReportDateFilter {
  final DateFilterSelection selection;
  final ReportPeriod? period;

  const ReportDateFilter({
    required this.selection,
    required this.period,
  });

  factory ReportDateFilter.defaultValue(DateTime now) {
    final today = DateTime(now.year, now.month, now.day);
    return ReportDateFilter(
      selection: DateFilterSelection(
        start: today.subtract(Duration(days: ReportPeriod.days30.days - 1)),
        end: today,
      ),
      period: ReportPeriod.days30,
    );
  }

  int get displayDays => selection.end.difference(selection.start).inDays + 1;

  String get windowKey => period?.label ?? 'custom';

  bool get isPresetWindow => period != null && period!.days == displayDays;

  ReportDateFilter copyWithSelection(DateFilterSelection next) {
    return ReportDateFilter(
      selection: next,
      period: _periodFor(next),
    );
  }

  static ReportPeriod? _periodFor(DateFilterSelection selection) {
    final days = selection.end.difference(selection.start).inDays + 1;
    for (final period in ReportPeriod.values) {
      if (period.days == days) return period;
    }
    return null;
  }
}
