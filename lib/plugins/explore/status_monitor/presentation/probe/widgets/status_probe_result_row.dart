import 'package:flutter/material.dart';

import '../models/status_probe_result_view_model.dart';

class StatusProbeResultRow extends StatelessWidget {
  final StatusProbeResultViewModel result;

  const StatusProbeResultRow({
    super.key,
    required this.result,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  result.label,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Text('${result.state} · ${result.confidence}'),
            ],
          ),
          const SizedBox(height: 4),
          Text(result.summary, style: theme.textTheme.bodySmall),
        ],
      ),
    );
  }
}
