import 'package:flutter/material.dart';

import '../../styles/status_monitor_theme.dart';
import '../models/watch_detail_view_model.dart';
import 'primitives/watch_detail_primitives.dart';

class WatchDetailHeroCard extends StatelessWidget {
  final WatchDetailViewModel viewModel;

  const WatchDetailHeroCard({super.key, required this.viewModel});

  @override
  Widget build(BuildContext context) {
    final color = StatusMonitorTheme.colorFor(viewModel.state);
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: color.withOpacity(.26)),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            color.withOpacity(.14),
            StatusMonitorTheme.blue.withOpacity(.07),
            Colors.white.withOpacity(.025),
          ],
          stops: const [0, .58, 1],
        ),
        color: StatusMonitorTheme.card,
        boxShadow: const [
          BoxShadow(
            color: Color(0x3D000000),
            blurRadius: 42,
            offset: Offset(0, 16),
          ),
        ],
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final compact = constraints.maxWidth < 430;
          final text = Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 46,
                    height: 46,
                    decoration: BoxDecoration(
                      color: color.withOpacity(.10),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: color.withOpacity(.30)),
                    ),
                    child: Icon(Icons.watch_rounded, color: color),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          viewModel.headline,
                          style: StatusMonitorTheme.inter.copyWith(
                            color: StatusMonitorTheme.text,
                            fontSize: 20,
                            height: 1.06,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          viewModel.summary,
                          style: StatusMonitorTheme.inter.copyWith(
                            color: StatusMonitorTheme.soft,
                            fontSize: 12,
                            height: 1.45,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              Wrap(
                spacing: 7,
                runSpacing: 7,
                children: [
                  _SignalChip('xDrip ${viewModel.latestXdripEntryLabel}'),
                  _SignalChip('Web ${viewModel.xdripWebResponseLabel}'),
                  _SignalChip('Watch ${viewModel.latestWatchEvidenceLabel}'),
                ],
              ),
            ],
          );
          if (compact) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                text,
                const SizedBox(height: 15),
                WatchScoreRing(score: viewModel.score, level: viewModel.state),
              ],
            );
          }
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: text),
              const SizedBox(width: 16),
              WatchScoreRing(score: viewModel.score, level: viewModel.state),
            ],
          );
        },
      ),
    );
  }
}

class _SignalChip extends StatelessWidget {
  final String label;

  const _SignalChip(this.label);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: StatusMonitorTheme.line),
        color: Colors.white.withOpacity(.025),
      ),
      child: Text(
        label,
        style: StatusMonitorTheme.mono.copyWith(
          color: StatusMonitorTheme.soft,
          fontSize: 10.5,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}
