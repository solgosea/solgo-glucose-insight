import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../domain/floating/status_floating_payload.dart';
import '../styles/status_monitor_theme.dart';
import 'status_monitor_floating_permission_prompt.dart';
import 'status_monitor_floating_preview.dart';

class StatusMonitorFloatingCard extends StatelessWidget {
  final bool enabled;
  final bool permissionGranted;
  final StatusFloatingPayload payload;
  final ValueChanged<bool> onEnabledChanged;
  final VoidCallback onRequestPermission;

  const StatusMonitorFloatingCard({
    super.key,
    required this.enabled,
    required this.permissionGranted,
    required this.payload,
    required this.onEnabledChanged,
    required this.onRequestPermission,
  });

  @override
  Widget build(BuildContext context) {
    final isAndroid = defaultTargetPlatform == TargetPlatform.android;
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: StatusMonitorTheme.cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.picture_in_picture_alt_outlined,
                color: StatusMonitorTheme.green,
                size: 19,
              ),
              const SizedBox(width: 9),
              Expanded(
                child: Text(
                  'Floating Status Bar',
                  style: StatusMonitorTheme.inter.copyWith(
                    color: StatusMonitorTheme.text,
                    fontSize: 13.5,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              Switch(
                value: isAndroid && enabled,
                activeColor: StatusMonitorTheme.green,
                onChanged: isAndroid ? onEnabledChanged : null,
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            isAndroid
                ? 'Shows Sensor, xDrip+, and Nightscout health above other apps. Silent status only.'
                : 'Floating Status Bar is Android only. iOS uses Home Screen and Lock Screen widgets.',
            style: StatusMonitorTheme.inter.copyWith(
              color: StatusMonitorTheme.soft,
              fontSize: 11.5,
              height: 1.45,
            ),
          ),
          const SizedBox(height: 14),
          Center(child: StatusMonitorFloatingPreview(payload: payload)),
          if (isAndroid) ...[
            const SizedBox(height: 12),
            StatusMonitorFloatingPermissionPrompt(
              granted: permissionGranted,
              onRequest: onRequestPermission,
            ),
          ],
        ],
      ),
    );
  }
}
