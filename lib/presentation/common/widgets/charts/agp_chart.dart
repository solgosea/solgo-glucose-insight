import 'dart:math';
import 'package:flutter/material.dart';
import '../../../../application/analysis/analysis_facade.dart';
import '../../../../application/glucose_unit/glucose_chart_unit_adapter.dart';
import '../../../../application/glucose_unit/glucose_unit_format_service.dart';
import '../../../../domain/entities/app_settings.dart';
import '../../../../foundation/theme/app_colors.dart';

/// Where to anchor an annotation's text label relative to its dashed line.
enum AnnotationLabelPosition { top, bottom }

/// A point-in-time annotation rendered as a dashed vertical line + multi-line
/// text label, used to mark CGM-derived patterns on the AGP profile (e.g. the
/// dawn phenomenon).
class AgpAnnotation {
  /// 0..1439 minute of the 24h day where the line is drawn.
  final int minuteOfDay;

  /// Short text rendered next to the line, top-down.
  /// Each entry becomes its own line (max 2 recommended).
  final List<String> labels;

  /// Base color shared by line and label text.
  final Color color;

  /// Opacity applied to the dashed line. The label uses the same base color
  /// at slightly higher opacity for legibility.
  final double opacity;

  /// Whether the label sits above the chart top (default) or below the chart.
  final AnnotationLabelPosition labelPosition;

  const AgpAnnotation({
    required this.minuteOfDay,
    required this.labels,
    required this.color,
    this.opacity = 0.5,
    this.labelPosition = AnnotationLabelPosition.top,
  });
}

class AgpChart extends StatelessWidget {
  final List<AnalysisAgpSlot> slots;
  final GlucoseUnit unit;
  final double height;
  final double low;
  final double high;

  /// Optional CGM-derived annotations (dawn phenomenon, post-meal peaks,
  /// etc.). Each renders as a dashed vertical with right-aligned text labels.
  final List<AgpAnnotation> annotations;

  /// Whether to draw the top and bottom grid lines around percentile bands.
  final bool showTopBottomGrid;

  /// Hour step for X-axis labels. 6 gives 5 labels (00/06/12/18/24).
  /// 3 gives 9 labels (00/03/06/.../24).
  final int xLabelStep;

  const AgpChart({
    super.key,
    required this.slots,
    this.unit = GlucoseUnit.mmolL,
    this.height = 200,
    this.low = 3.9,
    this.high = 10.0,
    this.annotations = const [],
    this.showTopBottomGrid = true,
    this.xLabelStep = 6,
  });

  @override
  Widget build(BuildContext context) => SizedBox(
    height: height,
    child: CustomPaint(
      painter: _AgpPainter(
        slots: slots,
        unit: unit,
        low: low,
        high: high,
        annotations: annotations,
        showTopBottomGrid: showTopBottomGrid,
        xLabelStep: xLabelStep,
      ),
      size: Size.infinite,
    ),
  );
}

class _AgpPainter extends CustomPainter {
  final List<AnalysisAgpSlot> slots;
  final GlucoseUnit unit;
  final double low;
  final double high;
  final List<AgpAnnotation> annotations;
  final bool showTopBottomGrid;
  final int xLabelStep;
  final GlucoseChartUnitAdapter chartAdapter = const GlucoseChartUnitAdapter();
  final GlucoseUnitFormatService formatter = const GlucoseUnitFormatService();

  static const _padLeft = 30.0;
  static const _padRight = 6.0;
  static const _padBottom = 22.0;
  static const _padTop = 10.0;

  _AgpPainter({
    required this.slots,
    required this.unit,
    required this.low,
    required this.high,
    required this.annotations,
    required this.showTopBottomGrid,
    required this.xLabelStep,
  });

  double get _minY => chartAdapter.minY(unit);

  double get _maxY => chartAdapter.maxY(unit);

  double _display(double mmol) => chartAdapter.value(mmol, unit);

  double _x(int minuteOfDay, double w) {
    final usable = w - _padLeft - _padRight;
    return _padLeft + (minuteOfDay / 1440.0) * usable;
  }

  double _y(double v, double h) {
    final usable = h - _padBottom - _padTop;
    return _padTop + (1 - (v - _minY) / (_maxY - _minY)) * usable;
  }

  @override
  void paint(Canvas canvas, Size size) {
    if (slots.isEmpty) return;
    final w = size.width, h = size.height;
    final right = w - _padRight;

    // Target range band.
    canvas.drawRect(
      Rect.fromLTRB(
        _padLeft,
        _y(_display(high), h),
        right,
        _y(_display(low), h),
      ),
      Paint()..color = AppColors.green.withOpacity(0.055),
    );

    // Top + bottom solid grid lines (subtle).
    if (showTopBottomGrid) {
      final gridPaint =
          Paint()
            ..color = AppColors.green.withOpacity(0.18)
            ..strokeWidth = 1.0;
      canvas.drawLine(
        const Offset(_padLeft, _padTop + 8),
        Offset(right, _padTop + 8),
        gridPaint,
      );
      canvas.drawLine(
        Offset(_padLeft, h - _padBottom + 2),
        Offset(right, h - _padBottom + 2),
        gridPaint,
      );
    }

    // Threshold dashed lines.
    _dashed(
      canvas,
      _y(_display(high), h),
      right,
      AppColors.green.withOpacity(0.30),
    );
    _dashed(
      canvas,
      _y(_display(low), h),
      right,
      AppColors.green.withOpacity(0.20),
    );

    // Percentile bands (outer p10-p90, inner p25-p75).
    _drawBand(
      canvas,
      size,
      (s) => s.p10,
      (s) => s.p90,
      AppColors.green.withOpacity(0.07),
    );
    _drawBand(
      canvas,
      size,
      (s) => s.p25,
      (s) => s.p75,
      AppColors.green.withOpacity(0.13),
    );

    // Annotations are drawn under the median line so the median stays visible
    // when an annotation crosses it.
    for (final a in annotations) {
      _drawAnnotation(canvas, size, a);
    }

    // Median line.
    final medPath = Path();
    var first = true;
    for (final s in slots) {
      final px = _x(s.minuteOfDay, w);
      final py = _y(_display(s.p50), h);
      if (first) {
        medPath.moveTo(px, py);
        first = false;
      } else {
        medPath.lineTo(px, py);
      }
    }
    canvas.drawPath(
      medPath,
      Paint()
        ..color = AppColors.green
        ..strokeWidth = 2.5
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round,
    );

    final labels = <double>{low, 7.0, high, 14.0}.toList()..sort();
    for (final v in labels) {
      final display = formatter.value(v, unit);
      _yLabel(canvas, display.valueLabel, _y(display.value, h));
    }

    // X-axis labels at configurable intervals.
    for (var hour = 0; hour <= 24; hour += xLabelStep) {
      final px = _padLeft + (hour / 24.0) * (w - _padLeft - _padRight);
      _xLabel(canvas, hour.toString().padLeft(2, '0'), px, h);
    }
  }

  void _drawBand(
    Canvas canvas,
    Size size,
    double Function(AnalysisAgpSlot) lo,
    double Function(AnalysisAgpSlot) hi,
    Color color,
  ) {
    if (slots.isEmpty) return;
    final w = size.width, h = size.height;
    final path = Path();
    path.moveTo(
      _x(slots.first.minuteOfDay, w),
      _y(_display(lo(slots.first)), h),
    );
    for (final s in slots) {
      path.lineTo(_x(s.minuteOfDay, w), _y(_display(lo(s)), h));
    }
    for (final s in slots.reversed) {
      path.lineTo(_x(s.minuteOfDay, w), _y(_display(hi(s)), h));
    }
    path.close();
    canvas.drawPath(
      path,
      Paint()
        ..color = color
        ..style = PaintingStyle.fill,
    );
  }

  /// Draw one annotation: a dashed vertical line + small stack of labels
  /// above the chart top, anchored to the line's x position.
  void _drawAnnotation(Canvas canvas, Size size, AgpAnnotation a) {
    final w = size.width, h = size.height;
    final ax = _x(a.minuteOfDay.clamp(0, 1440), w);

    // Dashed vertical from just below the top grid down to the bottom of
    // the percentile area (don't overlap the X-axis labels).
    final linePaint =
        Paint()
          ..color = a.color.withOpacity(a.opacity)
          ..strokeWidth = 0.8;
    var y = _padTop + 4;
    final yEnd = h - _padBottom + 2;
    while (y < yEnd) {
      canvas.drawLine(Offset(ax, y), Offset(ax, min(y + 3, yEnd)), linePaint);
      y += 6;
    }

    // Label stack: labels[0] sits highest (or lowest for bottom labels).
    // Anchor: small horizontal offset; switches side near the right edge.
    final labelStyle = TextStyle(
      fontFamily: 'Inter',
      fontSize: 9,
      fontWeight: FontWeight.w500,
      color: a.color.withOpacity((a.opacity + 0.25).clamp(0.0, 1.0)),
    );
    final isBottom = a.labelPosition == AnnotationLabelPosition.bottom;
    var ly = isBottom ? h - _padBottom + 4 : _padTop - 4;
    final lines = isBottom ? a.labels.reversed.toList() : a.labels;
    if (isBottom) {
      // Pre-measure the total height so we can stack upward from the bottom.
      var totalH = 0.0;
      for (final line in lines) {
        final tp = TextPainter(
          text: TextSpan(text: line, style: labelStyle),
          textDirection: TextDirection.ltr,
        )..layout();
        totalH += tp.height + 1;
      }
      ly = h - _padBottom + 4 + totalH - 1;
    }
    for (final line in lines) {
      final tp = TextPainter(
        text: TextSpan(text: line, style: labelStyle),
        textDirection: TextDirection.ltr,
      )..layout();
      final preferRight = ax + 4 + tp.width <= w - _padRight;
      final lx = preferRight ? ax + 4 : ax - 4 - tp.width;
      if (isBottom) {
        ly -= tp.height + 1;
        tp.paint(canvas, Offset(lx, ly));
      } else {
        tp.paint(canvas, Offset(lx, ly));
        ly += tp.height + 1;
      }
    }
  }

  void _dashed(Canvas c, double y, double xEnd, Color color) {
    final p =
        Paint()
          ..color = color
          ..strokeWidth = 0.75;
    var x = _padLeft;
    while (x < xEnd) {
      c.drawLine(Offset(x, y), Offset(min(x + 4, xEnd), y), p);
      x += 7;
    }
  }

  void _yLabel(Canvas c, String t, double y) {
    final tp = TextPainter(
      text: TextSpan(
        text: t,
        style: const TextStyle(
          fontFamily: 'JetBrainsMono',
          fontSize: 8,
          color: Color(0xFF7AB898),
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    tp.paint(c, Offset(0, y - tp.height / 2));
  }

  void _xLabel(Canvas c, String t, double x, double h) {
    final tp = TextPainter(
      text: TextSpan(
        text: t,
        style: const TextStyle(
          fontFamily: 'JetBrainsMono',
          fontSize: 8,
          color: Color(0xFF7AB898),
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    tp.paint(c, Offset(x - tp.width / 2, h - 16));
  }

  @override
  bool shouldRepaint(_AgpPainter old) =>
      old.slots != slots ||
      old.unit != unit ||
      old.low != low ||
      old.high != high ||
      old.annotations != annotations ||
      old.showTopBottomGrid != showTopBottomGrid ||
      old.xLabelStep != xLabelStep;
}
