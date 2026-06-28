import 'package:flutter/material.dart';

import '../../styles/status_monitor_theme.dart';
import '../models/watch_detail_view_model.dart';
import 'primitives/watch_detail_primitives.dart';

class WatchPathChecksCard extends StatelessWidget {
  final List<WatchPathCheckViewModel> checks;

  const WatchPathChecksCard({super.key, required this.checks});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(14),
      decoration: watchCardDecoration(),
      child: Column(
        children: [
          for (var index = 0; index < checks.length; index++)
            _CheckRow(
              check: checks[index],
              last: index == checks.length - 1,
            ),
        ],
      ),
    );
  }
}

class _CheckRow extends StatelessWidget {
  final WatchPathCheckViewModel check;
  final bool last;

  const _CheckRow({required this.check, required this.last});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(bottom: last ? 0 : 12, top: last ? 0 : 12),
      decoration: BoxDecoration(
        border: last
            ? null
            : Border(bottom: BorderSide(color: StatusMonitorTheme.line)),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final compact = constraints.maxWidth < 380;
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              WatchStatusMark(level: check.level),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (compact) ...[
                      Text(check.title, style: _titleStyle()),
                      const SizedBox(height: 5),
                      _ValueBadge(value: check.valueLabel, level: check.level),
                    ] else
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                              child: Text(check.title, style: _titleStyle())),
                          const SizedBox(width: 8),
                          _ValueBadge(
                            value: check.valueLabel,
                            level: check.level,
                          ),
                        ],
                      ),
                    const SizedBox(height: 5),
                    Text(
                      check.body,
                      style: StatusMonitorTheme.inter.copyWith(
                        color: StatusMonitorTheme.soft,
                        fontSize: 11,
                        height: 1.42,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      check.sourceLabel,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: StatusMonitorTheme.mono.copyWith(
                        color: StatusMonitorTheme.dim,
                        fontSize: 9,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  TextStyle _titleStyle() {
    return StatusMonitorTheme.inter.copyWith(
      color: StatusMonitorTheme.text,
      fontSize: 12.5,
      height: 1.22,
      fontWeight: FontWeight.w900,
    );
  }
}

class _ValueBadge extends StatelessWidget {
  final String value;
  final dynamic level;

  const _ValueBadge({required this.value, required this.level});

  @override
  Widget build(BuildContext context) {
    final color = StatusMonitorTheme.colorFor(level);
    return Container(
      constraints: const BoxConstraints(maxWidth: 118),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: color.withOpacity(.60)),
      ),
      child: Text(
        value.toUpperCase(),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        textAlign: TextAlign.center,
        style: StatusMonitorTheme.mono.copyWith(
          color: color,
          fontSize: 9,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }
}
