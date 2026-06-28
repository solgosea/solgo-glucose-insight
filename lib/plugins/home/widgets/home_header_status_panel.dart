import 'package:flutter/widgets.dart';

import '../../../presentation/common/sync_status/sync_status_compact_panel.dart';
import '../../../presentation/common/sync_status/sync_status_view_model.dart';

class HomeHeaderStatusPanel extends StatelessWidget {
  final SyncStatusViewModel viewModel;

  const HomeHeaderStatusPanel({
    super.key,
    required this.viewModel,
  });

  @override
  Widget build(BuildContext context) {
    if (!viewModel.display) return const SizedBox.shrink();
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 150),
      child: SyncStatusCompactPanel(viewModel: viewModel),
    );
  }
}
