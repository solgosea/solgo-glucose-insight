import 'package:flutter/foundation.dart';
import 'package:smart_xdrip/domain/entities/app_settings.dart';

import '../application/profile_host_services.dart';
import '../application/i18n/profile_l10n_resolver.dart';
import '../l10n/generated/profile_localizations.dart';
import '../mappers/profile_view_model_mapper.dart';
import '../models/profile_view_model.dart';
import '../runtime/profile_plugin_runtime.dart';
import '../runtime/profile_runtime_cache.dart';

class ProfileController extends ChangeNotifier {
  final ProfileHostServices hostServices;
  final ProfileRuntimeCache runtimeCache;
  final ProfilePluginRuntime runtime;
  final ProfileViewModelMapper mapper;

  ProfileViewModel? _viewModel;
  ProfileLocalizations _l10n = ProfileL10nResolver.fallback;
  bool _disposed = false;

  ProfileController({
    required this.hostServices,
    required this.runtimeCache,
    required this.runtime,
    this.mapper = const ProfileViewModelMapper(),
  }) {
    hostServices.changeSignal.addListener(_handleHostChanged);
  }

  ProfileViewModel? get viewModel => _viewModel;

  AppSettings get currentSettings => hostServices.settingsProvider();

  void updateLocale(ProfileLocalizations l10n) {
    if (_l10n.localeName == l10n.localeName) return;
    _l10n = l10n;
    if (_viewModel != null) {
      _remap();
    }
  }

  Future<void> load() async {
    _remap();
  }

  void _remap() {
    final facade = hostServices.facadeProvider();
    _viewModel = mapper.map(
      facade: facade,
      settings: hostServices.settingsProvider(),
      l10n: _l10n,
    );
    _notifyIfActive();
  }

  void _handleHostChanged() {
    runtimeCache.markStale('hostChanged');
    _remap();
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
