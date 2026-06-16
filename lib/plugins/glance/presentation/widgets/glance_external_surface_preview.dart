import 'package:flutter/material.dart';

import '../../application/notification/glance_notification_content_builder.dart';
import '../../domain/glance_display_mode.dart';
import '../../domain/glance_snapshot.dart';
import '../../domain/notification_privacy_mode.dart';
import '../styles/glance_theme.dart';

class GlanceExternalSurfacePreview extends StatelessWidget {
  final GlanceSnapshot snapshot;
  final GlanceDisplayMode mode;
  final bool aodFriendly;

  const GlanceExternalSurfacePreview({
    super.key,
    required this.snapshot,
    required this.mode,
    this.aodFriendly = false,
  });

  @override
  Widget build(BuildContext context) {
    final content = const GlanceNotificationContentBuilder().build(
      snapshot: snapshot,
      privacyMode: mode == GlanceDisplayMode.private
          ? GlanceNotificationPrivacyMode.private
          : GlanceNotificationPrivacyMode.full,
      displayMode: mode,
      aodFriendly: aodFriendly,
    );
    return Container(
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
        color: GlanceTheme.card2,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: GlanceTheme.border),
      ),
      child: Row(
        children: [
          Icon(
            aodFriendly ? Icons.bedtime_outlined : Icons.lock_outline,
            color: GlanceTheme.green,
            size: 18,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  content.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GlanceTheme.label.copyWith(
                    color: GlanceTheme.text,
                    fontSize: 12.5,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  content.body,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: GlanceTheme.label.copyWith(
                    color: GlanceTheme.soft,
                    fontSize: 11.5,
                    height: 1.35,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
