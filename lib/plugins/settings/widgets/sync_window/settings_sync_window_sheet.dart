import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:smart_xdrip/foundation/theme/app_colors.dart';

import '../../application/settings_sync_interval_options.dart';
import '../../application/settings_sync_window_options.dart';
import '../../l10n/generated/settings_localizations.dart';
import 'settings_sync_window_selection.dart';

class SettingsSyncWindowSheet extends StatefulWidget {
  final int initialDays;
  final int initialIntervalMinutes;
  final SettingsLocalizations l10n;

  const SettingsSyncWindowSheet({
    super.key,
    required this.initialDays,
    required this.initialIntervalMinutes,
    required this.l10n,
  });

  @override
  State<SettingsSyncWindowSheet> createState() =>
      _SettingsSyncWindowSheetState();
}

class _SettingsSyncWindowSheetState extends State<SettingsSyncWindowSheet> {
  late int _days = SettingsSyncWindowOptions.normalize(widget.initialDays);
  late int _interval =
      SettingsSyncIntervalOptions.normalize(widget.initialIntervalMinutes);

  @override
  Widget build(BuildContext context) {
    final l10n = widget.l10n;
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(18, 12, 18, 18),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const _SheetHandle(),
            _SheetHeader(
              title: l10n.settingsSyncWindowSheetTitle,
              subtitle: l10n.settingsSyncWindowSheetSubtitle,
            ),
            const SizedBox(height: 14),
            _SyncWindowHeroCard(
              title: l10n.settingsSyncPlanLabel,
              daysLabel: l10n.settingsHistoryRangeValue(_days),
              intervalLabel: l10n.settingsSyncIntervalValue(_interval),
            ),
            const SizedBox(height: 10),
            _DiscreteSliderCard(
              title: l10n.settingsHistoryRangeLabel,
              valueLabel: l10n.settingsHistoryRangeValue(_days),
              icon: Icons.history_rounded,
              values: SettingsSyncWindowOptions.values,
              selected: _days,
              suffixBuilder: (value) => l10n.settingsDaysShort(value),
              onChanged: (value) => setState(() => _days = value),
            ),
            const SizedBox(height: 10),
            _DiscreteSliderCard(
              title: l10n.settingsSyncIntervalLabel,
              valueLabel: l10n.settingsSyncIntervalValue(_interval),
              icon: Icons.timer_rounded,
              values: SettingsSyncIntervalOptions.values,
              selected: _interval,
              suffixBuilder: (value) => l10n.settingsMinutesShort(value),
              onChanged: (value) => setState(() => _interval = value),
            ),
            const SizedBox(height: 10),
            _PreviewCard(
              title: l10n.settingsSyncPreviewTitle,
              body: l10n.settingsSyncPreviewBody(_days, _interval),
            ),
            const SizedBox(height: 14),
            _SheetActions(
              cancelLabel: l10n.settingsCancel,
              saveLabel: l10n.settingsSaveSyncWindow,
              onCancel: () => Navigator.pop(context),
              onSave: () => Navigator.pop(
                context,
                SettingsSyncWindowSelection(
                  days: _days,
                  intervalMinutes: _interval,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SheetHandle extends StatelessWidget {
  const _SheetHandle();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        width: 48,
        height: 14,
        decoration: BoxDecoration(
          color: AppColors.bgCard2,
          borderRadius: BorderRadius.circular(999),
          border: Border.all(color: AppColors.border),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.28),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColors.textSoft.withOpacity(0.12),
              AppColors.bgCard2,
            ],
          ),
        ),
        child: Stack(
          children: [
            Positioned(
              left: 9,
              right: 9,
              top: 2,
              child: Container(
                height: 1,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.18),
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
            ),
            Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  for (var index = 0; index < 3; index++) ...[
                    if (index > 0) const SizedBox(width: 4),
                    Container(
                      width: 2,
                      height: 6,
                      decoration: BoxDecoration(
                        color: AppColors.textDim.withOpacity(0.85),
                        borderRadius: BorderRadius.circular(99),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SheetHeader extends StatelessWidget {
  final String title;
  final String subtitle;

  const _SheetHeader({
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontFamily: 'Inter',
            fontSize: 18,
            fontWeight: FontWeight.w800,
            color: AppColors.text,
          ),
        ),
        const SizedBox(height: 5),
        Text(
          subtitle,
          style: const TextStyle(
            fontFamily: 'Inter',
            fontSize: 11.5,
            height: 1.35,
            color: AppColors.textSoft,
          ),
        ),
      ],
    );
  }
}

class _SyncWindowHeroCard extends StatelessWidget {
  final String title;
  final String daysLabel;
  final String intervalLabel;

  const _SyncWindowHeroCard({
    required this.title,
    required this.daysLabel,
    required this.intervalLabel,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(14, 13, 14, 13),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.green.withOpacity(0.06),
            AppColors.green.withOpacity(0.13),
          ],
        ),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: AppColors.green.withOpacity(0.30),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontFamily: 'JetBrainsMono',
                    fontSize: 9,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1.2,
                    color: AppColors.green,
                  ),
                ),
                const SizedBox(height: 7),
                FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerLeft,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      _HeroValueText(daysLabel),
                      Container(
                        width: 10,
                        height: 1,
                        margin: const EdgeInsets.fromLTRB(7, 0, 7, 9),
                        color: AppColors.textSoft,
                      ),
                      _HeroValueText(intervalLabel),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: AppColors.green.withOpacity(0.18),
              borderRadius: BorderRadius.circular(11),
              border: Border.all(color: AppColors.green.withOpacity(0.38)),
            ),
            child: const Icon(
              Icons.sync_rounded,
              size: 18,
              color: AppColors.green,
            ),
          ),
        ],
      ),
    );
  }
}

class _HeroValueText extends StatelessWidget {
  final String value;

  const _HeroValueText(this.value);

  @override
  Widget build(BuildContext context) {
    return Text(
      value,
      style: const TextStyle(
        fontFamily: 'JetBrainsMono',
        fontSize: 17,
        fontWeight: FontWeight.w800,
        color: AppColors.text,
        height: 1,
      ),
    );
  }
}

class _DiscreteSliderCard extends StatelessWidget {
  final String title;
  final String valueLabel;
  final IconData icon;
  final List<int> values;
  final int selected;
  final String Function(int value) suffixBuilder;
  final ValueChanged<int> onChanged;

  const _DiscreteSliderCard({
    required this.title,
    required this.valueLabel,
    required this.icon,
    required this.values,
    required this.selected,
    required this.suffixBuilder,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final selectedIndex = values.indexOf(selected).clamp(0, values.length - 1);
    return Container(
      decoration: BoxDecoration(
        color: AppColors.bg,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: AppColors.border),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 12, 12, 11),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: AppColors.bgCard2,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Icon(icon, color: AppColors.green, size: 13),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 11.5,
                      fontWeight: FontWeight.w700,
                      color: AppColors.text,
                    ),
                  ),
                ),
                DecoratedBox(
                  decoration: BoxDecoration(
                    color: AppColors.green.withOpacity(0.18),
                    borderRadius: BorderRadius.circular(999),
                    border: Border.all(
                      color: AppColors.green.withOpacity(0.40),
                    ),
                  ),
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    child: Text(
                      valueLabel,
                      style: const TextStyle(
                        fontFamily: 'JetBrainsMono',
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: AppColors.green,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            _DiscreteRuler(
              selectedIndex: selectedIndex,
              values: values,
              label: valueLabel,
              suffixBuilder: suffixBuilder,
              onChanged: (index) => onChanged(values[index]),
            ),
          ],
        ),
      ),
    );
  }
}

class _DiscreteRuler extends StatefulWidget {
  final int selectedIndex;
  final List<int> values;
  final String label;
  final String Function(int value) suffixBuilder;
  final ValueChanged<int> onChanged;

  const _DiscreteRuler({
    required this.selectedIndex,
    required this.values,
    required this.label,
    required this.suffixBuilder,
    required this.onChanged,
  });

  @override
  State<_DiscreteRuler> createState() => _DiscreteRulerState();
}

class _DiscreteRulerState extends State<_DiscreteRuler> {
  bool _active = false;

  int get _itemCount => widget.values.length;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTapDown: (details) {
        _setActive(true);
        _updateFromDx(context, details.localPosition.dx);
        Future<void>.delayed(const Duration(milliseconds: 520), () {
          if (mounted) _setActive(false);
        });
      },
      onPanStart: (details) {
        HapticFeedback.selectionClick();
        _setActive(true);
        _updateFromDx(context, details.localPosition.dx);
      },
      onPanUpdate: (details) =>
          _updateFromDx(context, details.localPosition.dx),
      onPanEnd: (_) {
        _setActive(false);
        HapticFeedback.lightImpact();
      },
      child: LayoutBuilder(
        builder: (context, constraints) {
          final width = constraints.maxWidth;
          final usableWidth = width - 8;
          final x = _xFor(widget.selectedIndex, usableWidth) + 4;
          return SizedBox(
            height: 78,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Positioned(
                  left: 0,
                  right: 0,
                  top: 34,
                  height: 16,
                  child: _RulerTrack(
                    progress: _itemCount <= 1
                        ? 0
                        : widget.selectedIndex / (_itemCount - 1),
                  ),
                ),
                Positioned.fill(
                  top: 54,
                  child: _RulerTicks(
                    values: widget.values,
                    selectedIndex: widget.selectedIndex,
                    suffixBuilder: widget.suffixBuilder,
                  ),
                ),
                _RulerMarker(
                  left: x,
                  label: widget.label,
                  active: _active,
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _setActive(bool value) {
    if (_active == value) return;
    setState(() => _active = value);
  }

  void _updateFromDx(BuildContext context, double dx) {
    final box = context.findRenderObject() as RenderBox?;
    final width = box?.size.width ?? 1;
    final usableWidth = width - 8;
    final normalized = ((dx - 4) / usableWidth).clamp(0.0, 1.0);
    final index = (normalized * (_itemCount - 1)).round();
    widget.onChanged(index.clamp(0, _itemCount - 1));
  }

  double _xFor(int index, double width) {
    if (_itemCount <= 1) return 0;
    return (width / (_itemCount - 1)) * index;
  }
}

class _RulerTrack extends StatelessWidget {
  final double progress;

  const _RulerTrack({required this.progress});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Map progress with the same pad (4) used by ticks/marker so the
        // green fill ends exactly under the handle. Inner groove starts at
        // pixel 2 (container padding), marker centers at 4 + usable*progress,
        // so fill width = 2 + usable*progress.
        final usable = constraints.maxWidth - 8;
        final maxFill = constraints.maxWidth - 4;
        final fillWidth =
            (2 + usable * progress.clamp(0.0, 1.0)).clamp(0.0, maxFill);
        return Container(
          padding: const EdgeInsets.all(2),
          decoration: BoxDecoration(
            color: AppColors.bgCard2,
            borderRadius: BorderRadius.circular(9),
            border: Border.all(color: AppColors.borderMid),
            boxShadow: [
              BoxShadow(
                color: AppColors.green.withOpacity(0.10),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(7),
            child: Stack(
              children: [
                // Unfilled groove: green-tinted teal over the card surface,
                // never a flat black slot.
                Positioned.fill(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          AppColors.green.withOpacity(0.05),
                          AppColors.green.withOpacity(0.11),
                        ],
                      ),
                    ),
                  ),
                ),
                Positioned(
                  left: 0,
                  top: 0,
                  bottom: 0,
                  width: fillWidth,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          AppColors.green.withOpacity(1.00),
                          AppColors.green.withOpacity(0.82),
                          AppColors.green.withOpacity(0.66),
                        ],
                        stops: const [0, 0.45, 1],
                      ),
                    ),
                    child: Align(
                      alignment: Alignment.topCenter,
                      child: Container(
                        height: 2,
                        color: Colors.white.withOpacity(0.22),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  left: 0,
                  right: 0,
                  top: 0,
                  height: 1,
                  child: Container(color: Colors.white.withOpacity(0.14)),
                ),
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  height: 1,
                  child: Container(color: AppColors.green.withOpacity(0.18)),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _RulerTicks extends StatelessWidget {
  final List<int> values;
  final int selectedIndex;
  final String Function(int value) suffixBuilder;

  const _RulerTicks({
    required this.values,
    required this.selectedIndex,
    required this.suffixBuilder,
  });

  int get _itemCount => values.length;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth - 8;
        const tickCount = 40;
        return Stack(
          clipBehavior: Clip.none,
          children: [
            for (var index = 0; index <= tickCount; index++)
              _RulerTick(
                left: 4 + width * index / tickCount,
                major: index % 10 == 0,
                medium: index % 5 == 0,
                highlighted: (index / tickCount - _progress).abs() <= 0.08,
              ),
            for (var index = 0; index < _itemCount; index++)
              _StepTick(
                left: 4 + _xFor(index, width),
                active: index == selectedIndex,
                label: suffixBuilder(values[index]),
              ),
          ],
        );
      },
    );
  }

  double get _progress =>
      _itemCount <= 1 ? 0 : selectedIndex / (_itemCount - 1);

  double _xFor(int index, double width) {
    if (_itemCount <= 1) return 0;
    return (width / (_itemCount - 1)) * index;
  }
}

class _RulerTick extends StatelessWidget {
  final double left;
  final bool major;
  final bool medium;
  final bool highlighted;

  const _RulerTick({
    required this.left,
    required this.major,
    required this.medium,
    required this.highlighted,
  });

  @override
  Widget build(BuildContext context) {
    final height = major ? 8.0 : (medium ? 5.5 : 3.0);
    final opacity = highlighted ? 0.86 : (major ? 0.52 : 0.24);
    return Positioned(
      left: left,
      top: 0,
      child: Transform.translate(
        offset: const Offset(-0.5, 0),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 120),
          width: highlighted ? 1.25 : 1,
          height: highlighted ? height + 2 : height,
          color: (highlighted ? AppColors.textSoft : AppColors.textDim)
              .withOpacity(opacity),
        ),
      ),
    );
  }
}

class _StepTick extends StatelessWidget {
  final double left;
  final bool active;
  final String label;

  const _StepTick({
    required this.left,
    required this.active,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: left,
      top: 13,
      child: Transform.translate(
        offset: const Offset(-14, 0),
        child: SizedBox(
          width: 28,
          child: Column(
            children: [
              SizedBox(
                height: 6,
                child: Center(
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 120),
                    width: active ? 6 : 4,
                    height: active ? 6 : 4,
                    decoration: BoxDecoration(
                      color: active ? AppColors.green : AppColors.textDim,
                      shape: BoxShape.circle,
                      boxShadow: active
                          ? [
                              BoxShadow(
                                color: AppColors.green.withOpacity(0.32),
                                blurRadius: 6,
                              ),
                            ]
                          : null,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 5),
              Text(
                label,
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.visible,
                style: TextStyle(
                  fontFamily: 'JetBrainsMono',
                  fontSize: 9,
                  fontWeight: active ? FontWeight.w700 : FontWeight.w500,
                  color: active ? AppColors.text : AppColors.textDim,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RulerMarker extends StatelessWidget {
  final double left;
  final String label;
  final bool active;

  const _RulerMarker({
    required this.left,
    required this.label,
    required this.active,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: left,
      top: 0,
      child: FractionalTranslation(
        translation: const Offset(-0.5, 0),
        child: Column(
          children: [
            _MarkerBubble(label: label, visible: active),
            const SizedBox(height: 4),
            AnimatedScale(
              duration: const Duration(milliseconds: 150),
              scale: active ? 1.1 : 1,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  AnimatedOpacity(
                    duration: const Duration(milliseconds: 150),
                    opacity: active ? 1 : 0,
                    child: Container(
                      width: 26,
                      height: 26,
                      decoration: BoxDecoration(
                        color: AppColors.green.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.green.withOpacity(0.34),
                            blurRadius: 9,
                            spreadRadius: 4,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Column(
                    children: [
                      Container(
                        width: 16,
                        height: 16,
                        decoration: BoxDecoration(
                          color: AppColors.green,
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(color: AppColors.bg, width: 1.5),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.42),
                              blurRadius: 4,
                              offset: const Offset(0, 1),
                            ),
                          ],
                        ),
                        alignment: Alignment.center,
                        child: Container(
                          width: 5,
                          height: 5,
                          decoration: BoxDecoration(
                            color: AppColors.bg.withOpacity(0.55),
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ),
                      Container(
                        width: 2,
                        height: 16,
                        decoration: BoxDecoration(
                          color: AppColors.green,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MarkerBubble extends StatelessWidget {
  final String label;
  final bool visible;

  const _MarkerBubble({required this.label, required this.visible});

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      duration: const Duration(milliseconds: 150),
      opacity: visible ? 1 : 0,
      child: AnimatedScale(
        duration: const Duration(milliseconds: 150),
        scale: visible ? 1 : 0.92,
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.green.withOpacity(0.96),
                borderRadius: BorderRadius.circular(999),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.green.withOpacity(0.24),
                    blurRadius: 7,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Text(
                label,
                style: const TextStyle(
                  fontFamily: 'JetBrainsMono',
                  fontSize: 9,
                  fontWeight: FontWeight.w900,
                  color: AppColors.bg,
                ),
              ),
            ),
            CustomPaint(
              size: const Size(8, 4),
              painter: _BubbleArrowPainter(AppColors.green),
            ),
          ],
        ),
      ),
    );
  }
}

class _BubbleArrowPainter extends CustomPainter {
  final Color color;

  const _BubbleArrowPainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final path = Path()
      ..moveTo(0, 0)
      ..lineTo(size.width / 2, size.height)
      ..lineTo(size.width, 0)
      ..close();
    canvas.drawPath(path, Paint()..color = color.withOpacity(0.96));
  }

  @override
  bool shouldRepaint(covariant _BubbleArrowPainter oldDelegate) {
    return oldDelegate.color != color;
  }
}

class _PreviewCard extends StatelessWidget {
  final String title;
  final String body;

  const _PreviewCard({
    required this.title,
    required this.body,
  });

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.bgCard2,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 10, 12, 11),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontFamily: 'Inter',
                fontSize: 11.5,
                fontWeight: FontWeight.w700,
                color: AppColors.text,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              body,
              style: const TextStyle(
                fontFamily: 'Inter',
                fontSize: 11.5,
                height: 1.35,
                color: AppColors.textSoft,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SheetActions extends StatelessWidget {
  final String cancelLabel;
  final String saveLabel;
  final VoidCallback onCancel;
  final VoidCallback onSave;

  const _SheetActions({
    required this.cancelLabel,
    required this.saveLabel,
    required this.onCancel,
    required this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _SheetButton(label: cancelLabel, onTap: onCancel),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _SheetButton(
            label: saveLabel,
            primary: true,
            onTap: onSave,
          ),
        ),
      ],
    );
  }
}

class _SheetButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  final bool primary;

  const _SheetButton({
    required this.label,
    required this.onTap,
    this.primary = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        height: 44,
        decoration: BoxDecoration(
          color: primary ? AppColors.green : AppColors.bgCard2,
          borderRadius: BorderRadius.circular(11),
          border: Border.all(
            color: primary ? Colors.transparent : AppColors.borderMid,
          ),
          boxShadow: primary
              ? [
                  BoxShadow(
                    color: AppColors.green.withOpacity(0.30),
                    blurRadius: 9,
                    offset: const Offset(0, 3),
                  ),
                ]
              : null,
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 13,
            fontWeight: FontWeight.w800,
            color: primary ? AppColors.bg : AppColors.textSoft,
          ),
        ),
      ),
    );
  }
}
