import 'package:flutter/material.dart';

import '../../../../foundation/theme/app_colors.dart';
import '../domain/date_filter_day_bucket.dart';

class DateFilterDayCell extends StatelessWidget {
  final DateFilterDayBucket bucket;
  final bool selected;
  final bool inRange;
  final bool rangeStart;
  final bool rangeEnd;
  final bool today;
  final VoidCallback onTap;

  const DateFilterDayCell({
    super.key,
    required this.bucket,
    required this.selected,
    required this.inRange,
    required this.rangeStart,
    required this.rangeEnd,
    required this.today,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final disabled = bucket.disabled;
    return GestureDetector(
      onTap: disabled ? null : onTap,
      child: SizedBox(
        height: 48,
        child: Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.center,
          children: [
            if (inRange || rangeStart || rangeEnd)
              Positioned.fill(
                left: rangeStart ? 3 : -5,
                right: rangeEnd ? 3 : -5,
                top: 6,
                bottom: 6,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: AppColors.blue.withValues(alpha: 0.16),
                    borderRadius: BorderRadius.horizontal(
                      left:
                          rangeStart ? const Radius.circular(13) : Radius.zero,
                      right: rangeEnd ? const Radius.circular(13) : Radius.zero,
                    ),
                    border: Border.all(
                      color: AppColors.blue.withValues(alpha: 0.10),
                    ),
                  ),
                ),
              ),
            AnimatedContainer(
              duration: const Duration(milliseconds: 160),
              curve: Curves.easeOutCubic,
              width: selected || rangeStart || rangeEnd ? 42 : 40,
              height: selected || rangeStart || rangeEnd ? 42 : 40,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                gradient: _selectedGradient,
                boxShadow: _selectedShadow,
                color: _selectedGradient == null ? Colors.transparent : null,
                border: Border.all(
                  color: today
                      ? AppColors.green.withValues(alpha: 0.48)
                      : Colors.transparent,
                  width: today ? 1.4 : 1,
                ),
              ),
              child: Opacity(
                opacity: disabled ? 0.32 : 1,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '${bucket.date.day}',
                          style: TextStyle(
                            fontFamily: 'JetBrainsMono',
                            fontSize: 13,
                            fontWeight: FontWeight.w800,
                            height: 1,
                            color: _primaryTextColor,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          bucket.readingCount > 0
                              ? '${bucket.readingCount}'
                              : '-',
                          style: TextStyle(
                            fontFamily: 'JetBrainsMono',
                            fontSize: 8,
                            fontWeight: FontWeight.w700,
                            height: 1,
                            color: _secondaryTextColor,
                          ),
                        ),
                      ],
                    ),
                    Positioned(
                      left: 11,
                      right: 11,
                      bottom: 5,
                      child: FractionallySizedBox(
                        alignment: Alignment.center,
                        widthFactor: _heatFactor,
                        child: Container(
                          height: 2,
                          decoration: BoxDecoration(
                            color: _heatColor,
                            borderRadius: BorderRadius.circular(999),
                          ),
                        ),
                      ),
                    ),
                    if (today)
                      Positioned(
                        top: 4,
                        child: Container(
                          width: 3,
                          height: 3,
                          decoration: BoxDecoration(
                            color: selected || rangeStart || rangeEnd
                                ? const Color(0xFF06110D)
                                : AppColors.green,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.green.withValues(alpha: 0.7),
                                blurRadius: 5,
                              ),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  LinearGradient? get _selectedGradient {
    if (selected) {
      return const LinearGradient(
        colors: [Color(0xFF8FF0B6), Color(0xFF52D98C)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );
    }
    if (rangeStart || rangeEnd) {
      return const LinearGradient(
        colors: [Color(0xFF7CC6F5), Color(0xFF4AA6EA)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );
    }
    return null;
  }

  List<BoxShadow>? get _selectedShadow {
    if (selected) {
      return [
        BoxShadow(
          color: AppColors.green.withValues(alpha: 0.55),
          blurRadius: 14,
          offset: const Offset(0, 4),
        ),
      ];
    }
    if (rangeStart || rangeEnd) {
      return [
        BoxShadow(
          color: AppColors.blue.withValues(alpha: 0.55),
          blurRadius: 14,
          offset: const Offset(0, 4),
        ),
      ];
    }
    return null;
  }

  Color get _primaryTextColor {
    if (selected || rangeStart || rangeEnd) return const Color(0xFF06110D);
    if (inRange) return AppColors.blue;
    return AppColors.textSoft;
  }

  Color get _secondaryTextColor {
    if (selected || rangeStart || rangeEnd) {
      return const Color(0xC406110D);
    }
    if (inRange) return AppColors.blue.withValues(alpha: 0.95);
    return _toneColor(bucket.tone);
  }

  double get _heatFactor {
    if (bucket.readingCount <= 0) return 0;
    return (bucket.readingCount / 288).clamp(0.08, 1).toDouble();
  }

  Color get _heatColor {
    if (selected || rangeStart || rangeEnd) {
      return const Color(0x6606110D);
    }
    if (inRange) return AppColors.blue.withValues(alpha: 0.60);
    return switch (bucket.tone) {
      DateFilterDayTone.none => Colors.transparent,
      DateFilterDayTone.sparse => AppColors.amber.withValues(alpha: 0.62),
      DateFilterDayTone.partial => AppColors.amber.withValues(alpha: 0.72),
      DateFilterDayTone.full => AppColors.green.withValues(alpha: 0.50),
    };
  }

  Color _toneColor(DateFilterDayTone tone) {
    return switch (tone) {
      DateFilterDayTone.none => AppColors.textDim,
      DateFilterDayTone.sparse => AppColors.amber,
      DateFilterDayTone.partial => AppColors.amber,
      DateFilterDayTone.full => AppColors.green.withValues(alpha: 0.76),
    };
  }
}
