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
    final providerTargets = await Future.wait(
      List<GlucoseSyncTargetProvider>.of(_providers).map(
        (provider) => provider.targetsFor(settings),
      ),
    );
    final targets = providerTargets.expand((items) => items);
    final byId = <String, GlucoseSyncTarget>{};
    for (final target in targets) {
      if (!target.enabled) continue;
      byId[target.targetId] = target;
    }
    return byId.values.toList(growable: false);
  }
}
