import 'package:flutter/material.dart';
import '../../../foundation/theme/app_colors.dart';

class StatCard extends StatelessWidget {
  final String label;
  final String value;
  final String? unit;
  final Color? valueColor;
  final String? delta;
  final bool deltaPositive;

  const StatCard({
    super.key,
    required this.label,
    required this.value,
    this.unit,
    this.valueColor,
    this.delta,
    this.deltaPositive = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.bgCard,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label.toUpperCase(),
            style: const TextStyle(
              fontFamily: 'JetBrainsMono',
              fontSize: 9,
              color: AppColors.textDim,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 6),
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: value,
                  style: TextStyle(
                    fontFamily: 'JetBrainsMono',
                    fontSize: 32,
                    fontWeight: FontWeight.w700,
                    color: valueColor ?? AppColors.text,
                    height: 1.1,
                  ),
                ),
              ],
            ),
          ),
          if (unit != null)
            Text(
              unit!,
              style: const TextStyle(
                fontFamily: 'JetBrainsMono',
                fontSize: 11,
                color: AppColors.textSoft,
              ),
            ),
          if (delta != null) ...[
            const SizedBox(height: 6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
              decoration: BoxDecoration(
                color: AppColors.green.withOpacity(0.10),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.green.withOpacity(0.20)),
              ),
              child: Text(
                delta!,
                style: const TextStyle(
                  fontFamily: 'JetBrainsMono',
                  fontSize: 10,
                  color: AppColors.green,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
