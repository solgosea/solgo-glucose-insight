import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:smart_xdrip/application/glucose_unit/glucose_unit_format_service.dart';
import 'package:smart_xdrip/domain/entities/app_settings.dart';
import 'package:smart_xdrip/foundation/theme/app_colors.dart';

import 'target_range_value_policy.dart';

class TargetRangeRulerSheet extends StatefulWidget {
  final AppSettings settings;

  const TargetRangeRulerSheet({super.key, required this.settings});

  @override
  State<TargetRangeRulerSheet> createState() => _TargetRangeRulerSheetState();
}

class _TargetRangeRulerSheetState extends State<TargetRangeRulerSheet>
    with SingleTickerProviderStateMixin {
  static const _policy = TargetRangeValuePolicy();
  static const _formatter = GlucoseUnitFormatService();

  late TargetRangeDraft _draft;
  late TargetRangeDraft _initialDraft;
  TargetRangeMarker? _activeMarker;

  late final AnimationController _pulseCtrl;
  late final Animation<double> _pulseAnim;

  GlucoseUnit get _unit => widget.settings.unit;

  bool get _hasChanges =>
      _draft.lowMmol != _initialDraft.lowMmol ||
      _draft.highMmol != _initialDraft.highMmol ||
      _draft.veryHighMmol != _initialDraft.veryHighMmol;

  @override
  void initState() {
    super.initState();
    final initial = _policy.normalized(
      TargetRangeDraft(
        lowMmol: widget.settings.lowThreshold,
        highMmol: widget.settings.highThreshold,
        veryHighMmol: widget.settings.veryHighThreshold,
      ),
    );
    _draft = initial;
    _initialDraft = initial;

    _pulseCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat(reverse: true);
    _pulseAnim = CurvedAnimation(parent: _pulseCtrl, curve: Curves.easeInOut);
  }

  @override
  void dispose() {
    _pulseCtrl.dispose();
    super.dispose();
  }

  void _resetToDefault() {
    HapticFeedback.mediumImpact();
    setState(() {
      _draft = _policy.normalized(
        const TargetRangeDraft(
          lowMmol: 3.9,
          highMmol: 10.0,
          veryHighMmol: 13.9,
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.of(context).viewInsets.bottom;
    return SafeArea(
      child: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(20, 0, 20, bottom + 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Drag handle
            Center(
              child: Container(
                margin: const EdgeInsets.only(top: 12, bottom: 18),
                width: 36,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.borderMid,
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
            ),

            // Header
            Row(
              children: [
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Target Range',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                          color: AppColors.text,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Drag the markers to tune your low, in-range, and high thresholds.',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 12,
                          height: 1.45,
                          color: AppColors.textSoft,
                        ),
                      ),
                    ],
                  ),
                ),
                _ResetButton(onTap: _resetToDefault),
              ],
            ),
            const SizedBox(height: 18),

            // Target range hero card
            _RangeHeroCard(draft: _draft, unit: _unit, formatter: _formatter),
            const SizedBox(height: 14),

            // Threshold chips row
            _ThresholdChipsRow(
              draft: _draft,
              unit: _unit,
              formatter: _formatter,
              activeMarker: _activeMarker,
            ),
            const SizedBox(height: 18),

            // Ruler container
            Container(
              padding: const EdgeInsets.fromLTRB(8, 16, 8, 14),
              decoration: BoxDecoration(
                color: AppColors.bg,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.border),
              ),
              child: TargetRangeMultiMarkerRuler(
                draft: _draft,
                unit: _unit,
                pulseAnim: _pulseAnim,
                onChanged: (next) => setState(() => _draft = next),
                onMarkerActiveChanged: (m) => setState(() => _activeMarker = m),
              ),
            ),

            const SizedBox(height: 12),
            Row(
              children: [
                const Icon(
                  Icons.swipe_rounded,
                  color: AppColors.textDim,
                  size: 13,
                ),
                const SizedBox(width: 6),
                const Expanded(
                  child: Text(
                    'Drag any marker, or tap on the ruler to jump',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 11,
                      color: AppColors.textDim,
                    ),
                  ),
                ),
                Text(
                  _formatter.unitLabel(_unit),
                  style: const TextStyle(
                    fontFamily: 'JetBrainsMono',
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textDim,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 22),

            // Buttons
            Row(
              children: [
                Expanded(
                  child: _SheetButton(
                    label: 'Cancel',
                    onTap: () => Navigator.pop(context),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _SheetButton(
                    label: 'Save range',
                    primary: true,
                    enabled: _hasChanges,
                    onTap: () => Navigator.pop(context, _draft),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// Reset button.

class _ResetButton extends StatelessWidget {
  final VoidCallback onTap;
  const _ResetButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: AppColors.bgCard2,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AppColors.border),
        ),
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.refresh_rounded, size: 13, color: AppColors.textSoft),
            SizedBox(width: 4),
            Text(
              'Reset',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: AppColors.textSoft,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Hero card showing the target range prominently.

class _RangeHeroCard extends StatelessWidget {
  final TargetRangeDraft draft;
  final GlucoseUnit unit;
  final GlucoseUnitFormatService formatter;

  const _RangeHeroCard({
    required this.draft,
    required this.unit,
    required this.formatter,
  });

  @override
  Widget build(BuildContext context) {
    final target = formatter.range(draft.lowMmol, draft.highMmol, unit);
    final spread = (draft.highMmol - draft.lowMmol).toStringAsFixed(1);
    return AnimatedContainer(
      duration: const Duration(milliseconds: 240),
      padding: const EdgeInsets.fromLTRB(18, 16, 18, 16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.green.withOpacity(0.06),
            AppColors.green.withOpacity(0.13),
          ],
        ),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: AppColors.green.withOpacity(0.30),
          width: 1.5,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Eyebrow + value column
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'IN-RANGE TARGET',
                  style: TextStyle(
                    fontFamily: 'JetBrainsMono',
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.12 * 10,
                    color: AppColors.green,
                  ),
                ),
                const SizedBox(height: 8),
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 200),
                  child: Row(
                    key: ValueKey('${target.lowLabel}-${target.highLabel}'),
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        target.lowLabel,
                        style: const TextStyle(
                          fontFamily: 'JetBrainsMono',
                          fontSize: 30,
                          fontWeight: FontWeight.w800,
                          color: AppColors.text,
                          height: 1.0,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 6.0),
                        child: Container(
                          width: 12,
                          height: 1.5,
                          color: AppColors.textSoft,
                          margin: const EdgeInsets.only(bottom: 12),
                        ),
                      ),
                      Text(
                        target.highLabel,
                        style: const TextStyle(
                          fontFamily: 'JetBrainsMono',
                          fontSize: 30,
                          fontWeight: FontWeight.w800,
                          color: AppColors.text,
                          height: 1.0,
                        ),
                      ),
                      const SizedBox(width: 7),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 4),
                        child: Text(
                          target.unitLabel,
                          style: const TextStyle(
                            fontFamily: 'JetBrainsMono',
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textSoft,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Spread badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.green.withOpacity(0.18),
              borderRadius: BorderRadius.circular(999),
              border: Border.all(color: AppColors.green.withOpacity(0.40)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  spread,
                  style: const TextStyle(
                    fontFamily: 'JetBrainsMono',
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    color: AppColors.green,
                    height: 1.0,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'spread',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 8.5,
                    fontWeight: FontWeight.w600,
                    color: AppColors.green.withOpacity(0.75),
                    height: 1.0,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Threshold chips: Low / High / Very High mini cards.

class _ThresholdChipsRow extends StatelessWidget {
  final TargetRangeDraft draft;
  final GlucoseUnit unit;
  final GlucoseUnitFormatService formatter;
  final TargetRangeMarker? activeMarker;

  const _ThresholdChipsRow({
    required this.draft,
    required this.unit,
    required this.formatter,
    required this.activeMarker,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _ThresholdChip(
            label: 'LOW',
            color: AppColors.blue,
            value: '<${formatter.value(draft.lowMmol, unit).valueLabel}',
            unit: formatter.unitLabel(unit),
            active: activeMarker == TargetRangeMarker.low,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _ThresholdChip(
            label: 'HIGH',
            color: AppColors.amber,
            value: '>${formatter.value(draft.highMmol, unit).valueLabel}',
            unit: formatter.unitLabel(unit),
            active: activeMarker == TargetRangeMarker.high,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _ThresholdChip(
            label: 'VERY HIGH',
            color: AppColors.rose,
            value: '>${formatter.value(draft.veryHighMmol, unit).valueLabel}',
            unit: formatter.unitLabel(unit),
            active: activeMarker == TargetRangeMarker.veryHigh,
          ),
        ),
      ],
    );
  }
}

class _ThresholdChip extends StatelessWidget {
  final String label;
  final Color color;
  final String value;
  final String unit;
  final bool active;

  const _ThresholdChip({
    required this.label,
    required this.color,
    required this.value,
    required this.unit,
    required this.active,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      padding: const EdgeInsets.fromLTRB(10, 9, 10, 10),
      decoration: BoxDecoration(
        color: color.withOpacity(active ? 0.16 : 0.07),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withOpacity(active ? 0.65 : 0.22),
          width: active ? 1.5 : 1,
        ),
        boxShadow:
            active
                ? [
                  BoxShadow(
                    color: color.withOpacity(0.20),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
                : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Container(
                width: 6,
                height: 6,
                decoration: BoxDecoration(color: color, shape: BoxShape.circle),
              ),
              const SizedBox(width: 5),
              Expanded(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontFamily: 'JetBrainsMono',
                    fontSize: 9,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.08 * 9,
                    color: color,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  value,
                  style: const TextStyle(
                    fontFamily: 'JetBrainsMono',
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    color: AppColors.text,
                    height: 1.0,
                  ),
                ),
                const SizedBox(width: 3),
                Padding(
                  padding: const EdgeInsets.only(bottom: 1),
                  child: Text(
                    unit,
                    style: const TextStyle(
                      fontFamily: 'JetBrainsMono',
                      fontSize: 8.5,
                      color: AppColors.textDim,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Action buttons.

class _SheetButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  final bool primary;
  final bool enabled;

  const _SheetButton({
    required this.label,
    required this.onTap,
    this.primary = false,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    final bg =
        primary
            ? (enabled ? AppColors.green : AppColors.green.withOpacity(0.35))
            : AppColors.bgCard2;
    final fg = primary ? Colors.black : AppColors.textSoft;
    final border = primary ? Colors.transparent : AppColors.borderMid;

    return GestureDetector(
      onTap: enabled ? onTap : null,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        height: 50,
        decoration: BoxDecoration(
          color: bg,
          border: Border.all(color: border),
          borderRadius: BorderRadius.circular(13),
          boxShadow:
              primary && enabled
                  ? [
                    BoxShadow(
                      color: AppColors.green.withOpacity(0.30),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ]
                  : null,
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 14,
            fontWeight: FontWeight.w800,
            color: fg,
          ),
        ),
      ),
    );
  }
}

// Multi-marker ruler.

class TargetRangeMultiMarkerRuler extends StatefulWidget {
  final TargetRangeDraft draft;
  final GlucoseUnit unit;
  final Animation<double> pulseAnim;
  final ValueChanged<TargetRangeDraft> onChanged;
  final ValueChanged<TargetRangeMarker?> onMarkerActiveChanged;

  const TargetRangeMultiMarkerRuler({
    super.key,
    required this.draft,
    required this.unit,
    required this.pulseAnim,
    required this.onChanged,
    required this.onMarkerActiveChanged,
  });

  @override
  State<TargetRangeMultiMarkerRuler> createState() =>
      _TargetRangeMultiMarkerRulerState();
}

class _TargetRangeMultiMarkerRulerState
    extends State<TargetRangeMultiMarkerRuler> {
  static const _policy = TargetRangeValuePolicy();
  TargetRangeMarker? _activeMarker;
  double _lastHapticValue = 0;

  @override
  void initState() {
    super.initState();
    widget.pulseAnim.addListener(_onPulse);
  }

  @override
  void didUpdateWidget(covariant TargetRangeMultiMarkerRuler old) {
    super.didUpdateWidget(old);
    if (old.pulseAnim != widget.pulseAnim) {
      old.pulseAnim.removeListener(_onPulse);
      widget.pulseAnim.addListener(_onPulse);
    }
  }

  @override
  void dispose() {
    widget.pulseAnim.removeListener(_onPulse);
    super.dispose();
  }

  void _onPulse() {
    if (!mounted) return;
    if (_activeMarker == null) return;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 196,
      child: LayoutBuilder(
        builder: (context, _) {
          return GestureDetector(
            behavior: HitTestBehavior.opaque,
            onPanStart: (details) {
              final marker = _nearestMarker(details.localPosition.dx);
              setState(() {
                _activeMarker = marker;
                _lastHapticValue = _markerValue(marker);
              });
              widget.onMarkerActiveChanged(marker);
              HapticFeedback.selectionClick();
              _update(details.localPosition.dx);
            },
            onPanUpdate: (details) => _update(details.localPosition.dx),
            onPanEnd: (_) {
              setState(() => _activeMarker = null);
              widget.onMarkerActiveChanged(null);
              HapticFeedback.lightImpact();
            },
            onTapDown: (details) {
              final marker = _nearestMarker(details.localPosition.dx);
              setState(() => _activeMarker = marker);
              widget.onMarkerActiveChanged(marker);
              _update(details.localPosition.dx);
              Future.delayed(const Duration(milliseconds: 250), () {
                if (mounted) {
                  setState(() => _activeMarker = null);
                  widget.onMarkerActiveChanged(null);
                }
              });
            },
            child: CustomPaint(
              painter: _TargetRangeRulerPainter(
                draft: widget.draft,
                unit: widget.unit,
                activeMarker: _activeMarker,
                pulseProgress: widget.pulseAnim.value,
              ),
              child: const SizedBox.expand(),
            ),
          );
        },
      ),
    );
  }

  double _markerValue(TargetRangeMarker marker) {
    return switch (marker) {
      TargetRangeMarker.low => widget.draft.lowMmol,
      TargetRangeMarker.high => widget.draft.highMmol,
      TargetRangeMarker.veryHigh => widget.draft.veryHighMmol,
    };
  }

  TargetRangeMarker _nearestMarker(double dx) {
    final width = context.size?.width ?? 1;
    final positions = {
      TargetRangeMarker.low: _xFor(widget.draft.lowMmol, width),
      TargetRangeMarker.high: _xFor(widget.draft.highMmol, width),
      TargetRangeMarker.veryHigh: _xFor(widget.draft.veryHighMmol, width),
    };
    return positions.entries.reduce((best, entry) {
      final bestDistance = (best.value - dx).abs();
      final distance = (entry.value - dx).abs();
      return distance < bestDistance ? entry : best;
    }).key;
  }

  void _update(double dx) {
    final marker = _activeMarker;
    if (marker == null) return;
    final width = context.size?.width;
    if (width == null || width <= 0) return;
    final value = _mmolFor(dx, width);
    final next = _policy.updateMarker(
      draft: widget.draft,
      marker: marker,
      valueMmol: value,
      unit: widget.unit,
    );
    widget.onChanged(next);
    final newValue = _markerValue(marker);
    if ((newValue - _lastHapticValue).abs() >= 0.099) {
      _lastHapticValue = newValue;
      HapticFeedback.selectionClick();
    }
  }

  double _mmolFor(double dx, double width) {
    const left = _TargetRangeRulerPainter.horizontalPadding;
    const right = _TargetRangeRulerPainter.horizontalPadding;
    final usable = math.max(1.0, width - left - right);
    final normalized = ((dx - left) / usable).clamp(0.0, 1.0);
    return TargetRangeValuePolicy.minMmol +
        normalized *
            (TargetRangeValuePolicy.maxMmol - TargetRangeValuePolicy.minMmol);
  }

  double _xFor(double mmol, double width) {
    const left = _TargetRangeRulerPainter.horizontalPadding;
    const right = _TargetRangeRulerPainter.horizontalPadding;
    final usable = math.max(1.0, width - left - right);
    final normalized = ((mmol - TargetRangeValuePolicy.minMmol) /
            (TargetRangeValuePolicy.maxMmol - TargetRangeValuePolicy.minMmol))
        .clamp(0.0, 1.0);
    return left + usable * normalized;
  }
}

// Painter.

class _TargetRangeRulerPainter extends CustomPainter {
  static const horizontalPadding = 26.0;
  static const _formatter = GlucoseUnitFormatService();
  static const _trackY = 96.0;
  static const _trackHeight = 14.0;

  final TargetRangeDraft draft;
  final GlucoseUnit unit;
  final TargetRangeMarker? activeMarker;
  final double pulseProgress;

  _TargetRangeRulerPainter({
    required this.draft,
    required this.unit,
    required this.activeMarker,
    required this.pulseProgress,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final track = Rect.fromLTWH(
      horizontalPadding,
      _trackY,
      size.width - horizontalPadding * 2,
      _trackHeight,
    );

    _paintTrackBg(canvas, track);
    _paintZones(canvas, track);
    _paintMinorTicks(canvas, track);
    _paintMajorTicks(canvas, track);

    _paintMarker(
      canvas,
      track,
      draft.lowMmol,
      TargetRangeMarker.low,
      AppColors.blue,
      'LOW',
    );
    _paintMarker(
      canvas,
      track,
      draft.highMmol,
      TargetRangeMarker.high,
      AppColors.amber,
      'HIGH',
    );
    _paintMarker(
      canvas,
      track,
      draft.veryHighMmol,
      TargetRangeMarker.veryHigh,
      AppColors.rose,
      'VERY',
    );
  }

  void _paintTrackBg(Canvas canvas, Rect track) {
    final rrect = RRect.fromRectAndRadius(track, const Radius.circular(999));
    canvas.drawRRect(rrect, Paint()..color = AppColors.bgCard2);
  }

  void _paintZones(Canvas canvas, Rect track) {
    final rrect = RRect.fromRectAndRadius(track, const Radius.circular(999));
    canvas.save();
    canvas.clipRRect(rrect);

    _drawZoneSegment(
      canvas,
      track,
      TargetRangeValuePolicy.minMmol,
      draft.lowMmol,
      AppColors.blue,
    );
    _drawZoneSegment(
      canvas,
      track,
      draft.lowMmol,
      draft.highMmol,
      AppColors.green,
    );
    _drawZoneSegment(
      canvas,
      track,
      draft.highMmol,
      draft.veryHighMmol,
      AppColors.amber,
    );
    _drawZoneSegment(
      canvas,
      track,
      draft.veryHighMmol,
      TargetRangeValuePolicy.maxMmol,
      AppColors.rose,
    );

    canvas.restore();

    // Faint inner top highlight
    final highlight =
        Paint()
          ..shader = LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.white.withOpacity(0.05), Colors.transparent],
          ).createShader(track);
    canvas.drawRRect(rrect, highlight);
  }

  void _drawZoneSegment(
    Canvas canvas,
    Rect track,
    double startMmol,
    double endMmol,
    Color color,
  ) {
    final left = _xFor(startMmol, track);
    final right = _xFor(endMmol, track);
    if (right <= left) return;
    final paint = Paint()..color = color.withOpacity(0.78);
    canvas.drawRect(Rect.fromLTRB(left, track.top, right, track.bottom), paint);
  }

  void _paintMinorTicks(Canvas canvas, Rect track) {
    final paint =
        Paint()
          ..color = AppColors.textDim.withOpacity(0.18)
          ..strokeWidth = 1
          ..strokeCap = StrokeCap.round;
    for (var mmol = 3.0; mmol <= 19.0; mmol += 1.0) {
      final x = _xFor(mmol, track);
      canvas.drawLine(
        Offset(x, track.bottom + 8),
        Offset(x, track.bottom + 12),
        paint,
      );
    }
  }

  void _paintMajorTicks(Canvas canvas, Rect track) {
    final paint =
        Paint()
          ..color = AppColors.textSoft
          ..strokeWidth = 1.4
          ..strokeCap = StrokeCap.round;
    for (var mmol = 4.0; mmol <= 18.0; mmol += 2.0) {
      final x = _xFor(mmol, track);
      canvas.drawLine(
        Offset(x, track.bottom + 8),
        Offset(x, track.bottom + 16),
        paint,
      );
      _drawText(
        canvas,
        _formatter.value(mmol, unit).valueLabel,
        Offset(x, track.bottom + 26),
        AppColors.textSoft,
        10,
        FontWeight.w600,
        TextAlign.center,
      );
    }
  }

  void _paintMarker(
    Canvas canvas,
    Rect track,
    double mmol,
    TargetRangeMarker marker,
    Color color,
    String label,
  ) {
    final x = _xFor(mmol, track);
    final active = marker == activeMarker;
    final display = _formatter.value(mmol, unit).valueLabel;

    // Vertical guide line (only when active)
    if (active) {
      final guidePaint =
          Paint()
            ..color = color.withOpacity(0.22)
            ..strokeWidth = 1
            ..strokeCap = StrokeCap.round;
      canvas.drawLine(
        Offset(x, track.top - 24),
        Offset(x, track.bottom + 6),
        guidePaint,
      );
    }

    // Glow halo (active only)
    if (active) {
      final glowR = 16.0 + pulseProgress * 6.0;
      final glowAlpha = 0.20 + pulseProgress * 0.18;
      canvas.drawCircle(
        Offset(x, track.center.dy),
        glowR,
        Paint()
          ..color = color.withOpacity(glowAlpha)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8),
      );
    }

    // Knob: outer ring + inner fill.
    final knobR = active ? 11.0 : 9.5;
    final knobBg = Paint()..color = AppColors.bgCard;
    canvas.drawCircle(Offset(x, track.center.dy), knobR, knobBg);
    final knobBorder =
        Paint()
          ..color = color
          ..style = PaintingStyle.stroke
          ..strokeWidth = active ? 3.2 : 2.4;
    canvas.drawCircle(Offset(x, track.center.dy), knobR, knobBorder);

    // Inner dot at center of knob
    canvas.drawCircle(
      Offset(x, track.center.dy),
      active ? 3.2 : 2.6,
      Paint()..color = color,
    );

    // Badge above marker
    _paintBadge(
      canvas,
      center: Offset(x, track.top - 30),
      color: color,
      top: label,
      bottom: display,
      active: active,
    );
  }

  void _paintBadge(
    Canvas canvas, {
    required Offset center,
    required Color color,
    required String top,
    required String bottom,
    required bool active,
  }) {
    final width = active ? 64.0 : 54.0;
    final height = active ? 40.0 : 34.0;
    final rect = Rect.fromCenter(center: center, width: width, height: height);
    final rrect = RRect.fromRectAndRadius(rect, const Radius.circular(11));

    // Drop shadow when active
    if (active) {
      canvas.drawRRect(
        rrect.shift(const Offset(0, 3)),
        Paint()
          ..color = color.withOpacity(0.18)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6),
      );
    }

    // Background fill
    final bg =
        Paint()
          ..shader = LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              color.withOpacity(active ? 0.24 : 0.13),
              color.withOpacity(active ? 0.12 : 0.06),
            ],
          ).createShader(rect);
    canvas.drawRRect(rrect, bg);

    // Border
    canvas.drawRRect(
      rrect,
      Paint()
        ..color = color.withOpacity(active ? 0.80 : 0.40)
        ..style = PaintingStyle.stroke
        ..strokeWidth = active ? 1.6 : 1.0,
    );

    // Bottom anchor triangle
    final tri =
        Path()
          ..moveTo(center.dx - 5, rect.bottom)
          ..lineTo(center.dx + 5, rect.bottom)
          ..lineTo(center.dx, rect.bottom + 5)
          ..close();
    canvas.drawPath(
      tri,
      Paint()
        ..color = color.withOpacity(active ? 0.80 : 0.40)
        ..style = PaintingStyle.stroke
        ..strokeWidth = active ? 1.6 : 1.0,
    );
    canvas.drawPath(
      tri,
      Paint()
        ..shader = LinearGradient(
          colors: [
            color.withOpacity(active ? 0.24 : 0.13),
            color.withOpacity(active ? 0.12 : 0.06),
          ],
        ).createShader(
          Rect.fromPoints(
            Offset(center.dx - 5, rect.bottom),
            Offset(center.dx + 5, rect.bottom + 5),
          ),
        ),
    );

    _drawText(
      canvas,
      top,
      Offset(center.dx, center.dy - 8),
      color,
      9,
      FontWeight.w800,
      TextAlign.center,
      letterSpacing: 0.05 * 9,
    );
    _drawText(
      canvas,
      bottom,
      Offset(center.dx, center.dy + 8),
      AppColors.text,
      active ? 13 : 12,
      FontWeight.w800,
      TextAlign.center,
    );
  }

  void _drawText(
    Canvas canvas,
    String text,
    Offset anchor,
    Color color,
    double fontSize,
    FontWeight fontWeight,
    TextAlign textAlign, {
    double letterSpacing = 0,
  }) {
    final span = TextSpan(
      text: text,
      style: TextStyle(
        fontFamily: 'JetBrainsMono',
        fontSize: fontSize,
        fontWeight: fontWeight,
        color: color,
        letterSpacing: letterSpacing,
        height: 1.0,
      ),
    );
    final painter = TextPainter(
      text: span,
      textAlign: textAlign,
      textDirection: TextDirection.ltr,
      maxLines: 1,
    )..layout(maxWidth: 90);
    final dx = switch (textAlign) {
      TextAlign.right => anchor.dx - painter.width,
      TextAlign.center => anchor.dx - painter.width / 2,
      _ => anchor.dx,
    };
    painter.paint(canvas, Offset(dx, anchor.dy - painter.height / 2));
  }

  double _xFor(double mmol, Rect track) {
    final normalized = ((mmol - TargetRangeValuePolicy.minMmol) /
            (TargetRangeValuePolicy.maxMmol - TargetRangeValuePolicy.minMmol))
        .clamp(0.0, 1.0);
    return track.left + track.width * normalized;
  }

  @override
  bool shouldRepaint(covariant _TargetRangeRulerPainter old) {
    return old.draft != draft ||
        old.unit != unit ||
        old.activeMarker != activeMarker ||
        old.pulseProgress != pulseProgress;
  }
}
