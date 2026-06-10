import '../../domain/entities/app_settings.dart';
import '../../domain/sync_target/glucose_sync_target.dart';
import 'glucose_sync_target_provider.dart';

class GlucoseSyncTargetRegistry {
  final List<GlucoseSyncTargetProvider> _providers;

  GlucoseSyncTargetRegistry({
    Iterable<GlucoseSyncTargetProvider> providers = const [],
  }) : _providers = List.of(providers);

  void register(GlucoseSyncTargetProvider provider) {
    if (_providers.contains(provider)) return;
    _providers.add(provider);
  }

  Future<List<GlucoseSyncTarget>> targetsFor(AppSettings settings) async {
    final targets = <GlucoseSyncTarget>[];
    for (final provider in List<GlucoseSyncTargetProvider>.of(_providers)) {
      targets.addAll(await provider.targetsFor(settings));
    }
    final byId = <String, GlucoseSyncTarget>{};
    for (final target in targets) {
      if (!target.enabled) continue;
      byId[target.targetId] = target;
    }
    return byId.values.toList(growable: false);
  }
}
