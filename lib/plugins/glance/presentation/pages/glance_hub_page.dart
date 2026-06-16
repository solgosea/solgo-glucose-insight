// ignore_for_file: prefer_const_constructors

import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../../plugin_platform/services/plugin_service_registry.dart';
import '../../../../presentation/common/navigation/safe_navigation.dart';
import '../../application/floating/floating_glance_service.dart';
import '../../application/glance_persistent_notification_service.dart';
import '../../application/glance_snapshot_service.dart';
import '../../data/sqlite/sqlite_floating_glance_settings_repository.dart';
import '../../data/sqlite/sqlite_glance_settings_repository.dart';
import '../../domain/glance_snapshot.dart';
import '../../domain/widget_template.dart';
import '../controllers/glance_hub_controller.dart';
import '../styles/glance_theme.dart';
import '../widgets/floating_glance_card.dart';
import '../widgets/glance_aod_mode_selector.dart';
import '../widgets/glance_external_surface_preview.dart';
import '../widgets/glance_lock_screen_mode_selector.dart';
import '../widgets/glance_template_preview_card.dart';

class GlanceHubPage extends StatefulWidget {
  const GlanceHubPage({super.key});

  @override
  State<GlanceHubPage> createState() => _GlanceHubPageState();
}

class _GlanceHubPageState extends State<GlanceHubPage> {
  late final GlanceHubController controller;

  @override
  void initState() {
    super.initState();
    final services = context.read<PluginServiceRegistry>();
    controller = GlanceHubController(
      snapshotService: services.get<GlanceSnapshotService>(),
      settingsRepository: services.get<SqliteGlanceSettingsRepository>(),
      notificationService: services.get<GlancePersistentNotificationService>(),
      floatingSettingsRepository:
          services.get<SqliteFloatingGlanceSettingsRepository>(),
      floatingService: services.get<FloatingGlanceService>(),
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
    return Scaffold(
      backgroundColor: GlanceTheme.bg,
      body: AnimatedBuilder(
        animation: controller,
        builder: (context, _) {
          final snapshot = controller.snapshot;
          if (controller.loading || snapshot == null) {
            return const Center(
              child: CircularProgressIndicator(color: GlanceTheme.green),
            );
          }
          final settings = controller.settings;
          final isIos = defaultTargetPlatform == TargetPlatform.iOS;
          return SafeArea(
            child: ListView(
              padding: const EdgeInsets.only(bottom: 36),
              children: [
                _HubAppBar(onBack: () => context.safePopOrHome()),
                const _SectionLabel('Widget templates'),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18),
                  child: _TemplateGrid(
                    snapshot: snapshot,
                    onTemplateTap: () => context.push('/glance/widgets/config'),
                  ),
                ),
                const _SectionLabel('Add to home screen'),
                _GuideCard(isIos: isIos),
                Padding(
                  padding: const EdgeInsets.fromLTRB(18, 8, 18, 0),
                  child: Text(
                    isIos
                        ? 'Add Solgo Insight Glance from the iOS widget picker. Home and Lock Screen widgets update from the last shared Glance snapshot.'
                        : 'Android does not let apps place widgets for you. This is a system action, and steps may vary slightly by phone brand.',
                    style: GlanceTheme.label.copyWith(
                      color: GlanceTheme.dim,
                      fontSize: 10.5,
                      height: 1.5,
                    ),
                  ),
                ),
                _SectionLabel(
                  isIos
                      ? 'Home & lock screen widgets'
                      : 'Persistent notification',
                ),
                if (isIos)
                  _OptionCard(
                    children: [
                      _OptionRow(
                        icon: Icons.widgets_outlined,
                        title: 'Home Screen Widget',
                        subtitle:
                            'Small and medium widgets use the latest Glance snapshot',
                        trailing: const Icon(
                          Icons.ios_share_rounded,
                          color: GlanceTheme.dim,
                          size: 18,
                        ),
                      ),
                      _OptionRow(
                        icon: Icons.lock_outline,
                        title: 'Lock Screen Glance',
                        subtitle:
                            'Accessory widget on iOS 16+. AOD follows iOS behavior.',
                        trailing: const Icon(
                          Icons.chevron_right_rounded,
                          color: GlanceTheme.dim,
                          size: 18,
                        ),
                        onTap: () => context.push('/glance/notification'),
                      ),
                    ],
                  )
                else
                  _OptionCard(
                    children: [
                      _OptionRow(
                        icon: Icons.notifications_none,
                        title: 'Show in notification bar',
                        subtitle:
                            'Always-on glucose status, silent and low-priority',
                        trailing: _HubToggle(
                          value: settings.enabled,
                          onChanged: controller.setNotificationEnabled,
                        ),
                      ),
                      _OptionRow(
                        icon: Icons.lock_outline,
                        title: 'Notification display',
                        subtitle: 'Silent status only. Alerts remain separate.',
                        trailing: const Icon(
                          Icons.chevron_right_rounded,
                          color: GlanceTheme.dim,
                          size: 18,
                        ),
                        onTap: () => context.push('/glance/notification'),
                      ),
                      const _OptionRow(
                        title: 'Graph in expanded view',
                        trailing: _HubToggle(value: true),
                      ),
                      _OptionRow(
                        title: 'Quick actions',
                        subtitle: 'Open - Data source - Settings',
                        trailing: _HubToggle(
                          value: settings.quickActionsEnabled,
                          onChanged: controller.setQuickActionsEnabled,
                        ),
                        onTap: () => context.push('/glance/notification'),
                      ),
                      _OptionRow(
                        title: 'Low-battery friendly mode',
                        subtitle: 'Reduces refresh frequency to save power',
                        trailing: _HubToggle(
                          value: settings.lowBatteryMode,
                          onChanged: controller.setLowBatteryMode,
                        ),
                      ),
                    ],
                  ),
                if (controller.notificationPermissionDenied) ...[
                  const SizedBox(height: 10),
                  const _PermissionNotice(),
                ],
                const _SectionLabel('Lock screen glance'),
                _ModeCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GlanceLockScreenModeSelector(
                        value: settings.lockScreenMode,
                        onChanged: controller.setLockScreenMode,
                      ),
                      const SizedBox(height: 12),
                      GlanceExternalSurfacePreview(
                        snapshot: snapshot,
                        mode: settings.notificationDisplayMode,
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Full value is visible before unlocking. Change this to Private on shared devices.',
                        style: GlanceTheme.label.copyWith(
                          color: GlanceTheme.amber,
                          fontSize: 10.5,
                          height: 1.45,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
                const _SectionLabel('AOD-friendly'),
                _ModeCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GlanceAodModeSelector(
                        enabled: settings.aodFriendlyEnabled,
                        onChanged: controller.setAodFriendlyEnabled,
                      ),
                      const SizedBox(height: 10),
                      GlanceExternalSurfacePreview(
                        snapshot: snapshot,
                        mode: settings.notificationDisplayMode,
                        aodFriendly: true,
                      ),
                    ],
                  ),
                ),
                if (isIos) ...[
                  const _SectionLabel('Floating glance'),
                  const _IosFloatingUnavailableCard(),
                ] else ...[
                  const _SectionLabel('Floating glance'),
                  FloatingGlanceCard(
                    enabled: controller.floatingSettings.enabled,
                    permissionGranted: controller.floatingPermissionGranted,
                    snapshot: snapshot,
                    onEnabledChanged: controller.setFloatingEnabled,
                    onRequestPermission: controller.requestFloatingPermission,
                  ),
                ],
                const _SectionLabel('Privacy'),
                _OptionCard(
                  children: const [
                    _OptionRow(
                      title: 'Private mode text',
                      subtitle: 'Glucose data available - Unlock to view',
                      trailing: Icon(
                        Icons.lock_outline,
                        color: GlanceTheme.dim,
                        size: 18,
                      ),
                    ),
                  ],
                ),
                const _PrivacyNotice(),
                const _BoundaryNote(),
              ],
            ),
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
      margin: const EdgeInsets.symmetric(horizontal: 18),
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

class _HubAppBar extends StatelessWidget {
  final VoidCallback onBack;

  const _HubAppBar({required this.onBack});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 12, 18, 4),
      child: Row(
        children: [
          IconButton(
            onPressed: onBack,
            icon: const Icon(
              Icons.arrow_back_ios_new_rounded,
              color: GlanceTheme.soft,
              size: 20,
            ),
          ),
          const SizedBox(width: 2),
          Expanded(
            child: Text(
              'Widgets & Notification',
              style: GlanceTheme.label.copyWith(
                fontSize: 19,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String text;

  const _SectionLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 22, 20, 10),
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

class _TemplateGrid extends StatelessWidget {
  final GlanceSnapshot snapshot;
  final VoidCallback onTemplateTap;

  const _TemplateGrid({
    required this.snapshot,
    required this.onTemplateTap,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final columns = switch (width) {
          >= 720 => 4,
          >= 520 => 3,
          _ => 2,
        };
        return GridView.count(
          crossAxisCount: columns,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: .78,
          children: [
            for (final template in GlanceWidgetTemplate.values)
              GlanceTemplatePreviewCard(
                template: template,
                snapshot: snapshot,
                onTap: onTemplateTap,
              ),
          ],
        );
      },
    );
  }
}

class _GuideCard extends StatelessWidget {
  final bool isIos;

  const _GuideCard({required this.isIos});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 18),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: GlanceTheme.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: GlanceTheme.blue.withOpacity(.22)),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            GlanceTheme.blue.withOpacity(.07),
            Colors.transparent,
          ],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.add_box_outlined, color: GlanceTheme.blue, size: 19),
              const SizedBox(width: 9),
              Text(
                isIos ? 'How to add Glance' : 'How to place a widget',
                style: GlanceTheme.label.copyWith(
                  fontSize: 13.5,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const Spacer(),
              Icon(
                Icons.widgets_outlined,
                color: GlanceTheme.blue.withOpacity(.85),
                size: 17,
              ),
            ],
          ),
          const SizedBox(height: 12),
          _Step(
            number: 1,
            text: isIos
                ? 'Long-press the Home Screen, then tap Add Widget'
                : 'Long-press any empty area of your home screen',
          ),
          _Step(
            number: 2,
            text: isIos
                ? 'Search for Solgo Insight Glance'
                : 'Tap Widgets, then scroll to Solgo Insight',
          ),
          _Step(
            number: 3,
            text: isIos
                ? 'Choose Small, Medium, or Lock Screen accessory'
                : 'Drag a template onto the screen and configure it',
          ),
        ],
      ),
    );
  }
}

class _OptionCard extends StatelessWidget {
  final List<Widget> children;

  const _OptionCard({required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 18),
      decoration: BoxDecoration(
        color: GlanceTheme.card,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: GlanceTheme.border),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          for (var i = 0; i < children.length; i++) ...[
            children[i],
            if (i != children.length - 1)
              Container(height: 1, color: GlanceTheme.border),
          ],
        ],
      ),
    );
  }
}

class _OptionRow extends StatelessWidget {
  final IconData? icon;
  final String title;
  final String? subtitle;
  final Widget trailing;
  final VoidCallback? onTap;

  const _OptionRow({
    this.icon,
    required this.title,
    this.subtitle,
    required this.trailing,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            if (icon != null) ...[
              Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  color: GlanceTheme.card2,
                  borderRadius: BorderRadius.circular(9),
                ),
                child: Icon(icon, size: 16, color: GlanceTheme.soft),
              ),
              const SizedBox(width: 12),
            ],
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GlanceTheme.label.copyWith(
                      color: GlanceTheme.text,
                      fontSize: 13.5,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(height: 2),
                    Text(
                      subtitle!,
                      style: GlanceTheme.label.copyWith(
                        color: GlanceTheme.soft,
                        fontSize: 11,
                        height: 1.4,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(width: 12),
            trailing,
          ],
        ),
      ),
    );
  }
}

class _HubToggle extends StatelessWidget {
  final bool value;
  final ValueChanged<bool>? onChanged;

  const _HubToggle({
    required this.value,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onChanged == null ? null : () => onChanged!(!value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        width: 42,
        height: 24,
        padding: const EdgeInsets.all(2),
        decoration: BoxDecoration(
          color: value ? GlanceTheme.green.withOpacity(.22) : GlanceTheme.card2,
          borderRadius: BorderRadius.circular(13),
          border: Border.all(
            color: value ? GlanceTheme.green : GlanceTheme.borderMid,
            width: 1.5,
          ),
        ),
        child: AnimatedAlign(
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeOutCubic,
          alignment: value ? Alignment.centerRight : Alignment.centerLeft,
          child: Container(
            width: 17,
            height: 17,
            decoration: BoxDecoration(
              color: value ? GlanceTheme.green : GlanceTheme.dim,
              shape: BoxShape.circle,
            ),
          ),
        ),
      ),
    );
  }
}

class _Step extends StatelessWidget {
  final int number;
  final String text;

  const _Step({
    required this.number,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 22,
            height: 22,
            margin: const EdgeInsets.only(top: 1),
            decoration: BoxDecoration(
              color: GlanceTheme.blue.withOpacity(.12),
              borderRadius: BorderRadius.circular(7),
              border: Border.all(color: GlanceTheme.blue.withOpacity(.24)),
            ),
            child: Center(
              child: Text(
                '$number',
                style: GlanceTheme.mono.copyWith(
                  color: GlanceTheme.blue,
                  fontSize: 11,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
          ),
          const SizedBox(width: 11),
          Expanded(
            child: Text(
              text,
              style: GlanceTheme.label.copyWith(
                color: GlanceTheme.text,
                fontSize: 12.5,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PrivacyNotice extends StatelessWidget {
  const _PrivacyNotice();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(18, 10, 18, 0),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: GlanceTheme.green.withOpacity(.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: GlanceTheme.green.withOpacity(.20)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.shield_outlined, color: GlanceTheme.green, size: 15),
          const SizedBox(width: 9),
          Expanded(
            child: Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: 'Shared device? ',
                    style: GlanceTheme.label.copyWith(
                      color: GlanceTheme.green,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const TextSpan(
                    text:
                        'Widgets and notifications show glucose on your home screen and lock screen. Private mode keeps the number hidden.',
                  ),
                ],
              ),
              style: GlanceTheme.label.copyWith(
                color: GlanceTheme.soft,
                fontSize: 11,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _IosFloatingUnavailableCard extends StatelessWidget {
  const _IosFloatingUnavailableCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 18),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: GlanceTheme.card,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: GlanceTheme.border),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: GlanceTheme.card2,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.layers_outlined,
              color: GlanceTheme.soft,
              size: 17,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Floating Glance is Android only. iOS uses Home Screen and Lock Screen widgets for external display.',
              style: GlanceTheme.label.copyWith(
                color: GlanceTheme.soft,
                fontSize: 11.5,
                height: 1.45,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PermissionNotice extends StatelessWidget {
  const _PermissionNotice();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
        color: GlanceTheme.amber.withOpacity(.09),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: GlanceTheme.amber.withOpacity(.28)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.notifications_off_outlined,
            size: 18,
            color: GlanceTheme.amber,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              'Notifications are blocked by Android. Allow notifications for Solgo Insight to show Glance on the lock screen.',
              style: GlanceTheme.label.copyWith(
                color: GlanceTheme.soft,
                fontSize: 11,
                height: 1.45,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _BoundaryNote extends StatelessWidget {
  const _BoundaryNote();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 0),
      child: Text.rich(
        TextSpan(
          children: [
            const TextSpan(
              text: 'Widgets and the persistent notification are for ',
            ),
            TextSpan(
              text: 'viewing',
              style: GlanceTheme.label.copyWith(
                color: GlanceTheme.soft,
                fontWeight: FontWeight.w800,
              ),
            ),
            const TextSpan(
              text:
                  ', not alerting. They never replace your xDrip+, Nightscout, or CGM alarms.',
            ),
          ],
        ),
        style: GlanceTheme.label.copyWith(
          color: GlanceTheme.dim,
          fontSize: 10.5,
          height: 1.6,
        ),
      ),
    );
  }
}
