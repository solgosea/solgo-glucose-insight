import 'package:flutter/material.dart';
import 'package:smart_xdrip/foundation/theme/app_colors.dart';

import '../models/settings_view_model.dart';

class SettingsAboutBlock extends StatelessWidget {
  final SettingsAboutViewModel viewModel;

  const SettingsAboutBlock({super.key, required this.viewModel});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
      child: Column(
        children: [
          Text(
            viewModel.title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontFamily: 'JetBrainsMono',
              fontSize: 11,
              color: AppColors.textDim,
            ),
          ),
          const SizedBox(height: 6),
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 20,
            runSpacing: 8,
            children: [
              for (final link in viewModel.links)
                Text(
                  link,
                  style: const TextStyle(
                    fontFamily: 'JetBrainsMono',
                    fontSize: 10,
                    color: AppColors.textSoft,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
