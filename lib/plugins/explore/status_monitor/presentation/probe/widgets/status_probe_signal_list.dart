import 'package:flutter/material.dart';

class StatusProbeSignalList extends StatelessWidget {
  final List<String> signals;

  const StatusProbeSignalList({
    super.key,
    required this.signals,
  });

  @override
  Widget build(BuildContext context) {
    if (signals.isEmpty) return const SizedBox.shrink();
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: signals.map((signal) => Chip(label: Text(signal))).toList(),
    );
  }
}
