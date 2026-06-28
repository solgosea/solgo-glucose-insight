import 'package:flutter/material.dart';

import '../../../domain/status_level.dart';
import '../../styles/status_monitor_theme.dart';
import '../models/watch_detail_view_model.dart';
import 'primitives/watch_detail_primitives.dart';

class WatchDisplayPathStrip extends StatelessWidget {
  final WatchDetailViewModel viewModel;

  const WatchDisplayPathStrip({super.key, required this.viewModel});

  @override
  Widget build(BuildContext context) {
    final reachable = _levelFor(viewModel, 'xDrip+ Web Service reachable');
    final display = viewModel.displayEvidence.level;
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 14, 20, 0),
      child: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth < 460) {
            return Column(
              children: [
                WatchPathNode(
                  title: 'xDrip+',
                  subtitle: 'source',
                  level: reachable,
                ),
                const SizedBox(height: 8),
                WatchPathNode(
                  title: 'Web Service',
                  subtitle: _label(reachable),
                  level: reachable,
                ),
                const SizedBox(height: 8),
                WatchPathNode(
                  title: 'Watch display',
                  subtitle: _label(display),
                  level: display,
                ),
              ],
            );
          }
          return Row(
            children: [
              Expanded(
                child: WatchPathNode(
                  title: 'xDrip+',
                  subtitle: 'source',
                  level: reachable,
                ),
              ),
              const _Arrow(),
              Expanded(
                child: WatchPathNode(
                  title: 'Web Service',
                  subtitle: _label(reachable),
                  level: reachable,
                ),
              ),
              const _Arrow(),
              Expanded(
                child: WatchPathNode(
                  title: 'Watch display',
                  subtitle: _label(display),
                  level: display,
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  StatusLevel _levelFor(WatchDetailViewModel vm, String title) {
    for (final check in vm.pathChecks) {
      if (check.title == title) return check.level;
    }
    return StatusLevel.unknown;
  }

  String _label(StatusLevel level) {
    return switch (level) {
      StatusLevel.healthy => 'yes',
      StatusLevel.watch => 'watch',
      StatusLevel.issue => 'no',
      StatusLevel.unknown => 'unknown',
    };
  }
}

class _Arrow extends StatelessWidget {
  const _Arrow();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Text(
        '>',
        style: StatusMonitorTheme.mono.copyWith(
          color: StatusMonitorTheme.dim,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }
}
