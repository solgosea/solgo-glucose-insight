import '../../../application/glucose_unit/glucose_unit_format_service.dart';
import '../../../domain/entities/app_settings.dart';
import '../../../domain/entities/glucose_reading.dart';
import '../domain/glance_freshness.dart';
import '../domain/glance_range_state.dart';
import '../domain/glance_snapshot.dart';

class GlanceSnapshotBuilder {
  final GlucoseUnitFormatService formatter;

  const GlanceSnapshotBuilder({
    this.formatter = const GlucoseUnitFormatService(),
  });

  GlanceSnapshot build({
    required String subjectId,
    required AppSettings settings,
    required GlucoseReading? latest,
    required List<GlucoseReading> trendReadings,
    required DateTime now,
    String sourceLabel = 'Solgo Insight',
  }) {
    final display =
        latest == null ? null : formatter.value(latest.value, settings.unit);
    final alternateUnit = settings.unit == GlucoseUnit.mmolL
        ? GlucoseUnit.mgDl
        : GlucoseUnit.mmolL;
    final alternate =
        latest == null ? null : formatter.value(latest.value, alternateUnit);
    final delta = _deltaLabel(trendReadings, settings.unit);
    final freshness = GlanceFreshness.evaluate(
      updatedAt: latest?.timestamp,
      now: now,
    );
    return GlanceSnapshot(
      generatedAt: now,
      subjectId: subjectId,
      latestReading: latest,
      trendReadings: trendReadings,
      unit: settings.unit,
      valueLabel: display?.valueLabel ?? '--',
      alternateValueLabel: alternate?.fullLabel ?? '--',
      unitLabel: display?.unitLabel ?? formatter.unitLabel(settings.unit),
      deltaLabel: delta,
      trendArrow: latest?.trendArrow ?? '\u2192',
      sourceLabel: sourceLabel,
      freshness: freshness,
      rangeState: _rangeState(latest, settings, freshness),
      targetLowMmol: settings.lowThreshold,
      targetHighMmol: settings.highThreshold,
    );
  }

  GlanceRangeState _rangeState(
    GlucoseReading? latest,
    AppSettings settings,
    GlanceFreshness freshness,
  ) {
    if (latest == null) return GlanceRangeState.unknown;
    if (freshness.isStale) return GlanceRangeState.stale;
    if (latest.value < settings.lowThreshold) return GlanceRangeState.low;
    if (latest.value > settings.highThreshold) return GlanceRangeState.high;
    return GlanceRangeState.inRange;
  }

  String _deltaLabel(List<GlucoseReading> readings, GlucoseUnit unit) {
    if (readings.length < 2) return '+0.0';
    final latest = readings.last.value;
    final previous = readings.reversed
        .skip(1)
        .firstWhere((reading) => reading.timestamp != readings.last.timestamp)
        .value;
    final delta = latest - previous;
    final display = formatter.value(delta.abs(), unit).valueLabel;
    final sign = delta >= 0 ? '+' : '-';
    return '$sign$display';
  }
}
