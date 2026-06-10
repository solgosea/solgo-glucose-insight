import 'background_runtime_start_strategy.dart';

class BackgroundRuntimeStrategyRegistry {
  final List<BackgroundRuntimeStartStrategy> _strategies;

  BackgroundRuntimeStrategyRegistry({
    Iterable<BackgroundRuntimeStartStrategy> strategies = const [],
  }) : _strategies = List.of(strategies);

  void register(BackgroundRuntimeStartStrategy strategy) {
    if (_strategies.any((item) => item.reason == strategy.reason)) {
      return;
    }
    _strategies.add(strategy);
  }

  List<BackgroundRuntimeStartStrategy> get strategies =>
      List.unmodifiable(_strategies);
}
