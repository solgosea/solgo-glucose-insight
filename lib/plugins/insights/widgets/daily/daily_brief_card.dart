import 'package:flutter/material.dart';
import 'package:smart_xdrip/foundation/theme/app_colors.dart';
import '../../application/i18n/insights_l10n.dart';

class DailyBriefCard extends StatelessWidget {
  final String text;
  final String footer;

  const DailyBriefCard({
    super.key,
    required this.text,
    required this.footer,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 0, 20, 14),
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: AppColors.bgCard,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.borderMid),
      ),
      child: Stack(
        children: [
          const Positioned(
            left: 0,
            top: 0,
            bottom: 0,
            child: SizedBox(
              width: 2,
              child: DecoratedBox(
                decoration: BoxDecoration(color: AppColors.green),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const _BriefEyebrow(),
                const SizedBox(height: 12),
                Text(
                  text,
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 14,
                    color: AppColors.textSoft,
                    height: 1.75,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  footer,
                  style: const TextStyle(
                    fontFamily: 'JetBrainsMono',
                    fontSize: 9,
                    color: AppColors.textDim,
                    letterSpacing: 1.4,
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

class _BriefEyebrow extends StatelessWidget {
  const _BriefEyebrow();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const _PulseDot(),
        const SizedBox(width: 8),
        Text(
          context.insightsL10n.insightsDailyBriefToday,
          style: const TextStyle(
            fontFamily: 'JetBrainsMono',
            fontSize: 9,
            color: AppColors.green,
            letterSpacing: 1.4,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

class _PulseDot extends StatefulWidget {
  const _PulseDot();

  @override
  State<_PulseDot> createState() => _PulseDotState();
}

class _PulseDotState extends State<_PulseDot>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 2),
  )..repeat(reverse: true);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (_, __) {
        final t = _controller.value;
        final opacity = 0.45 + 0.55 * (1 - t);
        final scale = 0.8 + 0.2 * (1 - t);
        return Transform.scale(
          scale: scale,
          child: Container(
            width: 7,
            height: 7,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.green.withOpacity(opacity),
            ),
          ),
        );
      },
    );
  }
}
