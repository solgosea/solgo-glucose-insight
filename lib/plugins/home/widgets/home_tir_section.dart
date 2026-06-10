import 'package:flutter/material.dart';
import 'package:smart_xdrip/foundation/theme/app_colors.dart';
import 'package:smart_xdrip/presentation/common/widgets/charts/tir_ring_chart.dart';
import '../models/home_tir_view_model.dart';
import 'home_tir_row.dart';

class HomeTirSection extends StatelessWidget {
  final HomeTirViewModel viewModel;

  const HomeTirSection({super.key, required this.viewModel});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: AppColors.bgCard,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          TirRingChart(
            tir: viewModel.tir,
            tar: viewModel.tar,
            tbr: viewModel.tbr,
            size: 80,
          ),
          const SizedBox(width: 18),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (var i = 0; i < viewModel.rows.length; i++) ...[
                  HomeTirRow(viewModel: viewModel.rows[i]),
                  if (i != viewModel.rows.length - 1) const SizedBox(height: 7),
                ],
                const SizedBox(height: 8),
                Text(
                  viewModel.footer,
                  style: const TextStyle(
                    fontFamily: 'JetBrainsMono',
                    fontSize: 9,
                    color: AppColors.textDim,
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
