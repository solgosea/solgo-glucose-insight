import 'package:flutter/material.dart';

import '../../models/status_probe_checklist_view_model.dart';
import '../shared/status_probe_section_title.dart';
import 'status_probe_checklist_footer_note.dart';
import 'status_probe_checklist_header.dart';
import 'status_probe_suite_section.dart';

class StatusProbeChecklistBody extends StatefulWidget {
  final StatusProbeChecklistViewModel viewModel;
  final VoidCallback onRun;
  final ValueChanged<String> onOpenGuide;

  const StatusProbeChecklistBody({
    super.key,
    required this.viewModel,
    required this.onRun,
    required this.onOpenGuide,
  });

  @override
  State<StatusProbeChecklistBody> createState() =>
      _StatusProbeChecklistBodyState();
}

class _StatusProbeChecklistBodyState extends State<StatusProbeChecklistBody> {
  final Set<String> _expandedSuiteIds = <String>{};

  void _toggleSuite(String suiteId) {
    setState(() {
      if (!_expandedSuiteIds.add(suiteId)) {
        _expandedSuiteIds.remove(suiteId);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        StatusProbeChecklistHeader(
          viewModel: widget.viewModel,
          onRun: widget.onRun,
        ),
        if (widget.viewModel.error != null)
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
            child: _ErrorPanel(message: widget.viewModel.error!),
          ),
        const StatusProbeSectionTitle(
          left: 'Connection checks',
          right: 'checklist',
        ),
        ...widget.viewModel.suites.map(
          (suite) => StatusProbeSuiteSection(
            suite: suite,
            expanded: _expandedSuiteIds.contains(suite.id),
            onToggle: () => _toggleSuite(suite.id),
            onOpenGuide: widget.onOpenGuide,
          ),
        ),
        const StatusProbeChecklistFooterNote(),
      ],
    );
  }
}

class _ErrorPanel extends StatelessWidget {
  final String message;

  const _ErrorPanel({required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.red.withOpacity(.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.red.withOpacity(.28)),
      ),
      child: Row(
        children: [
          const Icon(Icons.error_outline_rounded, color: Colors.redAccent),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(color: Colors.redAccent, fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }
}
