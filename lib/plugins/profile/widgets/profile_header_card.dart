import 'package:flutter/material.dart';
import 'package:smart_xdrip/foundation/theme/app_colors.dart';

import '../models/profile_view_model.dart';

class ProfileHeaderCard extends StatelessWidget {
  final ProfileHeaderViewModel viewModel;

  const ProfileHeaderCard({super.key, required this.viewModel});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 14, 20, 20),
      child: Row(
        children: [
          Container(
            width: 64,
            height: 64,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: AppColors.green.withOpacity(0.10),
              border: Border.all(color: AppColors.green.withOpacity(0.22)),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(
              Icons.person_rounded,
              color: AppColors.green,
              size: 30,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  viewModel.title,
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: AppColors.text,
                  ),
                ),
                const SizedBox(height: 6),
                Wrap(
                  spacing: 6,
                  runSpacing: 4,
                  children: [_Badge(text: viewModel.primaryBadge, green: true)],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  final String text;
  final bool green;

  const _Badge({required this.text, required this.green});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: green ? AppColors.green.withOpacity(0.06) : null,
        border: Border.all(
          color: green ? AppColors.green.withOpacity(0.25) : AppColors.border,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        text.toUpperCase(),
        style: TextStyle(
          fontFamily: 'JetBrainsMono',
          fontSize: 9,
          color: green ? AppColors.green : AppColors.textDim,
          letterSpacing: 0.7,
        ),
      ),
    );
  }
}
