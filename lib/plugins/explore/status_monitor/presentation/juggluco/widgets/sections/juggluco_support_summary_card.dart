import 'package:flutter/material.dart';

import '../../../../domain/juggluco/juggluco_detail_data.dart';
import '../../../styles/status_monitor_theme.dart';

class JugglucoSupportSummaryCard extends StatelessWidget {
  final JugglucoDetailData data;

  const JugglucoSupportSummaryCard({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: StatusMonitorTheme.blue.withOpacity(.055),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: StatusMonitorTheme.blue.withOpacity(.20)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Status Monitor - Juggluco',
            style: StatusMonitorTheme.inter.copyWith(
              color: StatusMonitorTheme.text,
              fontSize: 12.5,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 9),
          SelectableText(
            data.supportSummary,
            style: StatusMonitorTheme.mono.copyWith(
              color: StatusMonitorTheme.soft,
              fontSize: 10.5,
              height: 1.55,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}
