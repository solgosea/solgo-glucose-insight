import 'package:flutter/material.dart';
import 'package:smart_xdrip/foundation/theme/app_colors.dart';
import '../models/home_tir_view_model.dart';

class HomeTirRow extends StatelessWidget {
  final HomeTirRowViewModel viewModel;

  const HomeTirRow({super.key, required this.viewModel});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          viewModel.label,
          style: const TextStyle(
            fontFamily: 'Inter',
            fontSize: 11,
            color: AppColors.textSoft,
          ),
        ),
        Text(
          '${viewModel.percent.toStringAsFixed(0)}%',
          style: TextStyle(
            fontFamily: 'JetBrainsMono',
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: viewModel.color,
          ),
        ),
      ],
    );
  }
}
