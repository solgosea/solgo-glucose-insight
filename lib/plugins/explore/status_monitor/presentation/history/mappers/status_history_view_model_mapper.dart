import '../../../domain/component_health.dart';
import '../../../domain/history/status_component_history_load_result.dart';
import '../../../domain/history/status_component_history_load_state.dart';
import '../../../domain/history/status_component_history_result.dart';
import '../../../domain/history/status_history_bucket.dart';
import '../../../domain/history/status_history_bucket_reason.dart';
import '../../../domain/status_component_kind.dart';
import '../../../domain/status_report.dart';
import '../../../domain/status_level.dart';
import '../../../application/i18n/status_monitor_l10n_resolver.dart';
import '../../../l10n/generated/status_monitor_localizations.dart';
import '../models/status_component_history_view_model.dart';
import '../models/status_component_history_section_view_model.dart';
import '../models/status_history_cell_view_model.dart';
import '../models/status_history_view_model.dart';

class StatusHistoryViewModelMapper {
  final StatusMonitorLocalizations? l10n;

  const StatusHistoryViewModelMapper({this.l10n});

  StatusMonitorLocalizations get _strings =>
      l10n ?? StatusMonitorL10nResolver.fallback;

  StatusHistoryViewModel mapProgressive({
    required StatusReport? report,
    required Map<StatusComponentKind, StatusComponentHistoryLoadResult> loads,
    required DateTime now,
    bool loading = false,
  }) {
    final components = report?.components ?? const <ComponentHealth>[];
    return StatusHistoryViewModel(
      title: _strings.pageSevenDayHistory,
      subtitle: _strings.pageSevenDayHistorySubtitle,
      loading: loading,
      sections: [
        for (final component in components)
          _section(
            component: component,
            load: loads[component.kind],
            now: now,
          ),
      ],
    );
  }

  StatusComponentHistorySectionViewModel _section({
    required ComponentHealth component,
    required StatusComponentHistoryLoadResult? load,
    required DateTime now,
  }) {
    final state = load?.state ?? StatusComponentHistoryLoadState.queued;
    final result = load?.result;
    return StatusComponentHistorySectionViewModel(
      component: component.kind,
      title: _componentTitle(component),
      currentLevel: component.level,
      state: state,
      history: result == null ? null : _component(component, result, now),
      errorMessage: load?.error?.toString(),
    );
  }

  StatusComponentHistoryViewModel _component(
    ComponentHealth component,
    StatusComponentHistoryResult? history,
    DateTime now,
  ) {
    final days = _lastSevenDayStarts(now);
    return StatusComponentHistoryViewModel(
      component: component.kind,
      title: component.title,
      currentLevel: component.level,
      coverage: history?.coverage ?? 0,
      dailyCells: [
        for (var i = 0; i < days.length; i++)
          _cell(
            bucket: _bucketAt(history?.dailyBuckets, i),
            at: days[i],
            label: _dayLabel(days[i], now),
          ),
      ],
      hourlyRows: [
        for (var dayIndex = 0; dayIndex < days.length; dayIndex++)
          [
            for (var hour = 0; hour < 24; hour++)
              _cell(
                bucket:
                    _bucketAt(_rowAt(history?.hourlyBuckets, dayIndex), hour),
                at: _dateTime(
                  now,
                  days[dayIndex].year,
                  days[dayIndex].month,
                  days[dayIndex].day,
                  hour,
                ),
                label: _dayLabel(days[dayIndex], now),
              ),
          ],
      ],
    );
  }

  String _componentTitle(ComponentHealth component) => component.title;

  StatusHistoryCellViewModel _cell({
    required StatusHistoryBucket? bucket,
    required DateTime at,
    required String label,
  }) {
    return StatusHistoryCellViewModel(
      at: bucket?.start ?? at,
      label: label,
      level: bucket?.level ?? StatusLevel.unknown,
      score: bucket?.score,
      reason: bucket?.reason ?? StatusHistoryBucketReason.noSample,
      reasonLabel: _reasonLabel(
        bucket?.reason ?? StatusHistoryBucketReason.noSample,
      ),
      summary: bucket?.summary ?? '',
    );
  }

  String _reasonLabel(StatusHistoryBucketReason reason) {
    return switch (reason) {
      StatusHistoryBucketReason.recordedSample =>
        _strings.pageHistoryReasonRecordedSample,
      StatusHistoryBucketReason.carriedForward =>
        _strings.pageHistoryReasonCarriedForward,
      StatusHistoryBucketReason.noSample => _strings.pageHistoryReasonNoSample,
      StatusHistoryBucketReason.future => _strings.pageHistoryReasonFuture,
    };
  }

  List<StatusHistoryBucket>? _rowAt(
    List<List<StatusHistoryBucket>>? rows,
    int index,
  ) {
    if (rows == null || index < 0 || index >= rows.length) return null;
    return rows[index];
  }

  StatusHistoryBucket? _bucketAt(
    List<StatusHistoryBucket>? buckets,
    int index,
  ) {
    if (buckets == null || index < 0 || index >= buckets.length) return null;
    return buckets[index];
  }

  List<DateTime> _lastSevenDayStarts(DateTime now) {
    final today = _dateTime(now, now.year, now.month, now.day);
    return [
      for (var i = 6; i >= 0; i--) today.subtract(Duration(days: i)),
    ];
  }

  DateTime _dateTime(
    DateTime basis,
    int year,
    int month,
    int day, [
    int hour = 0,
  ]) {
    return basis.isUtc
        ? DateTime.utc(year, month, day, hour)
        : DateTime(year, month, day, hour);
  }

  String _dayLabel(DateTime day, DateTime now) {
    if (day.year == now.year && day.month == now.month && day.day == now.day) {
      return _strings.pageToday;
    }
    return '${_month(day.month)} ${day.day}';
  }

  String _month(int month) {
    final labels = [
      _strings.pageMonthJan,
      _strings.pageMonthFeb,
      _strings.pageMonthMar,
      _strings.pageMonthApr,
      _strings.pageMonthMay,
      _strings.pageMonthJun,
      _strings.pageMonthJul,
      _strings.pageMonthAug,
      _strings.pageMonthSep,
      _strings.pageMonthOct,
      _strings.pageMonthNov,
      _strings.pageMonthDec,
    ];
    return labels[(month - 1).clamp(0, 11)];
  }
}
