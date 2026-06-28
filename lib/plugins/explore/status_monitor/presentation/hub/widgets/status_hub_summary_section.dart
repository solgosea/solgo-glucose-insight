import 'package:flutter/material.dart';

import '../../../domain/hub/status_hub_enums.dart';
import '../../../domain/status_level.dart';
import '../models/status_hub_view_model.dart';
import 'status_hub_visuals.dart';
import '../../styles/status_monitor_theme.dart';

class StatusHubSummarySection extends StatelessWidget {
  final StatusHubViewModel viewModel;

  const StatusHubSummarySection({
    super.key,
    required this.viewModel,
  });

  @override
  Widget build(BuildContext context) {
    final color = StatusHubVisuals.colorFor(viewModel.summary.state);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        decoration: StatusMonitorTheme.glassCardDecoration(
          elevated: true,
        ).copyWith(
          border: Border.all(color: color.withOpacity(.34)),
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: color.withOpacity(.12),
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(color: color.withOpacity(.36)),
                  ),
                  child: Center(
                    child: Text(
                      'X',
                      style: StatusMonitorTheme.mono.copyWith(
                        color: color,
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        viewModel.summary.headline,
                        style: StatusMonitorTheme.inter.copyWith(
                          color: StatusMonitorTheme.text,
                          fontSize: 18.5,
                          fontWeight: FontWeight.w900,
                          height: 1.13,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        viewModel.summary.body,
                        style: StatusMonitorTheme.inter.copyWith(
                          color: StatusMonitorTheme.soft,
                          fontSize: 12,
                          height: 1.38,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                StatusHubPill(
                  label:
                      StatusHubVisuals.displayLabelFor(viewModel.summary.state),
                  state: viewModel.summary.state,
                ),
              ],
            ),
            const SizedBox(height: 12),
            _ScoreStrip(viewModel: viewModel),
            const SizedBox(height: 12),
            _FocusStrip(
              focus: viewModel.focus,
              trailingLabel: _priorityChip(viewModel),
            ),
          ],
        ),
      ),
    );
  }

  /// The chip label of the connection currently flagged as priority focus,
  /// shown on the right of the focus strip (e.g. "24m"). Falls back to the
  /// focus badge when no priority connection is present.
  String _priorityChip(StatusHubViewModel viewModel) {
    for (final connection in viewModel.detailConnections) {
      if (connection.priority && connection.chipLabel.isNotEmpty) {
        return connection.chipLabel;
      }
    }
    return viewModel.focus.badgeLabel;
  }
}

class _ScoreStrip extends StatelessWidget {
  final StatusHubViewModel viewModel;

  const _ScoreStrip({required this.viewModel});

  @override
  Widget build(BuildContext context) {
    final focusScore = _focusScore(viewModel);
    return LayoutBuilder(
      builder: (context, constraints) {
        final compact = constraints.maxWidth < 420;
        final children = [
          _ScoreTile(
            label: 'Evidence',
            value: viewModel.evidence.ratioLabel,
            color: StatusMonitorTheme.green,
          ),
          _ScoreTile(
            label: 'Confidence',
            value: viewModel.evidence.confidenceLabel,
            color: StatusMonitorTheme.blue,
          ),
          _ScoreTile(
            label: 'Focus score',
            value: focusScore,
            color: StatusMonitorTheme.amber,
          ),
        ];
        if (compact) {
          return Column(
            children: [
              for (var i = 0; i < children.length; i++) ...[
                if (i > 0) const SizedBox(height: 8),
                children[i],
              ],
            ],
          );
        }
        return Row(
          children: [
            for (var i = 0; i < children.length; i++) ...[
              if (i > 0) const SizedBox(width: 8),
              Expanded(child: children[i]),
            ],
          ],
        );
      },
    );
  }

  String _focusScore(StatusHubViewModel viewModel) {
    for (final connection in viewModel.detailConnections) {
      if (connection.priority) return connection.diagnosisScoreLabel;
    }
    return '--';
  }
}

class _ScoreTile extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _ScoreTile({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 10),
      decoration: BoxDecoration(
        color: color.withOpacity(.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(.22)),
      ),
      child: Row(
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              label.toUpperCase(),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: StatusMonitorTheme.mono.copyWith(
                color: StatusMonitorTheme.dim,
                fontSize: 9,
                fontWeight: FontWeight.w900,
                letterSpacing: .35,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            value,
            style: StatusMonitorTheme.mono.copyWith(
              color: StatusMonitorTheme.text,
              fontSize: 12.5,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }
}

class _FocusStrip extends StatelessWidget {
  final StatusHubFocusViewModel focus;
  final String trailingLabel;

  const _FocusStrip({required this.focus, required this.trailingLabel});

  @override
  Widget build(BuildContext context) {
    final color = StatusMonitorTheme.colorFor(focus.severity);
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: color.withOpacity(.10),
        borderRadius: BorderRadius.circular(13),
        border: Border.all(color: color.withOpacity(.28)),
      ),
      child: Stack(
        children: [
          // Glowing left accent bar (HTML .focus-strip::before).
          Positioned(
            left: 0,
            top: 0,
            bottom: 0,
            child: Container(
              width: 3,
              decoration: BoxDecoration(
                color: color,
                boxShadow: [
                  BoxShadow(color: color.withOpacity(.8), blurRadius: 12),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 12, 12, 12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${focus.badgeLabel}: ${focus.headline}',
                        style: StatusMonitorTheme.inter.copyWith(
                          color: StatusMonitorTheme.text,
                          fontSize: 13.5,
                          fontWeight: FontWeight.w900,
                          height: 1.25,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        focus.body,
                        style: StatusMonitorTheme.inter.copyWith(
                          color: StatusMonitorTheme.soft,
                          fontSize: 11,
                          height: 1.34,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                StatusHubPill(
                  label: trailingLabel,
                  state: _stateForSeverity(focus.severity),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  StatusHubState _stateForSeverity(StatusLevel level) {
    return switch (level) {
      StatusLevel.healthy => StatusHubState.fresh,
      StatusLevel.watch => StatusHubState.delayed,
      StatusLevel.issue => StatusHubState.stale,
      StatusLevel.unknown => StatusHubState.limited,
    };
  }
}
