import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:smart_xdrip/foundation/theme/app_colors.dart';
import 'package:smart_xdrip/plugin_platform/runtime/manager/plugin_runtime_manager.dart';
import 'package:smart_xdrip/plugin_platform/services/plugin_service_registry.dart';

import '../application/i18n/profile_l10n.dart';
import '../application/profile_host_services.dart';
import '../controllers/profile_controller.dart';
import '../runtime/profile_plugin_runtime.dart';
import '../runtime/profile_runtime_cache.dart';
import '../widgets/profile_body.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late final ProfileController _controller;
  bool _isUninitialized = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isUninitialized) {
      _controller.updateLocale(context.profileL10n);
      return;
    }
    if (mounted && _isUninitialized) {
      _isUninitialized = false;
      final services = context.read<PluginServiceRegistry>();
      final runtimeManager = context.read<PluginRuntimeManager>();
      unawaited(runtimeManager.resume(ProfilePluginRuntime.id));
      _controller = ProfileController(
        hostServices: services.get<ProfileHostServices>(),
        runtimeCache: services.get<ProfileRuntimeCache>(),
        runtime: services.get<ProfilePluginRuntime>(),
      );
      _controller.updateLocale(context.profileL10n);
      unawaited(_controller.load());
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        final viewModel = _controller.viewModel;
        if (viewModel == null) {
          return const Scaffold(
            backgroundColor: AppColors.bg,
            body: Center(
              child: CircularProgressIndicator(color: AppColors.green),
            ),
          );
        }

        return ProfileBody(
          viewModel: viewModel,
          onSettingsTap: () => context.push('/settings'),
        );
      },
    );
  }
}
