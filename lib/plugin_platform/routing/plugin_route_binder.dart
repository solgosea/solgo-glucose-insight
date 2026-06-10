import 'package:go_router/go_router.dart';

import '../contracts/plugin_route.dart';
import '../contracts/smart_feature_plugin.dart';

class PluginRouteBinder {
  const PluginRouteBinder();

  GoRoute bind(PluginRoute route) {
    return GoRoute(path: route.path, builder: route.build);
  }

  List<GoRoute> bindAll(Iterable<SmartFeaturePlugin> plugins) {
    return plugins.expand((plugin) => plugin.routes).map(bind).toList();
  }
}
