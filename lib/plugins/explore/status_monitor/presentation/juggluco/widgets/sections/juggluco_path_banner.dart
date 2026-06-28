import 'package:flutter/material.dart';

import '../../../../domain/juggluco/juggluco_detail_data.dart';
import '../../../styles/status_monitor_theme.dart';
import '../primitives/juggluco_detail_primitives.dart';

class JugglucoPathBanner extends StatelessWidget {
  final JugglucoDetailData data;
  final bool embedded;

  const JugglucoPathBanner({
    super.key,
    required this.data,
    this.embedded = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin:
          embedded ? EdgeInsets.zero : const EdgeInsets.fromLTRB(20, 18, 20, 0),
      padding: embedded ? EdgeInsets.zero : const EdgeInsets.all(12),
      decoration:
          embedded ? null : jugglucoCardDecoration(StatusMonitorTheme.teal),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: JugglucoPathNode(
                  title: 'Juggluco',
                  subtitle: data.latestLabel,
                  accent: jugglucoStateColor(data.pathState),
                ),
              ),
              const JugglucoPathArrow(),
              Expanded(
                child: JugglucoPathNode(
                  title: 'xDrip+',
                  subtitle: data.chainComparison.xdripAgeLabel,
                  accent: StatusMonitorTheme.green,
                ),
              ),
              const JugglucoPathArrow(),
              Expanded(
                child: JugglucoPathNode(
                  title: 'Nightscout',
                  subtitle: data.chainComparison.nightscoutAgeLabel,
                  accent: data.chainComparison.nightscoutAgeLabel == 'Unknown'
                      ? StatusMonitorTheme.dim
                      : StatusMonitorTheme.amber,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: StatusMonitorTheme.green.withOpacity(.07),
              borderRadius: BorderRadius.circular(13),
              border: Border.all(
                color: StatusMonitorTheme.green.withOpacity(.22),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Likely focus: ${data.chainComparison.focus.label}',
                  style: StatusMonitorTheme.inter.copyWith(
                    color: StatusMonitorTheme.text,
                    fontSize: 13,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  data.chainComparison.message,
                  style: StatusMonitorTheme.inter.copyWith(
                    color: StatusMonitorTheme.soft,
                    fontSize: 11.5,
                    height: 1.45,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
