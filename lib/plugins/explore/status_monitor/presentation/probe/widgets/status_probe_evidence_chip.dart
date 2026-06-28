import 'package:flutter/material.dart';

class StatusProbeEvidenceChip extends StatelessWidget {
  final String label;

  const StatusProbeEvidenceChip({
    super.key,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Chip(label: Text(label));
  }
}
