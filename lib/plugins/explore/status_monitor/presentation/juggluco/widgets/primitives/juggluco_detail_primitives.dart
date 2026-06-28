import 'package:flutter/material.dart';

import '../../../../domain/juggluco/juggluco_path_state.dart';
import '../../../styles/status_monitor_theme.dart';

BoxDecoration jugglucoCardDecoration(Color accent) {
  return BoxDecoration(
    color: StatusMonitorTheme.card,
    borderRadius: BorderRadius.circular(15),
    border: Border.all(color: accent.withOpacity(.18)),
    boxShadow: const [
      BoxShadow(
        color: Color(0x29000000),
        blurRadius: 28,
        offset: Offset(0, 10),
      ),
    ],
  );
}

BoxDecoration jugglucoHeroDecoration() {
  return BoxDecoration(
    borderRadius: BorderRadius.circular(18),
    border: Border.all(color: StatusMonitorTheme.teal.withOpacity(.28)),
    gradient: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        StatusMonitorTheme.teal.withOpacity(.14),
        StatusMonitorTheme.green.withOpacity(.08),
        Colors.white.withOpacity(.025),
      ],
      stops: const [0, .56, 1],
    ),
    color: StatusMonitorTheme.card,
    boxShadow: const [
      BoxShadow(
        color: Color(0x3D000000),
        blurRadius: 42,
        offset: Offset(0, 16),
      ),
    ],
  );
}

Color jugglucoStateColor(JugglucoPathState state) {
  return switch (state) {
    JugglucoPathState.fresh => StatusMonitorTheme.green,
    JugglucoPathState.delayed => StatusMonitorTheme.amber,
    JugglucoPathState.stale ||
    JugglucoPathState.unavailable =>
      StatusMonitorTheme.rose,
    JugglucoPathState.waitingForFirstBroadcast ||
    JugglucoPathState.directOnly =>
      StatusMonitorTheme.amber,
    JugglucoPathState.notConfigured ||
    JugglucoPathState.unknown =>
      StatusMonitorTheme.muted,
  };
}

class JugglucoPathNode extends StatelessWidget {
  final String title;
  final String subtitle;
  final Color accent;

  const JugglucoPathNode({
    super.key,
    required this.title,
    required this.subtitle,
    required this.accent,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0x6B08110D),
        borderRadius: BorderRadius.circular(13),
        border: Border.all(color: accent.withOpacity(.20)),
      ),
      child: Column(
        children: [
          Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: StatusMonitorTheme.inter.copyWith(
              color: StatusMonitorTheme.text,
              fontSize: 11,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            subtitle.toUpperCase(),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: StatusMonitorTheme.mono.copyWith(
              color: accent,
              fontSize: 8.5,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }
}

class JugglucoPathArrow extends StatelessWidget {
  const JugglucoPathArrow({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5),
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

class JugglucoEvidenceTile extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  final String body;

  const JugglucoEvidenceTile({
    super.key,
    required this.label,
    required this.value,
    required this.color,
    required this.body,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: const Color(0x5908110D),
        borderRadius: BorderRadius.circular(13),
        border: Border.all(color: StatusMonitorTheme.line),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label.toUpperCase(),
            style: StatusMonitorTheme.mono.copyWith(
              color: StatusMonitorTheme.dim,
              fontSize: 8.5,
              fontWeight: FontWeight.w900,
              letterSpacing: 1,
            ),
          ),
          const SizedBox(height: 9),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: StatusMonitorTheme.mono.copyWith(
              color: color,
              fontSize: 18,
              fontWeight: FontWeight.w900,
              height: 1.05,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            body,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: StatusMonitorTheme.inter.copyWith(
              color: StatusMonitorTheme.soft,
              fontSize: 10.2,
              height: 1.35,
            ),
          ),
        ],
      ),
    );
  }
}

class JugglucoCheckRow extends StatelessWidget {
  final String index;
  final String title;
  final String body;
  final String badge;
  final Color color;
  final bool last;

  const JugglucoCheckRow({
    super.key,
    required this.index,
    required this.title,
    required this.body,
    required this.badge,
    required this.color,
    this.last = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(bottom: last ? 0 : 12, top: last ? 12 : 0),
      decoration: BoxDecoration(
        border: last
            ? null
            : Border(bottom: BorderSide(color: StatusMonitorTheme.line)),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final compact = constraints.maxWidth < 390;
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: color.withOpacity(.10),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: Text(
                    index,
                    style: StatusMonitorTheme.mono.copyWith(
                      color: color,
                      fontSize: 11,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: compact
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            softWrap: true,
                            style: _titleStyle(),
                          ),
                          const SizedBox(height: 6),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: JugglucoBadge(label: badge, color: color),
                          ),
                          const SizedBox(height: 7),
                          Text(
                            body,
                            softWrap: true,
                            style: _bodyStyle(),
                          ),
                        ],
                      )
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Text(
                                  title,
                                  softWrap: true,
                                  style: _titleStyle(),
                                ),
                              ),
                              const SizedBox(width: 8),
                              JugglucoBadge(label: badge, color: color),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            body,
                            softWrap: true,
                            style: _bodyStyle(),
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

  TextStyle _bodyStyle() {
    return StatusMonitorTheme.inter.copyWith(
      color: StatusMonitorTheme.soft,
      fontSize: 11,
      height: 1.42,
    );
  }
}

class JugglucoBadge extends StatelessWidget {
  final String label;
  final Color color;

  const JugglucoBadge({super.key, required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 96),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(999),
          border: Border.all(color: color.withOpacity(.65)),
        ),
        child: Text(
          label.toUpperCase(),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center,
          style: StatusMonitorTheme.mono.copyWith(
            color: color,
            fontSize: 9,
            fontWeight: FontWeight.w900,
          ),
        ),
      ),
    );
  }
}

class JugglucoLegendDot extends StatelessWidget {
  final String label;
  final Color color;

  const JugglucoLegendDot({
    super.key,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 9,
          height: 9,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(3),
          ),
        ),
        const SizedBox(width: 5),
        Text(
          label,
          style: StatusMonitorTheme.inter.copyWith(
            color: StatusMonitorTheme.soft,
            fontSize: 10.5,
          ),
        ),
      ],
    );
  }
}
