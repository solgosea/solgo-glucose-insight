import 'package:flutter/material.dart';
import 'package:smart_xdrip/foundation/theme/app_colors.dart';

import '../models/profile_view_model.dart';

class ProfileTargetRangeCard extends StatelessWidget {
  final List<ProfileTargetRangeViewModel> ranges;
  final VoidCallback onTap;

  const ProfileTargetRangeCard({
    super.key,
    required this.ranges,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    if (ranges.isEmpty) return const SizedBox.shrink();
    final target = ranges.first;
    final thresholds =
        ranges.length > 1 ? ranges.sublist(1) : <ProfileTargetRangeViewModel>[];

    return Container(
      margin: const EdgeInsets.fromLTRB(20, 0, 20, 4),
      decoration: BoxDecoration(
        color: AppColors.bgCard,
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(16),
      ),
      clipBehavior: Clip.antiAlias,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          splashColor: AppColors.green.withOpacity(0.06),
          highlightColor: AppColors.green.withOpacity(0.03),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _TargetHero(target: target),
                const SizedBox(height: 14),
                _RangeBandPreview(thresholds: thresholds),
                if (thresholds.isNotEmpty) ...[
                  const SizedBox(height: 14),
                  _ThresholdGrid(thresholds: thresholds),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Hero row: title and target value range.

class _TargetHero extends StatelessWidget {
  final ProfileTargetRangeViewModel target;
  const _TargetHero({required this.target});

  @override
  Widget build(BuildContext context) {
    final parts = _splitValueAndUnit(target.valueLabel);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: AppColors.green.withOpacity(0.12),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: AppColors.green.withOpacity(0.30)),
          ),
          child: Icon(target.icon, color: AppColors.green, size: 18),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'TARGET RANGE',
                style: TextStyle(
                  fontFamily: 'JetBrainsMono',
                  fontSize: 9.5,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.12 * 9.5,
                  color: AppColors.green,
                ),
              ),
              const SizedBox(height: 4),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    parts.value,
                    style: const TextStyle(
                      fontFamily: 'JetBrainsMono',
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      color: AppColors.text,
                      height: 1.0,
                    ),
                  ),
                  if (parts.unit != null) ...[
                    const SizedBox(width: 6),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 2),
                      child: Text(
                        parts.unit!,
                        style: const TextStyle(
                          fontFamily: 'JetBrainsMono',
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                          color: AppColors.textDim,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
        const Icon(Icons.tune_rounded, size: 18, color: AppColors.textDim),
      ],
    );
  }
}

// Color band preview: visual representation of all zones.

class _RangeBandPreview extends StatelessWidget {
  final List<ProfileTargetRangeViewModel> thresholds;
  const _RangeBandPreview({required this.thresholds});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 8,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(999),
        gradient: const LinearGradient(
          colors: [
            AppColors.blue,
            AppColors.blue,
            AppColors.green,
            AppColors.green,
            AppColors.amber,
            AppColors.amber,
            AppColors.rose,
            AppColors.rose,
          ],
          stops: [0.0, 0.18, 0.18, 0.55, 0.55, 0.78, 0.78, 1.0],
        ),
      ),
      child: const SizedBox.expand(),
    );
  }
}

// Threshold grid: small cards for Low / High / Very High.

class _ThresholdGrid extends StatelessWidget {
  final List<ProfileTargetRangeViewModel> thresholds;
  const _ThresholdGrid({required this.thresholds});

  @override
  Widget build(BuildContext context) {
    final colors = <Color>[AppColors.blue, AppColors.amber, AppColors.rose];
    return Row(
      children: [
        for (var i = 0; i < thresholds.length; i++) ...[
          if (i > 0) const SizedBox(width: 8),
          Expanded(
            child: _ThresholdTile(
              range: thresholds[i],
              accent: colors[i.clamp(0, colors.length - 1)],
            ),
          ),
        ],
      ],
    );
  }
}

class _ThresholdTile extends StatelessWidget {
  final ProfileTargetRangeViewModel range;
  final Color accent;

  const _ThresholdTile({required this.range, required this.accent});

  String get _shortLabel {
    final lower = range.label.toLowerCase();
    if (lower.contains('very')) return 'VERY HIGH';
    if (lower.contains('high')) return 'HIGH';
    if (lower.contains('low')) return 'LOW';
    return range.label.toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    final parts = _splitValueAndUnit(range.valueLabel);
    return Container(
      padding: const EdgeInsets.fromLTRB(10, 9, 10, 10),
      decoration: BoxDecoration(
        color: accent.withOpacity(0.07),
        borderRadius: BorderRadius.circular(11),
        border: Border.all(color: accent.withOpacity(0.22)),
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
                decoration: BoxDecoration(
                  color: accent,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 5),
              Text(
                _shortLabel,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontFamily: 'JetBrainsMono',
                  fontSize: 9,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.08 * 9,
                  color: accent,
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
                  parts.value,
                  style: const TextStyle(
                    fontFamily: 'JetBrainsMono',
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    color: AppColors.text,
                    height: 1.0,
                  ),
                ),
                if (parts.unit != null) ...[
                  const SizedBox(width: 3),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 1),
                    child: Text(
                      parts.unit!,
                      style: const TextStyle(
                        fontFamily: 'JetBrainsMono',
                        fontSize: 8.5,
                        color: AppColors.textDim,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Helpers.

class _ValueParts {
  final String value;
  final String? unit;
  const _ValueParts(this.value, this.unit);
}

_ValueParts _splitValueAndUnit(String label) {
  final trimmed = label.trim();
  if (trimmed.isEmpty) return const _ValueParts('', null);
  final firstSpace = trimmed.indexOf(' ');
  if (firstSpace == -1) return _ValueParts(trimmed, null);
  return _ValueParts(
    trimmed.substring(0, firstSpace),
    trimmed.substring(firstSpace + 1).trim(),
  );
}
