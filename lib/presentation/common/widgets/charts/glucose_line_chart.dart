import 'dart:math';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import '../../../../application/glucose_unit/glucose_chart_unit_adapter.dart';
import '../../../../application/glucose_unit/glucose_unit_format_service.dart';
import '../../../../domain/entities/app_settings.dart';
import '../../../../domain/entities/glucose_reading.dart';
import '../../../../foundation/theme/app_colors.dart';

/// How the BG curve is colored.
/// - `single`: one solid green stroke (for Home / short windows).
/// - `byValue`: each segment colored by that point's value.
/// - `byEpisode`: green by default, recolored to rose/blue inside high/low
///   episode time ranges (for History / 24h day-view).
enum ChartColoringMode { single, byValue, byEpisode }

/// Threshold line styling.
/// - `subtle`: both lines dim green-grey, suited to focused Home view.
/// - `colored`: high line rose, low line blue for clearer 24h overview.
enum ThresholdLineMode { subtle, colored }

/// X-axis label format.
/// - `hourMinute`: "05:40" (small windows where minutes matter).
/// - `hourOnly`: "00" / "04" / "08" (24h overview where minutes are noise).
enum XLabelMode { hourMinute, hourOnly }

/// A time range painted on the chart for episode-aware coloring.
class ChartEpisode {
  final DateTime start;
  final DateTime end;
  final Color color;
  const ChartEpisode({
    required this.start,
    required this.end,
    required this.color,
  });
}

/// A single event marker drawn as a dashed vertical line + bottom dot.
class ChartEventMarker {
  final DateTime time;
  final Color color;
  const ChartEventMarker({required this.time, required this.color});
}

class GlucoseLineChart extends StatelessWidget {
  final List<GlucoseReading> readings;
  final double low;
  final double high;
  final GlucoseUnit unit;
  final double height;
  final bool showCurrentDot;

  final ChartColoringMode coloringMode;
  final ThresholdLineMode thresholdLineMode;
  final XLabelMode xLabelMode;
  final int xLabelCount;
  final bool showMidYLabel;
  final List<ChartEpisode> episodes;
  final List<ChartEventMarker> markers;

  const GlucoseLineChart({
    super.key,
    required this.readings,
    this.low = 3.9,
    this.high = 10.0,
    this.unit = GlucoseUnit.mmolL,
    this.height = 160,
    this.showCurrentDot = true,
    this.coloringMode = ChartColoringMode.single,
    this.thresholdLineMode = ThresholdLineMode.subtle,
    this.xLabelMode = XLabelMode.hourMinute,
    this.xLabelCount = 5,
    this.showMidYLabel = false,
    this.episodes = const [],
    this.markers = const [],
  });

  @override
  Widget build(BuildContext context) {
    if (readings.isEmpty) {
      return SizedBox(
        height: height,
        child: const Center(
          child: Text(
            'No CGM data',
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 12,
              color: AppColors.textDim,
            ),
          ),
        ),
      );
    }
    return SizedBox(
      height: height,
      child: CustomPaint(
        painter: _GlucosePainter(
          readings: readings,
          low: low,
          high: high,
          unit: unit,
          showCurrentDot: showCurrentDot,
          coloringMode: coloringMode,
          thresholdLineMode: thresholdLineMode,
          xLabelMode: xLabelMode,
          xLabelCount: xLabelCount,
          showMidYLabel: showMidYLabel,
          episodes: episodes,
          markers: markers,
        ),
        size: Size.infinite,
      ),
    );
  }
}

class _GlucosePainter extends CustomPainter {
  final List<GlucoseReading> readings;
  final double low, high;
  final GlucoseUnit unit;
  final bool showCurrentDot;
  final ChartColoringMode coloringMode;
  final ThresholdLineMode thresholdLineMode;
  final XLabelMode xLabelMode;
  final int xLabelCount;
  final bool showMidYLabel;
  final List<ChartEpisode> episodes;
  final List<ChartEventMarker> markers;
  final GlucoseChartUnitAdapter chartAdapter = const GlucoseChartUnitAdapter();
  final GlucoseUnitFormatService formatter = const GlucoseUnitFormatService();

  static const _padLeft = 28.0;
  static const _padRight = 14.0;
  static const _padBottom = 20.0;
  static const _padTop = 8.0;
  static const _axisLabel = Color(0xFF7AB898);

  _GlucosePainter({
    required this.readings,
    required this.low,
    required this.high,
    required this.unit,
    required this.showCurrentDot,
    required this.coloringMode,
    required this.thresholdLineMode,
    required this.xLabelMode,
    required this.xLabelCount,
    required this.showMidYLabel,
    required this.episodes,
    required this.markers,
  });

  List<GlucoseReading> get _displayReadings {
    return chartAdapter.readings(readings, unit);
  }

  double get _displayLow => chartAdapter.threshold(low, unit);

  double get _displayHigh => chartAdapter.threshold(high, unit);

  double get _minY => chartAdapter.minY(unit);

  double get _maxY => chartAdapter.maxY(unit);

  double _xByIndex(int i, double w) {
    final rows = _displayReadings;
    if (rows.length <= 1) return _padLeft;
    final usable = w - _padLeft - _padRight;
    return _padLeft + (i / (rows.length - 1)) * usable;
  }

  double _xByTime(DateTime t, double w) {
    final rows = _displayReadings;
    if (rows.length <= 1) return _padLeft;
    final first = rows.first.timestamp;
    final last = rows.last.timestamp;
    final total = last.difference(first).inSeconds;
    if (total <= 0) return _padLeft;
    final delta = t.difference(first).inSeconds.toDouble();
    final clamped = delta.clamp(0.0, total.toDouble());
    final usable = w - _padLeft - _padRight;
    return _padLeft + (clamped / total) * usable;
  }

  double _y(double v, double h) {
    final range = _maxY - _minY;
    final usable = h - _padBottom - _padTop;
    return _padTop + (1 - (v - _minY) / range) * usable;
  }

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width, h = size.height;
    final right = w - _padRight;
    final rows = _displayReadings;
    final displayLow = _displayLow;
    final displayHigh = _displayHigh;

    // 1. Target range band, clipped to the inner chart area.
    canvas.drawRect(
      Rect.fromLTRB(_padLeft, _y(displayHigh, h), right, _y(displayLow, h)),
      Paint()..color = AppColors.green.withOpacity(0.055),
    );

    // 2. Threshold dashed lines
    final highLineColor =
        thresholdLineMode == ThresholdLineMode.colored
            ? AppColors.rose.withOpacity(0.45)
            : const Color(0xFF4A7A64);
    final lowLineColor =
        thresholdLineMode == ThresholdLineMode.colored
            ? AppColors.blue.withOpacity(0.45)
            : const Color(0xFF4A7A64);
    _dashed(canvas, _y(displayHigh, h), _padLeft, right, highLineColor);
    _dashed(canvas, _y(displayLow, h), _padLeft, right, lowLineColor);

    // 3. Y-axis labels (high, low, optional mid 7.0)
    _yLabel(
      canvas,
      formatter.value(high, unit).valueLabel,
      _y(displayHigh, h) - 4,
    );
    _yLabel(
      canvas,
      formatter.value(low, unit).valueLabel,
      _y(displayLow, h) + 10,
    );
    if (showMidYLabel) {
      const mid = 7.0;
      final displayMid = chartAdapter.value(mid, unit);
      _yLabel(
        canvas,
        formatter.value(mid, unit).valueLabel,
        _y(displayMid, h) - 4,
      );
    }

    // 4. Event markers: dashed verticals and bottom dots.
    // Place dots inside the chart area, just above the X-axis label band,
    // so they never overlap with the time labels rendered at h - 16.
    final dotY = h - _padBottom - 4;
    for (final m in markers) {
      final mx = _xByTime(m.time, w);
      final p =
          Paint()
            ..color = m.color.withOpacity(0.30)
            ..strokeWidth = 0.75;
      double y = _padTop;
      while (y < h - _padBottom) {
        canvas.drawLine(
          Offset(mx, y),
          Offset(mx, min(y + 3, h - _padBottom)),
          p,
        );
        y += 6;
      }
      canvas.drawCircle(
        Offset(mx, dotY),
        4,
        Paint()..color = m.color.withOpacity(0.85),
      );
    }

    // 5. Build the curve path
    final curvePath = Path();
    for (int i = 0; i < rows.length; i++) {
      final px = _xByIndex(i, w);
      final py = _y(rows[i].value, h);
      if (i == 0) {
        curvePath.moveTo(px, py);
      } else {
        curvePath.lineTo(px, py);
      }
    }

    // 6. Gradient area fill (close the path to the inner-right edge,
    // not the full canvas width, so the fill doesn't bleed past the labels).
    final fillPath = Path()..addPath(curvePath, Offset.zero);
    fillPath.lineTo(right, h - _padBottom);
    fillPath.lineTo(_padLeft, h - _padBottom);
    fillPath.close();
    canvas.drawPath(
      fillPath,
      Paint()
        ..shader = ui.Gradient.linear(const Offset(0, _padTop), Offset(0, h), [
          AppColors.green.withOpacity(0.18),
          AppColors.green.withOpacity(0.0),
        ])
        ..style = PaintingStyle.fill,
    );

    // 6b. Episode-tinted overlays (rose for high, blue for low)
    if (coloringMode == ChartColoringMode.byEpisode) {
      for (final ep in episodes) {
        final x0 = _xByTime(ep.start, w);
        final x1 = _xByTime(ep.end, w);
        if (x1 <= x0) continue;
        canvas.save();
        canvas.clipRect(Rect.fromLTRB(x0, _padTop, x1, h - _padBottom));
        canvas.drawPath(
          fillPath,
          Paint()
            ..shader = ui.Gradient.linear(
              const Offset(0, _padTop),
              Offset(0, h),
              [ep.color.withOpacity(0.22), ep.color.withOpacity(0.0)],
            )
            ..style = PaintingStyle.fill,
        );
        canvas.restore();
      }
    }

    // 7. Draw the line stroke according to coloring mode
    _drawCurveStroke(canvas, w, h);

    // 8. X-axis labels
    if (readings.length > 1) {
      final first = readings.first.timestamp;
      final last = readings.last.timestamp;
      final totalMin = last.difference(first).inMinutes.toDouble();
      final segments = max(1, xLabelCount - 1);
      final usable = w - _padLeft - _padRight;
      for (int slot = 0; slot < xLabelCount; slot++) {
        final t = first.add(
          Duration(minutes: (totalMin * slot / segments).round()),
        );
        final px = _padLeft + (slot / segments) * usable;
        final hh = t.hour.toString().padLeft(2, '0');
        final mm = t.minute.toString().padLeft(2, '0');
        final label = xLabelMode == XLabelMode.hourMinute ? '$hh:$mm' : hh;
        final tp = TextPainter(
          text: TextSpan(
            text: label,
            style: const TextStyle(
              fontFamily: 'JetBrainsMono',
              fontSize: 8,
              color: _axisLabel,
            ),
          ),
          textDirection: TextDirection.ltr,
        )..layout();
        tp.paint(canvas, Offset(px - tp.width / 2, h - 16));
      }
    }

    // 9. Glowing current dot (Home)
    if (showCurrentDot && readings.isNotEmpty) {
      final lx = _xByIndex(rows.length - 1, w);
      final ly = _y(rows.last.value, h);
      canvas.drawCircle(
        Offset(lx, ly),
        8,
        Paint()..color = AppColors.green.withOpacity(0.12),
      );
      canvas.drawCircle(
        Offset(lx, ly),
        4,
        Paint()
          ..color = AppColors.green
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3),
      );
      canvas.drawCircle(Offset(lx, ly), 4, Paint()..color = AppColors.green);
    }
  }

  void _drawCurveStroke(Canvas canvas, double w, double h) {
    if (readings.length < 2) return;
    final rows = _displayReadings;
    final displayLow = _displayLow;
    final displayHigh = _displayHigh;

    Color colorForReading(GlucoseReading r) {
      switch (coloringMode) {
        case ChartColoringMode.single:
          return AppColors.green;
        case ChartColoringMode.byValue:
          if (r.value > displayHigh) return AppColors.rose;
          if (r.value < displayLow) return AppColors.blue;
          return AppColors.green;
        case ChartColoringMode.byEpisode:
          for (final ep in episodes) {
            if (!r.timestamp.isBefore(ep.start) &&
                !r.timestamp.isAfter(ep.end)) {
              return ep.color;
            }
          }
          return AppColors.green;
      }
    }

    for (int i = 1; i < rows.length; i++) {
      final color = colorForReading(rows[i]);
      canvas.drawLine(
        Offset(_xByIndex(i - 1, w), _y(rows[i - 1].value, h)),
        Offset(_xByIndex(i, w), _y(rows[i].value, h)),
        Paint()
          ..color = color
          ..strokeWidth = 2
          ..strokeCap = StrokeCap.round,
      );
    }
  }

  void _dashed(Canvas c, double y, double x0, double x1, Color color) {
    final p =
        Paint()
          ..color = color
          ..strokeWidth = 0.75;
    double x = x0;
    while (x < x1) {
      c.drawLine(Offset(x, y), Offset(min(x + 4, x1), y), p);
      x += 7;
    }
  }

  void _yLabel(Canvas c, String text, double y) {
    final tp = TextPainter(
      text: TextSpan(
        text: text,
        style: const TextStyle(
          fontFamily: 'JetBrainsMono',
          fontSize: 8,
          color: _axisLabel,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    tp.paint(c, Offset(0, y - tp.height / 2));
  }

  @override
  bool shouldRepaint(_GlucosePainter old) =>
      old.readings != readings ||
      old.coloringMode != coloringMode ||
      old.unit != unit ||
      old.low != low ||
      old.high != high ||
      old.thresholdLineMode != thresholdLineMode ||
      old.episodes != episodes ||
      old.markers != markers;
}
