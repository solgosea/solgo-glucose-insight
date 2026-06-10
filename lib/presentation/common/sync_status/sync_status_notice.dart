import 'package:flutter/material.dart';
import 'package:smart_xdrip/foundation/theme/app_colors.dart';

class SyncStatusNotice {
  const SyncStatusNotice._();

  static void showPending(
    BuildContext context, {
    required String title,
    required String message,
  }) {
    _show(
      context,
      title: title,
      message: message,
      icon: Icons.sync_rounded,
      color: AppColors.amber,
    );
  }

  static void showSuccess(
    BuildContext context, {
    required String title,
    required String message,
  }) {
    _show(
      context,
      title: title,
      message: message,
      icon: Icons.cloud_done_rounded,
      color: AppColors.green,
    );
  }

  static void showFailure(
    BuildContext context, {
    required String title,
    required String message,
  }) {
    _show(
      context,
      title: title,
      message: message,
      icon: Icons.cloud_off_rounded,
      color: AppColors.rose,
    );
  }

  static void _show(
    BuildContext context, {
    required String title,
    required String message,
    required IconData icon,
    required Color color,
  }) {
    final messenger = ScaffoldMessenger.of(context);
    messenger.hideCurrentSnackBar();
    messenger.showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.transparent,
        elevation: 0,
        margin: const EdgeInsets.fromLTRB(16, 0, 16, 18),
        duration: const Duration(seconds: 4),
        content: _SyncStatusNoticeContent(
          title: title,
          message: message,
          icon: icon,
          color: color,
        ),
      ),
    );
  }
}

class _SyncStatusNoticeContent extends StatelessWidget {
  final String title;
  final String message;
  final IconData icon;
  final Color color;

  const _SyncStatusNoticeContent({
    required this.title,
    required this.message,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.bgCard,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: color.withValues(alpha: 0.36)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.28),
            blurRadius: 24,
            offset: const Offset(0, 12),
          ),
          BoxShadow(
            color: color.withValues(alpha: 0.08),
            blurRadius: 28,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(14, 13, 14, 13),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: color.withValues(alpha: 0.13),
                border: Border.all(color: color.withValues(alpha: 0.32)),
              ),
              child: Icon(icon, color: color, size: 18),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: AppColors.text,
                      fontSize: 13,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    message,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: AppColors.textSoft,
                      fontSize: 11,
                      height: 1.35,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
