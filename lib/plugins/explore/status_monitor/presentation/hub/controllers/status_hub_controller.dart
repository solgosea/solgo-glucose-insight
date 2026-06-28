import 'package:flutter/foundation.dart';

import '../../../application/hub/status_hub_controller_facade.dart';
import '../mappers/status_hub_view_model_mapper.dart';
import '../models/status_hub_view_model.dart';

class StatusHubController extends ChangeNotifier {
  final StatusHubControllerFacade facade;
  final StatusHubViewModelMapper mapper;

  StatusHubViewModel? _viewModel;
  Object? _error;
  bool _loading = false;
  bool _disposed = false;
  int _loadGeneration = 0;

  StatusHubController({
    required this.facade,
    this.mapper = const StatusHubViewModelMapper(),
  });

  StatusHubViewModel? get viewModel => _viewModel;
  Object? get error => _error;
  bool get loading => _loading;

  Future<void> load() async {
    if (_loading) return;
    final generation = ++_loadGeneration;
    _loading = true;
    _error = null;
    _viewModel ??= mapper.map(facade.buildInitialHub().report);
    notifyListeners();
    try {
      await for (final output in facade.watchHub()) {
        if (_disposed || generation != _loadGeneration) return;
        _viewModel = mapper.map(output.report);
        _error = null;
        notifyListeners();
      }
      _error = null;
    } catch (error) {
      _error = error;
    } finally {
      if (!_disposed && generation == _loadGeneration) {
        _loading = false;
      }
    }
    if (!_disposed && generation == _loadGeneration) notifyListeners();
  }

  @override
  void dispose() {
    _disposed = true;
    _loadGeneration += 1;
    super.dispose();
  }
}
