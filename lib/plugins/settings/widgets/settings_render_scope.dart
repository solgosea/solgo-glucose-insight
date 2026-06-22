import 'package:flutter/widgets.dart';

import '../models/settings_view_model.dart';

class SettingsRenderScope extends InheritedWidget {
  final SettingsViewModel viewModel;
  final VoidCallback onPickUnit;
  final VoidCallback onPickLanguage;
  final VoidCallback onPickInitialSyncWindow;
  final VoidCallback onExportCsv;
  final VoidCallback onClearAllData;

  const SettingsRenderScope({
    super.key,
    required this.viewModel,
    required this.onPickUnit,
    required this.onPickLanguage,
    required this.onPickInitialSyncWindow,
    required this.onExportCsv,
    required this.onClearAllData,
    required super.child,
  });

  static SettingsRenderScope of(BuildContext context) {
    final scope =
        context.dependOnInheritedWidgetOfExactType<SettingsRenderScope>();
    assert(scope != null, 'SettingsRenderScope was not found.');
    return scope!;
  }

  @override
  bool updateShouldNotify(SettingsRenderScope oldWidget) {
    return viewModel != oldWidget.viewModel;
  }
}
