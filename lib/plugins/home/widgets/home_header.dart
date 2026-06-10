import 'package:flutter/material.dart';
import 'package:smart_xdrip/presentation/common/sync_status/sync_status_compact_panel.dart';
import 'package:smart_xdrip/foundation/theme/app_colors.dart';
import '../models/home_view_model.dart';

class HomeHeader extends StatelessWidget {
  final HomeViewModel viewModel;
  final VoidCallback onSwitchBackToSelf;

  const HomeHeader({
    super.key,
    required this.viewModel,
    required this.onSwitchBackToSelf,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 10, 0, 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'CGM COMPANION',
                style: TextStyle(
                  fontFamily: 'JetBrainsMono',
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.98,
                  color: AppColors.textDim,
                ),
              ),
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 190),
                child: SyncStatusCompactPanel(viewModel: viewModel.syncStatus),
              ),
            ],
          ),
          if (!viewModel.activeSubject.isSelf) ...[
            const SizedBox(height: 10),
            _ActiveSubjectPill(
              name: viewModel.activeSubject.displayName,
              source: viewModel.activeSubject.sourceLabel,
              onReset: onSwitchBackToSelf,
            ),
          ],
        ],
      ),
    );
  }
}

class _ActiveSubjectPill extends StatelessWidget {
  final String name;
  final String source;
  final VoidCallback onReset;

  const _ActiveSubjectPill({
    required this.name,
    required this.source,
    required this.onReset,
  });

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.green.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.green.withValues(alpha: 0.32)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
        child: Row(
          children: [
            const Icon(
              Icons.supervised_user_circle_rounded,
              color: AppColors.green,
              size: 18,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                '$name - $source',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: AppColors.text,
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            TextButton(
              onPressed: onReset,
              style: TextButton.styleFrom(
                foregroundColor: AppColors.green,
                padding: const EdgeInsets.symmetric(horizontal: 8),
                minimumSize: const Size(0, 30),
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: const Text(
                'My device',
                style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
