import 'package:flutter/material.dart';

import '../../../../domain/component_health.dart';
import '../../../../domain/juggluco/juggluco_detail_data.dart';
import '../../../styles/status_monitor_theme.dart';
import '../primitives/juggluco_detail_primitives.dart';
import 'juggluco_path_banner.dart';

class JugglucoHeroCard extends StatelessWidget {
  final ComponentHealth component;
  final JugglucoDetailData data;

  const JugglucoHeroCard({
    super.key,
    required this.component,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    final color = jugglucoStateColor(data.pathState);
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 18, 20, 0),
      padding: const EdgeInsets.all(16),
      decoration: jugglucoHeroDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              JugglucoHeroIcon(color: StatusMonitorTheme.teal),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Juggluco',
                      style: StatusMonitorTheme.inter.copyWith(
                        color: StatusMonitorTheme.text,
                        fontSize: 21,
                        height: 1.08,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Observe the real outbound path Juggluco uses to hand glucose data toward xDrip+.',
                      style: StatusMonitorTheme.inter.copyWith(
                        color: StatusMonitorTheme.soft,
                        fontSize: 12,
                        height: 1.48,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '${component.score?.value ?? 0}',
                    style: StatusMonitorTheme.mono.copyWith(
                      color: color,
                      fontSize: 34,
                      height: 1,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    data.stateLabel.toUpperCase(),
                    style: StatusMonitorTheme.mono.copyWith(
                      color: StatusMonitorTheme.soft,
                      fontSize: 10,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1.2,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 15),
          JugglucoPathBanner(data: data, embedded: true),
        ],
      ),
    );
  }
}

class JugglucoHeroIcon extends StatelessWidget {
  final Color color;

  const JugglucoHeroIcon({super.key, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: color.withOpacity(.11),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: color.withOpacity(.30)),
      ),
      child: Icon(Icons.phone_android_rounded, color: color, size: 25),
    );
  }
}
