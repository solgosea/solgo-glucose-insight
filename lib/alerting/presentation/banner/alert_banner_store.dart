import 'package:flutter/foundation.dart';

import 'alert_banner_item.dart';
import 'alert_banner_rotation_policy.dart';

class AlertBannerStore extends ChangeNotifier {
  final AlertBannerRotationPolicy rotationPolicy;
  List<AlertBannerItem> _items = const [];

  AlertBannerStore({this.rotationPolicy = const AlertBannerRotationPolicy()});

  List<AlertBannerItem> get items => _items;

  AlertBannerItem? get primary => rotationPolicy.selectPrimary(_items);

  void replaceAll(List<AlertBannerItem> items) {
    _items = List.unmodifiable(items);
    notifyListeners();
  }

  void clear() {
    if (_items.isEmpty) return;
    _items = const [];
    notifyListeners();
  }
}
