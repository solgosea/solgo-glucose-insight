import '../../domain/background_sync/background_sync_snapshot.dart';
import '../../domain/background_sync/background_sync_status.dart';

class BackgroundServiceNotification {
  final String title;
  final String content;

  const BackgroundServiceNotification({
    required this.title,
    required this.content,
  });
}

class BackgroundServiceNotificationBuilder {
  const BackgroundServiceNotificationBuilder();

  BackgroundServiceNotification fromSnapshot(BackgroundSyncSnapshot snapshot) {
    return BackgroundServiceNotification(
      title: 'Solgo Insight sync',
      content: switch (snapshot.status) {
        BackgroundSyncStatus.disabled => 'Background sync is paused.',
        BackgroundSyncStatus.checking => 'Checking data source...',
        BackgroundSyncStatus.syncing => 'Syncing glucose data...',
        BackgroundSyncStatus.synced => snapshot.message,
        BackgroundSyncStatus.failed => 'Sync failed: ${snapshot.message}',
      },
    );
  }

  BackgroundServiceNotification get initial {
    return const BackgroundServiceNotification(
      title: 'Solgo Insight sync',
      content: 'Preparing glucose data sync...',
    );
  }
}
