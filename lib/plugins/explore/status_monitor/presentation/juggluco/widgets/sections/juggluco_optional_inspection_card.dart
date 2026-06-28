import 'package:flutter/material.dart';

import '../../../../domain/juggluco/juggluco_detail_data.dart';
import '../../../styles/status_monitor_theme.dart';
import '../primitives/juggluco_detail_primitives.dart';

class JugglucoOptionalInspectionCard extends StatelessWidget {
  final JugglucoDetailData data;

  const JugglucoOptionalInspectionCard({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(14),
      decoration: jugglucoCardDecoration(StatusMonitorTheme.blue),
      child: JugglucoCheckRow(
        index: 'i',
        title: 'Juggluco Web Server',
        body: data.optionalInspection.message,
        badge: data.optionalInspection.stateLabel,
        color: StatusMonitorTheme.blue,
        last: true,
      ),
    );
  }
}
