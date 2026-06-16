import 'package:flutter/material.dart';

import '../../domain/glance_snapshot.dart';
import '../styles/glance_theme.dart';
import 'floating_glance_permission_prompt.dart';
import 'floating_glance_preview.dart';

class FloatingGlanceCard extends StatelessWidget {
  final bool enabled;
  final bool permissionGranted;
  final GlanceSnapshot snapshot;
  final ValueChanged<bool> onEnabledChanged;
  final VoidCallback onRequestPermission;

  const FloatingGlanceCard({
    super.key,
    required this.enabled,
    required this.permissionGranted,
    required this.snapshot,
    required this.onEnabledChanged,
    required this.onRequestPermission,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 18),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: GlanceTheme.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: GlanceTheme.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.picture_in_picture_alt_outlined,
                color: GlanceTheme.green,
                size: 19,
              ),
              const SizedBox(width: 9),
              Expanded(
                child: Text(
                  'Floating Glance',
                  style: GlanceTheme.label.copyWith(
                    color: GlanceTheme.text,
                    fontSize: 13.5,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              Switch(
                value: enabled,
                activeColor: GlanceTheme.green,
                onChanged: onEnabledChanged,
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            'Allows SmartXDrip to show glucose above other apps. It stays silent and only mirrors Glance status.',
            style: GlanceTheme.label.copyWith(
              color: GlanceTheme.soft,
              fontSize: 11.5,
              height: 1.45,
            ),
          ),
          const SizedBox(height: 14),
          Center(child: FloatingGlancePreview(snapshot: snapshot)),
          const SizedBox(height: 12),
          FloatingGlancePermissionPrompt(
            granted: permissionGranted,
            onRequest: onRequestPermission,
          ),
        ],
      ),
    );
  }
}
