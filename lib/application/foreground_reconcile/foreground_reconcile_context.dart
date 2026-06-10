import '../../domain/entities/app_settings.dart';
import 'foreground_reconcile_platform.dart';

class ForegroundReconcileContext {
  final AppSettings settings;
  final ForegroundReconcilePlatform platform;
  final DateTime now;
  final DateTime? lastBackgroundSyncAt;
  final DateTime? lastForegroundReconcileAt;
  final bool hasSyncTargets;

  const ForegroundReconcileContext({
    required this.settings,
    required this.platform,
    required this.now,
    this.lastBackgroundSyncAt,
    this.lastForegroundReconcileAt,
    this.hasSyncTargets = false,
  });
}
