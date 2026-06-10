import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

typedef PluginRouteStateBuilder =
    Widget Function(BuildContext context, GoRouterState state);

class PluginRoute {
  final String path;
  final WidgetBuilder? builder;
  final PluginRouteStateBuilder? stateBuilder;

  const PluginRoute({required this.path, required this.builder})
    : stateBuilder = null;

  const PluginRoute.state({
    required this.path,
    required PluginRouteStateBuilder builder,
  }) : builder = null,
       stateBuilder = builder;

  Widget build(BuildContext context, GoRouterState state) {
    final stateBuilder = this.stateBuilder;
    if (stateBuilder != null) {
      return stateBuilder(context, state);
    }
    return builder!(context);
  }
}
