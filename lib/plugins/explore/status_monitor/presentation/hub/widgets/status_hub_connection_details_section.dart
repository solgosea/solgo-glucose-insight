import 'package:flutter/material.dart';

import '../models/status_hub_view_model.dart';
import 'status_hub_visuals.dart';
import '../../styles/status_monitor_theme.dart';

class StatusHubConnectionDetailsSection extends StatelessWidget {
  final List<StatusHubConnectionViewModel> connections;

  const StatusHubConnectionDetailsSection({
    super.key,
    required this.connections,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const StatusHubSectionTitle(
          title: 'Connection details',
          trailing: 'where to look first',
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: _ConnectionGrid(connections: connections),
        ),
      ],
    );
  }
}

/// Flows the connection cards into as many columns as the available width
/// allows. Phones get a single column; wider tablets get 2–3 columns. The
/// column count is derived from width, never hard-coded into a fixed grid.
class _ConnectionGrid extends StatelessWidget {
  final List<StatusHubConnectionViewModel> connections;

  /// Minimum comfortable width for a single card before adding a column.
  static const double _minCardWidth = 320;
  static const double _gap = 10;

  const _ConnectionGrid({required this.connections});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final columns = (width / (_minCardWidth + _gap))
            .floor()
            .clamp(1, connections.length);
        if (columns <= 1) {
          return Column(
            children: [
              for (final connection in connections) ...[
                _ConnectionCard(connection: connection),
                const SizedBox(height: _gap),
              ],
            ],
          );
        }
        final cardWidth = (width - _gap * (columns - 1)) / columns;
        return Wrap(
          spacing: _gap,
          runSpacing: _gap,
          children: [
            for (final connection in connections)
              SizedBox(
                width: cardWidth,
                child: _ConnectionCard(connection: connection),
              ),
          ],
        );
      },
    );
  }
}

class _ConnectionCard extends StatelessWidget {
  final StatusHubConnectionViewModel connection;

  const _ConnectionCard({required this.connection});

  @override
  Widget build(BuildContext context) {
    final color = StatusHubVisuals.colorFor(connection.state);
    final muted = connection.state.name == 'notChecked' ||
        connection.state.name == 'unknown';
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: StatusMonitorTheme.glassCardDecoration().copyWith(
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: connection.priority
              ? color.withOpacity(.58)
              : StatusMonitorTheme.line,
        ),
      ),
      child: Stack(
        children: [
          // Left accent bar with glow (HTML .conn-card::before).
          Positioned(
            left: 0,
            top: 0,
            bottom: 0,
            child: Container(
              width: 3,
              decoration: BoxDecoration(
                color: color,
                boxShadow: muted
                    ? null
                    : [BoxShadow(color: color.withOpacity(.7), blurRadius: 12)],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(17, 13, 14, 13),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child:
                          _ConnectionPair(connection: connection, color: color),
                    ),
                    const SizedBox(width: 8),
                    StatusHubPill(
                      label: connection.stateLabel,
                      state: connection.state,
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  connection.userSummary,
                  style: StatusMonitorTheme.inter.copyWith(
                    color: StatusMonitorTheme.soft,
                    fontSize: 11.5,
                    height: 1.32,
                  ),
                ),
                const SizedBox(height: 12),
                _PathScoreHeader(connection: connection),
                const SizedBox(height: 10),
                const _ZoneLabel(label: 'Connection signals'),
                _MetricRow(connection: connection, accent: color),
                const SizedBox(height: 10),
                _ScoreBreakdown(connection: connection),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PathScoreHeader extends StatelessWidget {
  final StatusHubConnectionViewModel connection;

  const _PathScoreHeader({required this.connection});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _PathScoreGauge(score: connection.pathScore),
          const SizedBox(width: 13),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Path score · ${connection.pathScore.overallLabel}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: StatusMonitorTheme.inter.copyWith(
                    color: StatusMonitorTheme.text,
                    fontSize: 13,
                    fontWeight: FontWeight.w900,
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  '${connection.pathScore.overallScore.round()} / 100 · weighted',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: StatusMonitorTheme.mono.copyWith(
                    color: StatusMonitorTheme.dim,
                    fontSize: 10,
                    letterSpacing: .4,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                if (connection.pathScore.isCapped) ...[
                  const SizedBox(height: 5),
                  Text(
                    '${connection.pathScore.capLabel}: '
                    '${connection.pathScore.capExplanation}',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: StatusMonitorTheme.inter.copyWith(
                      color: StatusMonitorTheme.soft,
                      fontSize: 10.5,
                      height: 1.25,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PathScoreGauge extends StatelessWidget {
  final StatusHubPathScoreViewModel score;

  const _PathScoreGauge({required this.score});

  @override
  Widget build(BuildContext context) {
    final color = StatusHubVisuals.colorFor(score.state);
    final value = (score.overallScore / 100).clamp(0.0, 1.0);
    return SizedBox(
      width: 54,
      height: 54,
      child: Stack(
        alignment: Alignment.center,
        children: [
          SizedBox(
            width: 54,
            height: 54,
            child: CircularProgressIndicator(
              value: value,
              strokeWidth: 5,
              strokeCap: StrokeCap.round,
              color: color,
              backgroundColor: Colors.white.withOpacity(.07),
            ),
          ),
          Text(
            score.overallScore.round().toString(),
            style: StatusMonitorTheme.mono.copyWith(
              color: StatusMonitorTheme.text,
              fontSize: 16,
              fontWeight: FontWeight.w900,
              height: 1,
            ),
          ),
        ],
      ),
    );
  }
}

class _ZoneLabel extends StatelessWidget {
  final String label;

  const _ZoneLabel({required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          label.toUpperCase(),
          style: StatusMonitorTheme.mono.copyWith(
            color: StatusMonitorTheme.dim,
            fontSize: 9,
            fontWeight: FontWeight.w900,
            letterSpacing: 1.1,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Container(height: 1, color: StatusMonitorTheme.line),
        ),
      ],
    );
  }
}

class _ScoreBreakdown extends StatelessWidget {
  final StatusHubConnectionViewModel connection;

  const _ScoreBreakdown({required this.connection});

  @override
  Widget build(BuildContext context) {
    final metrics = connection.pathScore.metrics;
    if (metrics.isEmpty) return const SizedBox.shrink();
    return Container(
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: StatusMonitorTheme.line)),
      ),
      child: Theme(
        data: Theme.of(context).copyWith(
          dividerColor: Colors.transparent,
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
        ),
        child: ExpansionTile(
          tilePadding: EdgeInsets.zero,
          childrenPadding: const EdgeInsets.only(top: 2, bottom: 2),
          initiallyExpanded: false,
          title: Row(
            children: [
              Text(
                'Score breakdown',
                style: StatusMonitorTheme.mono.copyWith(
                  color: StatusMonitorTheme.soft,
                  fontSize: 10,
                  fontWeight: FontWeight.w900,
                  letterSpacing: .5,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                '${metrics.length} metrics',
                style: StatusMonitorTheme.mono.copyWith(
                  color: StatusMonitorTheme.dim,
                  fontSize: 9,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          iconColor: StatusMonitorTheme.dim,
          collapsedIconColor: StatusMonitorTheme.dim,
          children: [
            for (final metric in metrics) _ScoreMetricBarRow(metric: metric),
          ],
        ),
      ),
    );
  }
}

class _ScoreMetricBarRow extends StatelessWidget {
  final StatusHubPathMetricScoreViewModel metric;

  const _ScoreMetricBarRow({required this.metric});

  @override
  Widget build(BuildContext context) {
    final color = StatusHubVisuals.colorFor(metric.state);
    final value = metric.normalizedScore.clamp(0, 100) / 100;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: [
          SizedBox(
            width: 92,
            child: Text.rich(
              TextSpan(
                text: metric.label,
                children: [
                  TextSpan(
                    text: ' · ${_weightFor(metric.label)}',
                    style: StatusMonitorTheme.mono.copyWith(
                      color: StatusMonitorTheme.dim,
                      fontSize: 8.5,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: StatusMonitorTheme.inter.copyWith(
                color: StatusMonitorTheme.soft,
                fontSize: 11,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          const SizedBox(width: 9),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(999),
              child: LinearProgressIndicator(
                value: value,
                minHeight: 6,
                color: color,
                backgroundColor: Colors.white.withOpacity(.06),
              ),
            ),
          ),
          const SizedBox(width: 9),
          SizedBox(
            width: 54,
            child: Text(
              metric.rawValue,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.right,
              style: StatusMonitorTheme.mono.copyWith(
                color: StatusMonitorTheme.text,
                fontSize: 10,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _weightFor(String label) {
    return switch (label) {
      'Freshness' => '30%',
      'Delay' => '25%',
      'Evidence' => '20%',
      'Confidence' => '15%',
      'Path health' => '10%',
      _ => '',
    };
  }
}

class _ConnectionPair extends StatelessWidget {
  final StatusHubConnectionViewModel connection;
  final Color color;

  const _ConnectionPair({required this.connection, required this.color});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Flexible(child: _node(connection.fromLabel)),
        const SizedBox(width: 8),
        Icon(Icons.arrow_forward_rounded, size: 14, color: color),
        const SizedBox(width: 8),
        Flexible(child: _node(connection.toLabel)),
      ],
    );
  }

  Widget _node(String label) {
    final isHub = label.toLowerCase().startsWith('xdrip');
    final iconColor = isHub ? StatusMonitorTheme.green : color;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _NodeBadge(label: label, color: iconColor, hub: isHub),
        const SizedBox(width: 6),
        Flexible(
          child: Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: StatusMonitorTheme.inter.copyWith(
              color: StatusMonitorTheme.text,
              fontSize: 13,
              fontWeight: FontWeight.w900,
              height: 1.1,
            ),
          ),
        ),
      ],
    );
  }
}

class _NodeBadge extends StatelessWidget {
  final String label;
  final Color color;
  final bool hub;

  const _NodeBadge({
    required this.label,
    required this.color,
    required this.hub,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 24,
      height: 24,
      decoration: BoxDecoration(
        color: color.withOpacity(hub ? .12 : .09),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(hub ? .4 : .3)),
      ),
      child: Center(
        child: Text(
          hub
              ? 'X'
              : (label.isEmpty ? '?' : label.substring(0, 1).toUpperCase()),
          style: StatusMonitorTheme.mono.copyWith(
            color: color,
            fontSize: 10,
            fontWeight: FontWeight.w900,
          ),
        ),
      ),
    );
  }
}

class _MetricRow extends StatelessWidget {
  final StatusHubConnectionViewModel connection;
  final Color accent;

  const _MetricRow({required this.connection, required this.accent});

  @override
  Widget build(BuildContext context) {
    final metrics = connection.metrics;
    if (metrics.isEmpty) return const SizedBox.shrink();
    return LayoutBuilder(
      builder: (context, constraints) {
        const gap = 8.0;
        final columns = constraints.maxWidth >= 380 ? 3 : 2;
        final width = (constraints.maxWidth - gap * (columns - 1)) / columns;
        return Wrap(
          spacing: gap,
          runSpacing: gap,
          children: [
            for (final metric in metrics)
              SizedBox(
                width: width,
                child: _MetricChip(metric: metric, accent: accent),
              ),
          ],
        );
      },
    );
  }
}

class _MetricChip extends StatelessWidget {
  final StatusHubMetricFactViewModel metric;
  final Color accent;

  const _MetricChip({
    required this.metric,
    required this.accent,
  });

  @override
  Widget build(BuildContext context) {
    final state = metric.state;
    final color = state == null ? accent : StatusHubVisuals.colorFor(state);
    final score = metric.normalizedScore;
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: const Color(0x66081711),
        borderRadius: BorderRadius.circular(11),
        border: Border.all(color: StatusMonitorTheme.line),
      ),
      child: Stack(
        children: [
          // Top accent line (HTML .metric-mini div::before).
          Positioned(
            left: 9,
            right: 9,
            top: 0,
            child: Container(
              height: 2,
              decoration: BoxDecoration(
                color: color.withOpacity(.55),
                borderRadius: BorderRadius.circular(99),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 9, 8, 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        metric.value,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: StatusMonitorTheme.mono.copyWith(
                          color: StatusMonitorTheme.text,
                          fontSize: 12,
                          fontWeight: FontWeight.w900,
                          height: 1.1,
                        ),
                      ),
                    ),
                    if (score != null) ...[
                      const SizedBox(width: 4),
                      Text(
                        score.round().toString(),
                        style: StatusMonitorTheme.mono.copyWith(
                          color: color,
                          fontSize: 10,
                          fontWeight: FontWeight.w900,
                          height: 1,
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 5),
                Text(
                  metric.label.toUpperCase(),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: StatusMonitorTheme.mono.copyWith(
                    color: StatusMonitorTheme.dim,
                    fontSize: 9,
                    fontWeight: FontWeight.w800,
                    letterSpacing: .4,
                    height: 1.2,
                  ),
                ),
                if (metric.targetLabel.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    metric.targetLabel,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: StatusMonitorTheme.inter.copyWith(
                      color: StatusMonitorTheme.dim,
                      fontSize: 9.5,
                      fontWeight: FontWeight.w700,
                      height: 1.15,
                    ),
                  ),
                ],
                if (metric.stars != null) ...[
                  const SizedBox(height: 5),
                  _MiniStars(stars: metric.stars!, color: color),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MiniStars extends StatelessWidget {
  final int stars;
  final Color color;

  const _MiniStars({required this.stars, required this.color});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (var i = 0; i < 5; i++)
          Icon(
            i < stars ? Icons.star_rounded : Icons.star_border_rounded,
            size: 10,
            color: i < stars ? color : StatusMonitorTheme.dim,
          ),
      ],
    );
  }
}
