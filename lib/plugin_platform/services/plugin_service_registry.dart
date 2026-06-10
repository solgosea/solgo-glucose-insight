class PluginServiceRegistry {
  final Map<Type, Object> _services = {};

  void register<T extends Object>(T service, {bool replace = false}) {
    final type = T;
    if (!replace && _services.containsKey(type)) {
      throw StateError('Plugin service already registered: $type');
    }
    _services[type] = service;
  }

  T get<T extends Object>() {
    final service = _services[T];
    if (service == null) {
      throw StateError('Plugin service not registered: $T');
    }
    return service as T;
  }

  T? maybe<T extends Object>() {
    final service = _services[T];
    if (service == null) return null;
    return service as T;
  }
}
