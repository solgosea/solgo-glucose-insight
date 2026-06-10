import 'package:flutter/foundation.dart';
import 'package:smart_xdrip/application/data_source/data_source_connection_result.dart';
import 'package:smart_xdrip/domain/data_source/data_source_kind.dart';
import 'package:smart_xdrip/domain/entities/app_settings.dart';

import '../application/profile_data_source_actions.dart';
import '../application/profile_host_services.dart';
import '../application/profile_settings_actions.dart';
import '../models/profile_view_model.dart';
import '../runtime/profile_plugin_runtime.dart';
import '../runtime/profile_runtime_cache.dart';
import '../target_range/target_range_value_policy.dart';

class ProfileController extends ChangeNotifier {
  final ProfileHostServices hostServices;
  final ProfileDataSourceActions dataSourceActions;
  final ProfileSettingsActions settingsActions;
  final ProfileRuntimeCache runtimeCache;
  final ProfilePluginRuntime runtime;

  ProfileViewModel? _viewModel;
  bool _disposed = false;

  ProfileController({
    required this.hostServices,
    required this.dataSourceActions,
    required this.settingsActions,
    required this.runtimeCache,
    required this.runtime,
  }) {
    hostServices.changeSignal.addListener(_handleHostChanged);
  }

  ProfileViewModel? get viewModel => _viewModel;

  AppSettings get currentSettings => hostServices.settingsProvider();

  Future<void> load() async {
    final facade = hostServices.facadeProvider();
    final cached = runtimeCache.freshSnapshot(
      subjectId: facade.activeSubject.id,
    );
    if (cached != null) {
      _viewModel = cached.viewModel;
      _notifyIfActive();
      return;
    }

    final snapshot = await runtime.preheat();
    if (snapshot == null) return;
    _viewModel = snapshot.viewModel;
    _notifyIfActive();
  }

  void selectSource(DataSourceKind kind) {
    _notifyIfActive();
  }

  Future<String> connectXdripLocal() async {
    final result = await dataSourceActions.connectXdripLocal();
    await _reloadAfterMutation('connectXdripLocal');
    return result.message;
  }

  Future<String> detectXdripLocal() async {
    final result = await dataSourceActions.detectXdripLocal();
    await _reloadAfterMutation('detectXdripLocal');
    return result.message;
  }

  Future<DataSourceConnectionResult> connectNightscout({
    required String baseUrl,
    String? token,
  }) async {
    final result = await dataSourceActions.connectNightscout(
      baseUrl: baseUrl,
      token: token,
    );
    await _reloadAfterMutation('connectNightscout');
    return result;
  }

  Future<String> useConfiguredNightscout() async {
    final result = await dataSourceActions.useConfiguredNightscout();
    await _reloadAfterMutation('useConfiguredNightscout');
    return result.message;
  }

  Future<String> disconnectDataSource(DataSourceKind kind) async {
    final result = await dataSourceActions.disconnectDataSource(kind);
    await _reloadAfterMutation('disconnectDataSource');
    return result.message;
  }

  Future<String> enableDataSourceSync(DataSourceKind kind) async {
    final result = await dataSourceActions.enableDataSourceSync(kind);
    await _reloadAfterMutation('enableDataSourceSync');
    return result.message;
  }

  Future<String> disableDataSourceSync(DataSourceKind kind) async {
    final result = await dataSourceActions.disableDataSourceSync(kind);
    await _reloadAfterMutation('disableDataSourceSync');
    return result.message;
  }

  Future<void> updateTargetRange(TargetRangeDraft draft) async {
    await settingsActions.updateTargetRange(draft);
    await _reloadAfterMutation('updateTargetRange');
  }

  Future<void> _reloadAfterMutation(String reason) async {
    runtimeCache.markStale(reason);
    await load();
  }

  void _handleHostChanged() {
    runtimeCache.markStale('hostChanged');
    load();
  }

  void _notifyIfActive() {
    if (_disposed) return;
    notifyListeners();
  }

  @override
  void dispose() {
    _disposed = true;
    hostServices.changeSignal.removeListener(_handleHostChanged);
    super.dispose();
  }
}
