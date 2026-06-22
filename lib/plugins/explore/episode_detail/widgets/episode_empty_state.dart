import 'package:flutter/material.dart';
import 'package:smart_xdrip/foundation/theme/app_colors.dart';
import 'package:smart_xdrip/presentation/common/navigation/safe_navigation.dart';
import '../shared/episode_header.dart';

import '../models/episode_detail_view_model.dart';

class EpisodeEmptyState extends StatelessWidget {
  final EpisodeDetailViewModel viewModel;
  final Widget? trailing;

  const EpisodeEmptyState({
    super.key,
    required this.viewModel,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: SafeArea(
        child: Column(
          children: [
            EpisodeHeader(
              title: viewModel.title,
              subtitle: viewModel.subtitle,
              onBack: () => context.safePopOrHome(),
              trailing: trailing,
            ),
            Expanded(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: Text(
                    viewModel.emptyText,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 13,
                      color: AppColors.textDim,
                      height: 1.5,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
