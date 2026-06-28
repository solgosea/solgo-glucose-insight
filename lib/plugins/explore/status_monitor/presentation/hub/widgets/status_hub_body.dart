import 'package:flutter/material.dart';

import '../models/status_hub_view_model.dart';
import 'status_hub_connection_details_section.dart';
import 'status_hub_connection_map_section.dart';
import 'status_hub_disclaimer_footer.dart';
import 'status_hub_summary_section.dart';

class StatusHubBody extends StatelessWidget {
  final StatusHubViewModel viewModel;

  const StatusHubBody({
    super.key,
    required this.viewModel,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        StatusHubSummarySection(viewModel: viewModel),
        StatusHubConnectionMapSection(viewModel: viewModel),
        StatusHubConnectionDetailsSection(
          connections: viewModel.detailConnections,
        ),
        StatusHubDisclaimerFooter(viewModel: viewModel),
        const SizedBox(height: 32),
      ],
    );
  }
}
