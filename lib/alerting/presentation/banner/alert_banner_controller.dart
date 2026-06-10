import 'package:flutter/foundation.dart';

import 'alert_banner_action.dart';
import 'alert_banner_item.dart';
import 'alert_banner_store.dart';

typedef AlertBannerActionCallback =
    Future<void> Function(AlertBannerItem item, AlertBannerAction action);

class AlertBannerController extends ChangeNotifier {
  final AlertBannerStore store;
  final AlertBannerActionCallback? onAction;

  AlertBannerController({required this.store, this.onAction}) {
    store.addListener(notifyListeners);
  }

  AlertBannerItem? get primary => store.primary;

  Future<void> dispatch(AlertBannerAction action) async {
    final item = primary;
    if (item == null || !action.enabled) return;
    await onAction?.call(item, action);
  }

  @override
  void dispose() {
    store.removeListener(notifyListeners);
    super.dispose();
  }
}
