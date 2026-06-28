import 'package:flutter/material.dart';

class StatusProbeSetupStepCard extends StatelessWidget {
  final String title;
  final String body;

  const StatusProbeSetupStepCard({
    super.key,
    required this.title,
    required this.body,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: Theme.of(context).textTheme.titleSmall),
            const SizedBox(height: 8),
            Text(body),
          ],
        ),
      ),
    );
  }
}
