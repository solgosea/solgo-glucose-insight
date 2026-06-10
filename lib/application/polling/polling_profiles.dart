import '../../domain/data_source/data_source_kind.dart';
import '../../domain/polling/polling_source_profile.dart';

class PollingProfiles {
  static const xdripLocal = PollingSourceProfile(
    sourceKind: DataSourceKind.xdripLocal,
    foregroundNormal: Duration(seconds: 60),
    backgroundNormal: Duration(seconds: 120),
    dangerous: Duration(seconds: 30),
    stale: Duration(seconds: 180),
    failureMax: Duration(seconds: 300),
  );

  static const nightscout = PollingSourceProfile(
    sourceKind: DataSourceKind.nightscout,
    foregroundNormal: Duration(seconds: 180),
    backgroundNormal: Duration(seconds: 300),
    dangerous: Duration(seconds: 60),
    stale: Duration(seconds: 300),
    failureMax: Duration(seconds: 600),
  );

  static PollingSourceProfile forKind(DataSourceKind kind) {
    return switch (kind) {
      DataSourceKind.xdripLocal => xdripLocal,
      DataSourceKind.nightscout => nightscout,
    };
  }
}
