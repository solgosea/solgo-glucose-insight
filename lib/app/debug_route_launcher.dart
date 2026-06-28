import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

class DebugRouteLauncher {
  static const _channel = MethodChannel('com.metaguru.smartxdrip/debug_route');
  static const _actionOpenRoute = 'com.metaguru.smartxdrip.DEBUG_OPEN_ROUTE';

  final GoRouter router;
  bool _attached = false;

  DebugRouteLauncher({
    required this.router,
  });

  void attach() {
    if (_attached || kReleaseMode) return;
    _attached = true;
    debugPrint('[SmartXDrip][DebugRoute] attached');
    _channel.setMethodCallHandler(_handleCall);
    unawaited(_consumePendingRoute());
  }

  void detach() {
    if (!_attached) return;
    _attached = false;
    _channel.setMethodCallHandler(null);
  }

  Future<dynamic> _handleCall(MethodCall call) async {
    debugPrint('[SmartXDrip][DebugRoute] method ${call.method}');
    if (call.method != 'openRoute') return null;
    final args = call.arguments;
    final route = args is Map ? args['route']?.toString() : null;
    _open(route);
    return true;
  }

  Future<void> _consumePendingRoute() async {
    try {
      final route = await _channel.invokeMethod<String>('consumePendingRoute');
      _open(route);
    } catch (_) {
      // Debug-only automation path. Normal app navigation must not depend on it.
    }
  }

  void _open(String? route) {
    if (route == null || route.isEmpty) return;
    if (!route.startsWith('/')) return;
    if (route.contains('://')) return;
    unawaited(_openWhenReady(route));
  }

  Future<void> _openWhenReady(String route) async {
    await Future<void>.delayed(Duration.zero);
    debugPrint('[SmartXDrip][DebugRoute] open $route');
    router.go(route);
    await Future<void>.delayed(const Duration(milliseconds: 450));
    if (router.routeInformationProvider.value.uri.toString() != route) {
      debugPrint(
        '[SmartXDrip][DebugRoute] retry $route from '
        '${router.routeInformationProvider.value.uri}',
      );
      router.go(route);
    }
  }

  static String get openRouteAction => _actionOpenRoute;
}
