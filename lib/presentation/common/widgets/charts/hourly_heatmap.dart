import 'package:flutter/material.dart';
import '../../../../foundation/theme/app_colors.dart';

class HourlyHeatmap extends StatelessWidget {
  final List<double> hourlyTir; // 24 values, TIR%
  const HourlyHeatmap({super.key, required this.hourlyTir});

  Color _color(double tir) {
    final t = ((tir - 45) / 55).clamp(0.0, 1.0);
    return Color.lerp(
      AppColors.amber.withOpacity(0.35),
      AppColors.green.withOpacity(0.65),
      t,
    )!;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 28,
          child: Row(
            children: List.generate(
              24,
              (h) => Expanded(
                child: Container(
                  margin: const EdgeInsets.all(1.5),
                  decoration: BoxDecoration(
                    color:
                        h < hourlyTir.length
                            ? _color(hourlyTir[h])
                            : AppColors.bgCard2,
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 4),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children:
              ['00:00', '06:00', '12:00', '18:00', '24:00']
                  .map(
                    (l) => Text(
                      l,
                      style: const TextStyle(
                        fontFamily: 'JetBrainsMono',
                        fontSize: 8,
                        color: AppColors.textDim,
                      ),
                    ),
                  )
                  .toList(),
        ),
      ],
    );
  }
}
