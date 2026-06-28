import 'package:flutter/material.dart';

import '../models/status_hub_view_model.dart';
import '../../styles/status_monitor_theme.dart';

class StatusHubObserverNote extends StatelessWidget {
  final StatusHubViewModel viewModel;

  const StatusHubObserverNote({
    super.key,
    required this.viewModel,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: StatusMonitorTheme.teal.withOpacity(.06),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: StatusMonitorTheme.teal.withOpacity(.22)),
      ),
      child: Row(
        children: [
          Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              color: StatusMonitorTheme.teal.withOpacity(.10),
              borderRadius: BorderRadius.circular(11),
              border:
                  Border.all(color: StatusMonitorTheme.teal.withOpacity(.28)),
            ),
            child: const Icon(
              Icons.visibility_rounded,
              color: StatusMonitorTheme.teal,
              size: 16,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  viewModel.observerNote.title,
                  style: StatusMonitorTheme.inter.copyWith(
                    color: StatusMonitorTheme.text,
                    fontSize: 11.5,
                    fontWeight: FontWeight.w900,
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  viewModel.observerNote.body,
                  style: StatusMonitorTheme.inter.copyWith(
                    color: StatusMonitorTheme.soft,
                    fontSize: 10.5,
                    height: 1.3,
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
