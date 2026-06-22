import 'package:flutter/material.dart';

import '../../../../application/text/status_aaps_text_builder.dart';
import '../../../styles/status_monitor_theme.dart';

class AapsSafetyNotice extends StatelessWidget {
  const AapsSafetyNotice({super.key});

  @override
  Widget build(BuildContext context) {
    const textBuilder = StatusAapsTextBuilder();
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 0, 20, 16),
      padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 12),
      decoration: BoxDecoration(
        color: StatusMonitorTheme.blue.withOpacity(.06),
        borderRadius: BorderRadius.circular(13),
        border: Border.all(color: StatusMonitorTheme.blue.withOpacity(.20)),
      ),
      child: Text(
        textBuilder.safetyNotice(),
        style: StatusMonitorTheme.inter.copyWith(
          color: StatusMonitorTheme.soft,
          fontSize: 11.5,
          height: 1.45,
        ),
      ),
    );
  }
}
