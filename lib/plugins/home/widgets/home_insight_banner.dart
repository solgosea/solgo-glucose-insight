import 'package:flutter/material.dart';
import 'package:smart_xdrip/foundation/theme/app_colors.dart';

/// Home page insight entry. Visual only; data flow is unchanged.
class HomeInsightBanner extends StatelessWidget {
  final String text;
  final VoidCallback onTap;

  const HomeInsightBanner({super.key, required this.text, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.bgCard,
          border: Border.all(color: AppColors.border),
          borderRadius: BorderRadius.circular(12),
        ),
        clipBehavior: Clip.antiAlias,
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(width: 4, color: AppColors.green),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(
                        children: [
                          Text('*', style: TextStyle(fontSize: 14, height: 1)),
                          SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              "TODAY'S INSIGHT",
                              style: TextStyle(
                                fontFamily: 'JetBrainsMono',
                                fontSize: 9,
                                fontWeight: FontWeight.w600,
                                color: AppColors.green,
                                letterSpacing: 1.4,
                              ),
                            ),
                          ),
                          Text(
                            '>',
                            style: TextStyle(
                              fontSize: 16,
                              color: AppColors.textDim,
                              height: 1,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        text,
                        style: const TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: AppColors.text,
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'See full analysis  >',
                        style: TextStyle(
                          fontFamily: 'JetBrainsMono',
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                          color: AppColors.green,
                          letterSpacing: 0.4,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
