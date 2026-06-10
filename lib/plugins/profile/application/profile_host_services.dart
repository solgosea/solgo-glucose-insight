import 'package:flutter/foundation.dart';

import '../../../application/analysis/analysis_facade.dart';
import '../../../domain/data_source/data_source_connection_snapshot.dart';
import '../../../domain/entities/app_settings.dart';
import '../../../domain/sync_status/sync_status_snapshot.dart';

class ProfileHostServices {
  final Listenable changeSignal;
  final AnalysisFacade Function() facadeProvider;
  final AppSettings Function() settingsProvider;
  final Future<SyncStatusSnapshot> Function() syncStatusSnapshot;
  final bool Function() xdripSupported;
  final Future<List<DataSourceConnectionSnapshot>> Function({
    required bool xdripSupported,
  })
  dataSourceSnapshots;

  const ProfileHostServices({
    required this.changeSignal,
    required this.facadeProvider,
    required this.settingsProvider,
    required this.syncStatusSnapshot,
    required this.xdripSupported,
    required this.dataSourceSnapshots,
  });
}
