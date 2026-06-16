import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../alerting/presentation/overlays/alert_overlay_host.dart';
import '../foundation/theme/app_theme.dart';
import '../plugin_platform/registry/plugin_registry.dart';
import '../plugin_platform/composition/plugin_composition_registry.dart';
import '../plugin_platform/runtime/manager/plugin_runtime_manager.dart';
import '../plugin_platform/services/plugin_service_registry.dart';
import 'di/app_container.dart';
import 'router.dart';

class SmartXDripApp extends StatefulWidget {
  final AppContainer container;

  const SmartXDripApp({
    super.key,
    required this.container,
  });

  @override
  State<SmartXDripApp> createState() => _SmartXDripAppState();
}

class _SmartXDripAppState extends State<SmartXDripApp>
    with WidgetsBindingObserver {
  late GoRouter _router;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _router = createRouter(widget.container.pluginRegistry);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didUpdateWidget(SmartXDripApp oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.container.pluginRegistry != widget.container.pluginRegistry) {
      _router = createRouter(widget.container.pluginRegistry);
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      unawaited(widget.container.reconcileOnForeground());
    }
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarBrightness: Brightness.dark,
      statusBarIconBrightness: Brightness.light,
    ));
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AppContainer>.value(value: widget.container),
        Provider<PluginServiceRegistry>.value(
          value: widget.container.pluginServices,
        ),
        Provider<PluginRegistry>.value(
          value: widget.container.pluginRegistry,
        ),
        Provider<PluginCompositionRegistry>.value(
          value: widget.container.pluginCompositionRegistry,
        ),
        Provider<PluginRuntimeManager>.value(
          value: widget.container.pluginRuntimeManager,
        ),
      ],
      child: MaterialApp.router(
        title: 'Solgo Insight',
        theme: AppTheme.dark,
        routerConfig: _router,
        debugShowCheckedModeBanner: false,
        builder: (context, child) {
          return AlertOverlayHost(child: child ?? const SizedBox.shrink());
        },
      ),
    );
  }
}
