import 'package:flutter/foundation.dart';

import '../../../app/di/app_container.dart';

abstract class AppSettingsAwareController extends ChangeNotifier {
  final AppContainer container;
  bool _disposed = false;

  AppSettingsAwareController({required this.container}) {
    container.addListener(_handleContainerChanged);
  }

  @protected
  bool get isDisposed => _disposed;

  @protected
  void onAppSettingsChanged();

  @protected
  void notifyIfActive() {
    if (!_disposed) notifyListeners();
  }

  void _handleContainerChanged() {
    if (_disposed) return;
    onAppSettingsChanged();
  }

  @override
  void dispose() {
    _disposed = true;
    container.removeListener(_handleContainerChanged);
    super.dispose();
  }
}
