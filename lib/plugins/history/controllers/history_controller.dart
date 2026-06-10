import 'package:flutter/foundation.dart';

import '../application/history_host_services.dart';
import '../models/history_view_model.dart';
import '../runtime/history_plugin_runtime.dart';
import '../runtime/history_runtime_cache.dart';

class HistoryController extends ChangeNotifier {
  final HistoryHostServices hostServices;
  final HistoryRuntimeCache runtimeCache;
  final HistoryPluginRuntime runtime;

  DateTime _selectedDay = DateTime.now();
  HistoryViewModel? viewModel;

  HistoryController({
    required this.hostServices,
    required this.runtimeCache,
    required this.runtime,
  }) {
    hostServices.changeSignal.addListener(_handleHostChanged);
  }

  DateTime get selectedDay => _selectedDay;

  Future<void> init() => _load();

  void prevDay() {
    _selectedDay = _selectedDay.subtract(const Duration(days: 1));
    _load();
  }

  void nextDay() {
    if (isToday) return;
    _selectedDay = _selectedDay.add(const Duration(days: 1));
    _load();
  }

  bool get isToday {
    final today = DateTime.now();
    return _selectedDay.year == today.year &&
        _selectedDay.month == today.month &&
        _selectedDay.day == today.day;
  }

  Future<void> _load() async {
    final facade = hostServices.facadeProvider();
    final cached = runtimeCache.freshViewModel(
      subjectId: facade.activeSubject.id,
      day: _selectedDay,
    );
    if (cached != null) {
      viewModel = cached;
      notifyListeners();
      return;
    }

    final snapshot = await runtime.preheatDay(day: _selectedDay);
    if (snapshot == null) return;
    viewModel = snapshot.viewModel;
    notifyListeners();
  }

  void _handleHostChanged() {
    runtimeCache.markStale('hostChanged');
    _load();
  }

  @override
  void dispose() {
    hostServices.changeSignal.removeListener(_handleHostChanged);
    super.dispose();
  }
}
