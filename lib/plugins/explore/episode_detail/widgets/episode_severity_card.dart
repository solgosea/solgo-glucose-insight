import 'package:flutter/material.dart';
import 'package:smart_xdrip/foundation/theme/app_colors.dart';

import '../models/episode_severity_view_model.dart';

class EpisodeSeverityCard extends StatelessWidget {
  final EpisodeSeverityViewModel viewModel;

  const EpisodeSeverityCard({super.key, required this.viewModel});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 0, 20, 12),
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
      decoration: BoxDecoration(
        color: AppColors.bgCard,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'SEVERITY',
            style: TextStyle(
              fontFamily: 'JetBrainsMono',
              fontSize: 9,
              fontWeight: FontWeight.w600,
              color: AppColors.textDim,
              letterSpacing: 1.4,
            ),
          ),
          const SizedBox(height: 10),
          for (var i = 0; i < viewModel.rows.length; i++)
            _SeverityRow(
              row: viewModel.rows[i],
              isLast: i == viewModel.rows.length - 1,
            ),
          const SizedBox(height: 10),
          Text(
            viewModel.footnote,
            style: const TextStyle(
              fontFamily: 'JetBrainsMono',
              fontSize: 9,
              color: AppColors.textDim,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}

class _SeverityRow extends StatelessWidget {
  final EpisodeSeverityRowViewModel row;
  final bool isLast;

  const _SeverityRow({required this.row, required this.isLast});

  @override
  Widget build(BuildContext context) {
    final color = _colorFor(row.level);
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        border:
            isLast
                ? null
                : const Border(bottom: BorderSide(color: AppColors.border)),
      ),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              width: 4,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        row.label,
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: color,
                          height: 1.3,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Flexible(
                        child: Text(
                          row.range,
                          style: const TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 10,
                            color: AppColors.textDim,
                          ),
                        ),
                      ),
                      const SizedBox(width: 6),
                      if (row.isCurrent) const _CurrentBadge(),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    row.description,
                    style: const TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 12,
                      color: AppColors.textSoft,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _colorFor(EpisodeSeverityLevel level) {
    switch (level) {
      case EpisodeSeverityLevel.mild:
        return AppColors.amber;
      case EpisodeSeverityLevel.significant:
        return AppColors.rose;
      case EpisodeSeverityLevel.severe:
        return const Color(0xFFC0504A);
    }
  }
}

class _CurrentBadge extends StatelessWidget {
  const _CurrentBadge();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.amber.withOpacity(0.45)),
        borderRadius: BorderRadius.circular(4),
      ),
      child: const Text(
        'THIS EPISODE',
        style: TextStyle(
          fontFamily: 'JetBrainsMono',
          fontSize: 9,
          fontWeight: FontWeight.w600,
          color: AppColors.amber,
          letterSpacing: 0.4,
        ),
      ),
    );
  }
}
