import 'package:flutter/material.dart';

import '../styles/glance_theme.dart';

class FloatingGlancePermissionPrompt extends StatelessWidget {
  final bool granted;
  final VoidCallback onRequest;

  const FloatingGlancePermissionPrompt({
    super.key,
    required this.granted,
    required this.onRequest,
  });

  @override
  Widget build(BuildContext context) {
    if (granted) {
      return Text(
        'Floating permission is ready.',
        style: GlanceTheme.label.copyWith(
          color: GlanceTheme.green,
          fontSize: 11.5,
          fontWeight: FontWeight.w700,
        ),
      );
    }
    return TextButton.icon(
      onPressed: onRequest,
      icon: const Icon(Icons.open_in_new_rounded, size: 15),
      label: const Text('Enable floating permission'),
      style: TextButton.styleFrom(
        foregroundColor: GlanceTheme.green,
        padding: EdgeInsets.zero,
        textStyle: GlanceTheme.label.copyWith(
          fontSize: 12,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}
