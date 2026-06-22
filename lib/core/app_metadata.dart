import 'package:package_info_plus/package_info_plus.dart';

class AppMetadata {
  static const displayName = 'Solgo Insight';
  static const fallbackVersionName = '0.1.0';
  static const fallbackBuildNumber = '1';

  final String versionName;
  final String buildNumber;

  const AppMetadata({
    required this.versionName,
    required this.buildNumber,
  });

  static const fallback = AppMetadata(
    versionName: fallbackVersionName,
    buildNumber: fallbackBuildNumber,
  );

  static Future<AppMetadata> fromPlatform() async {
    try {
      final info = await PackageInfo.fromPlatform();
      return AppMetadata(
        versionName: info.version.isEmpty ? fallbackVersionName : info.version,
        buildNumber:
            info.buildNumber.isEmpty ? fallbackBuildNumber : info.buildNumber,
      );
    } catch (_) {
      return fallback;
    }
  }

  String get aboutTitle =>
      '$displayName v$versionName - Local-first - No account required';
}
