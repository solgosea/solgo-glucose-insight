import 'package:flutter/material.dart';

class StatusProbeSourceRefList extends StatelessWidget {
  final List<String> refs;

  const StatusProbeSourceRefList({
    super.key,
    required this.refs,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: refs.map((ref) => Text(ref)).toList(),
    );
  }
}
