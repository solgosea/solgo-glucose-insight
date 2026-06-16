// ignore_for_file: prefer_const_constructors

import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../plugin_platform/services/plugin_service_registry.dart';
import '../../application/glance_persistent_notification_service.dart';
import '../../application/glance_snapshot_service.dart';
import '../../data/sqlite/sqlite_glance_settings_repository.dart';
import '../../domain/glance_display_mode.dart';
import '../controllers/glance_hub_controller.dart';
import '../styles/glance_theme.dart';
import '../widgets/glance_aod_mode_selector.dart';
import '../widgets/glance_external_surface_preview.dart';
import '../widgets/glance_lock_screen_mode_selector.dart';
import '../widgets/glance_privacy_card.dart';
import '../widgets/persistent_notification_preview.dart';

class PersistentNotificationPage extends StatefulWidget {
  const PersistentNotificationPage({super.key});

  @override
  State<PersistentNotificationPage> createState() =>
      _PersistentNotificationPageState();
}

class _PersistentNotificationPageState
    extends State<PersistentNotificationPage> {
  late final GlanceHubController controller;

  @override
  void initState() {
    super.initState();
    final services = context.read<PluginServiceRegistry>();
    controller = GlanceHubController(
      snapshotService: services.get<GlanceSnapshotService>(),
      settingsRepository: services.get<SqliteGlanceSettingsRepository>(),
      notificationService: services.get<GlancePersistentNotificationService>(),
    );
    unawaited(controller.load());
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isIos = defaultTargetPlatform == TargetPlatform.iOS;
    return Scaffold(
      backgroundColor: GlanceTheme.bg,
      appBar: AppBar(
        backgroundColor: GlanceTheme.bg,
        foregroundColor: GlanceTheme.text,
        elevation: 0,
        title: Text(
          isIos ? 'Lock Screen Glance' : 'Persistent notification',
          style: GlanceTheme.mono.copyWith(
            fontSize: 16,
            fontWeight: FontWeight.w900,
          ),
        ),
      ),
      body: AnimatedBuilder(
        animation: controller,
        builder: (context, _) {
          final snapshot = controller.snapshot;
          if (controller.loading || snapshot == null) {
            return const Center(
              child: CircularProgressIndicator(color: GlanceTheme.green),
            );
          }
          final privateMode = controller.settings.notificationDisplayMode ==
              GlanceDisplayMode.private;
          return ListView(
            padding: const EdgeInsets.fromLTRB(18, 8, 18, 28),
            children: [
              _Label(isIos ? 'Home widget preview' : 'Collapsed'),
              if (isIos) ...[
                GlanceExternalSurfacePreview(
                  snapshot: snapshot,
                  mode: controller.settings.notificationDisplayMode,
                ),
                const SizedBox(height: 18),
              ] else ...[
                PersistentNotificationPreview(snapshot: snapshot),
                const SizedBox(height: 18),
                _Label('Expanded'),
                PersistentNotificationPreview(
                  snapshot: snapshot,
                  expanded: true,
                ),
                const SizedBox(height: 18),
                _Label('Lock screen'),
                PersistentNotificationPreview(
                  snapshot: snapshot,
                  privateMode: privateMode,
                ),
                const SizedBox(height: 18),
              ],
              _Label('Lock screen mode'),
              _ModeCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GlanceLockScreenModeSelector(
                      value: controller.settings.lockScreenMode,
                      onChanged: controller.setLockScreenMode,
                    ),
                    const SizedBox(height: 12),
                    GlanceExternalSurfacePreview(
                      snapshot: snapshot,
                      mode: controller.settings.notificationDisplayMode,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),
              _Label('AOD-friendly'),
              _ModeCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GlanceAodModeSelector(
                      enabled: controller.settings.aodFriendlyEnabled,
                      onChanged: controller.setAodFriendlyEnabled,
                    ),
                    const SizedBox(height: 10),
                    GlanceExternalSurfacePreview(
                      snapshot: snapshot,
                      mode: controller.settings.notificationDisplayMode,
                      aodFriendly: true,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),
              GlancePrivacyCard(
                privateMode: privateMode,
                onChanged: controller.setPrivateMode,
              ),
              const SizedBox(height: 12),
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                activeColor: GlanceTheme.green,
                title: Text(
                  'Show persistent notification',
                  style: GlanceTheme.mono.copyWith(
                    color: GlanceTheme.text,
                    fontSize: 12.5,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                subtitle: Text(
                  'Silent status only. Alerts remain separate.',
                  style: GlanceTheme.mono.copyWith(
                    color: GlanceTheme.dim,
                    fontSize: 10.5,
                  ),
                ),
                value: controller.settings.enabled,
                onChanged: controller.setNotificationEnabled,
              ),
            ],
          );
        },
      ),
    );
  }
}

class _ModeCard extends StatelessWidget {
  final Widget child;

  const _ModeCard({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: GlanceTheme.card,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: GlanceTheme.border),
      ),
      child: child,
    );
  }
}

class _Label extends StatelessWidget {
  final String text;

  const _Label(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 9),
      child: Text(
        text.toUpperCase(),
        style: GlanceTheme.mono.copyWith(
          color: GlanceTheme.dim,
          fontSize: 10,
          fontWeight: FontWeight.w900,
          letterSpacing: 0,
        ),
      ),
    );
  }
}
