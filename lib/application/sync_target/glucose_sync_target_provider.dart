import '../../domain/entities/app_settings.dart';
import '../../domain/sync_target/glucose_sync_target.dart';

abstract class GlucoseSyncTargetProvider {
  Future<List<GlucoseSyncTarget>> targetsFor(AppSettings settings);
}
