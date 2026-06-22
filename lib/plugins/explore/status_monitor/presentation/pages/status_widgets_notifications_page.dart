import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:smart_xdrip/plugin_platform/services/plugin_service_registry.dart';

import '../../application/status_persistent_notification_service.dart';
import '../../application/floating/status_floating_payload_builder.dart';
import '../../application/floating/status_floating_service.dart';
import '../../application/i18n/status_monitor_l10n.dart';
import '../../data/sqlite/sqlite_status_floating_settings_repository.dart';
import '../../domain/floating/status_floating_mode.dart';
import '../../domain/floating/status_floating_payload.dart';
import '../../domain/floating/status_floating_settings.dart';
import '../../application/widget/status_widget_service.dart';
import '../../domain/widget/status_widget_settings.dart';
import '../../domain/widget/status_widget_snapshot.dart';
import '../../l10n/generated/status_monitor_localizations.dart';
import '../../runtime/status_monitor_runtime_cache.dart';
import '../styles/status_monitor_theme.dart';
import '../widgets/status_monitor_page_header.dart';
import '../widgets/widget/status_widget_preview.dart';
import '../widgets_external/status_monitor_floating_card.dart';

class StatusWidgetsNotificationsPage extends StatefulWidget {
  const StatusWidgetsNotificationsPage({super.key});

  @override
  State<StatusWidgetsNotificationsPage> createState() =>
      _StatusWidgetsNotificationsPageState();
}

class _StatusWidgetsNotificationsPageState
    extends State<StatusWidgetsNotificationsPage> {
  late final StatusWidgetService widgetService;
  late final StatusPersistentNotificationService notificationService;
  late final SqliteStatusFloatingSettingsRepository floatingSettingsRepository;
  late final StatusFloatingService floatingService;
  late final StatusMonitorRuntimeCache cache;
  final StatusFloatingPayloadBuilder floatingPayloadBuilder =
      const StatusFloatingPayloadBuilder();
  StatusWidgetSettings? settings;
  StatusWidgetSnapshot? snapshot;
  StatusFloatingSettings floatingSettings = StatusFloatingSettings.defaults();
  StatusFloatingPayload? floatingPayload;
  bool floatingPermissionGranted = false;
  bool loading = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final services = context.read<PluginServiceRegistry>();
    widgetService = services.get<StatusWidgetService>();
    notificationService = services.get<StatusPersistentNotificationService>();
    floatingSettingsRepository =
        services.get<SqliteStatusFloatingSettingsRepository>();
    floatingService = services.get<StatusFloatingService>();
    cache = services.get<StatusMonitorRuntimeCache>();
    cache.addListener(_reload);
    _reload();
  }

  @override
  void dispose() {
    cache.removeListener(_reload);
    super.dispose();
  }

  Future<void> _reload() async {
    final report = cache.report;
    if (report == null) {
      if (!mounted) return;
      setState(() {
        loading = false;
        settings = null;
        snapshot = null;
      });
      return;
    }
    final nextSettings = await widgetService.settings(report.subjectId);
    final nextSnapshot = await widgetService.snapshot(report);
    final nextFloatingSettings = await floatingSettingsRepository.get();
    final nextFloatingPermission = await floatingService.hasPermission();
    final nextFloatingPayload = floatingPayloadBuilder.build(report: report);
    if (!mounted) return;
    setState(() {
      settings = nextSettings;
      snapshot = nextSnapshot;
      floatingSettings = nextFloatingSettings;
      floatingPermissionGranted = nextFloatingPermission;
      floatingPayload = nextFloatingPayload;
      loading = false;
    });
  }

  Future<void> _setPersistentNotificationEnabled(bool enabled) async {
    final report = cache.report;
    if (report == null) return;
    await notificationService.setPersistentNotificationEnabled(
      report,
      enabled,
    );
    await _reload();
  }

  Future<void> _setLockScreenEnabled(bool enabled) async {
    final report = cache.report;
    if (report == null) return;
    await notificationService.setLockScreenEnabled(report, enabled);
    await _reload();
  }

  Future<void> _setLowBatteryMode(bool enabled) async {
    final report = cache.report;
    if (report == null) return;
    await notificationService.setLowBatteryMode(report.subjectId, enabled);
    await _reload();
  }

  Future<void> _setFloatingEnabled(bool enabled) async {
    final report = cache.report;
    await floatingService.setEnabled(enabled);
    if (report != null) {
      if (enabled) {
        await floatingService.startIfAvailable(report);
      } else {
        await floatingService.stop();
      }
    }
    await _reload();
  }

  Future<void> _requestFloatingPermission() async {
    await floatingService.requestPermission();
    await _reload();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.statusMonitorL10n;
    final currentSettings = settings;
    final currentSnapshot = snapshot;
    final currentFloatingPayload = floatingPayload;
    return Scaffold(
      backgroundColor: StatusMonitorTheme.bg,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.only(bottom: 32),
          children: [
            StatusMonitorPageHeader(
              eyebrow: l10n.pageEyebrowStatusMonitor,
              title: l10n.pageWidgetsTitle,
              subtitle: l10n.pageWidgetsSubtitle,
              onBack: () => context.pop(),
            ),
            if (loading)
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(32),
                  child: CircularProgressIndicator(
                    color: StatusMonitorTheme.green,
                  ),
                ),
              )
            else if (currentSettings == null || currentSnapshot == null)
              _NoStatusCard(l10n: l10n)
            else ...[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: _SectionLabel(l10n.pageWidgetTemplates),
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: StatusWidgetTemplateGallery(snapshot: currentSnapshot),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: _SectionLabel(l10n.pageAddToHomeScreen),
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: _HowToPlaceCard(l10n: l10n),
              ),
              if (currentFloatingPayload != null) ...[
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: _SectionLabel(l10n.pageFloatingStatusBar),
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: StatusMonitorFloatingCard(
                    enabled:
                        floatingSettings.mode == StatusFloatingMode.enabled,
                    permissionGranted: floatingPermissionGranted,
                    payload: currentFloatingPayload,
                    onEnabledChanged: _setFloatingEnabled,
                    onRequestPermission: _requestFloatingPermission,
                  ),
                ),
              ],
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: _SectionLabel(l10n.pageLockScreenStatus),
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: _LockScreenCard(
                  snapshot: currentSnapshot,
                  enabled: currentSettings.lockScreenEnabled,
                  l10n: l10n,
                  onChanged: _setLockScreenEnabled,
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: _SectionLabel(l10n.pageStatusNotification),
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: _OptionGroup(
                  children: [
                    _OptionRow(
                      icon: Icons.notifications_none_rounded,
                      title: l10n.pageShowNotificationTitle,
                      subtitle: l10n.pageShowNotificationSubtitle,
                      trailing: _StatusToggle(
                        value: currentSettings.persistentNotificationEnabled,
                        onChanged: _setPersistentNotificationEnabled,
                      ),
                    ),
                    _OptionRow(
                      icon: Icons.battery_saver_rounded,
                      title: l10n.pageLowBatteryTitle,
                      subtitle: l10n.pageLowBatterySubtitle,
                      trailing: _StatusToggle(
                        value: currentSettings.lowBatteryMode,
                        onChanged: _setLowBatteryMode,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _LockScreenCard extends StatelessWidget {
  final StatusWidgetSnapshot snapshot;
  final bool enabled;
  final StatusMonitorLocalizations l10n;
  final ValueChanged<bool> onChanged;

  const _LockScreenCard({
    required this.snapshot,
    required this.enabled,
    required this.l10n,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: StatusMonitorTheme.cardDecoration(),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: StatusMonitorTheme.green.withOpacity(.10),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: StatusMonitorTheme.green.withOpacity(.20),
              ),
            ),
            child: const Icon(
              Icons.lock_clock_outlined,
              color: StatusMonitorTheme.green,
              size: 20,
            ),
          ),
          const SizedBox(width: 13),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  enabled
                      ? snapshot.lockScreenText
                      : l10n.pageLockScreenDisabled,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: StatusMonitorTheme.inter.copyWith(
                    color: StatusMonitorTheme.text,
                    fontSize: 13.5,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  l10n.pageNotificationLowPriorityNote,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: StatusMonitorTheme.inter.copyWith(
                    color: StatusMonitorTheme.soft,
                    fontSize: 11.5,
                    height: 1.35,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          _StatusToggle(value: enabled, onChanged: onChanged),
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
    return Text(
      text.toUpperCase(),
      style: StatusMonitorTheme.mono.copyWith(
        color: StatusMonitorTheme.dim,
        fontSize: 10,
        fontWeight: FontWeight.w900,
        letterSpacing: 1.25,
      ),
    );
  }
}

class _OptionGroup extends StatelessWidget {
  final List<Widget> children;

  const _OptionGroup({required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: StatusMonitorTheme.cardDecoration(),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          for (var i = 0; i < children.length; i++) ...[
            children[i],
            if (i != children.length - 1)
              Container(height: 1, color: StatusMonitorTheme.border),
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

  const _OptionRow({
    this.icon,
    required this.title,
    this.subtitle,
    required this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 14),
      child: Row(
        children: [
          if (icon != null) ...[
            Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                color: StatusMonitorTheme.card2,
                borderRadius: BorderRadius.circular(11),
              ),
              child: Icon(icon, color: StatusMonitorTheme.soft, size: 18),
            ),
            const SizedBox(width: 12),
          ],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: StatusMonitorTheme.inter.copyWith(
                    color: StatusMonitorTheme.text,
                    fontSize: 13.5,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                if (subtitle != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    subtitle!,
                    style: StatusMonitorTheme.inter.copyWith(
                      color: StatusMonitorTheme.soft,
                      fontSize: 11.5,
                      height: 1.35,
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
    );
  }
}

class _StatusToggle extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;

  const _StatusToggle({
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => onChanged(!value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        width: 42,
        height: 24,
        padding: const EdgeInsets.all(2),
        decoration: BoxDecoration(
          color: value
              ? StatusMonitorTheme.green.withOpacity(.22)
              : StatusMonitorTheme.card2,
          borderRadius: BorderRadius.circular(13),
          border: Border.all(
            color: value ? StatusMonitorTheme.green : StatusMonitorTheme.border,
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
              color: value ? StatusMonitorTheme.green : StatusMonitorTheme.dim,
              shape: BoxShape.circle,
            ),
          ),
        ),
      ),
    );
  }
}

class _HowToPlaceCard extends StatelessWidget {
  final StatusMonitorLocalizations l10n;

  const _HowToPlaceCard({required this.l10n});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: StatusMonitorTheme.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: StatusMonitorTheme.blue.withOpacity(.22)),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            StatusMonitorTheme.blue.withOpacity(.07),
            Colors.transparent,
          ],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.add_box_outlined,
                color: StatusMonitorTheme.blue,
                size: 19,
              ),
              const SizedBox(width: 9),
              Text(
                l10n.pageHowToPlaceWidget,
                style: StatusMonitorTheme.inter.copyWith(
                  color: StatusMonitorTheme.text,
                  fontSize: 13.5,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const Spacer(),
              Icon(
                Icons.widgets_outlined,
                color: StatusMonitorTheme.blue.withOpacity(.85),
                size: 17,
              ),
            ],
          ),
          const SizedBox(height: 12),
          _Step(
            number: 1,
            text: l10n.pageWidgetStepLongPress,
          ),
          _Step(
            number: 2,
            text: l10n.pageWidgetStepTapWidgets,
          ),
          _Step(
            number: 3,
            text: l10n.pageWidgetStepDragTemplate,
          ),
        ],
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
              color: StatusMonitorTheme.blue.withOpacity(.12),
              borderRadius: BorderRadius.circular(7),
              border:
                  Border.all(color: StatusMonitorTheme.blue.withOpacity(.24)),
            ),
            child: Center(
              child: Text(
                '$number',
                style: StatusMonitorTheme.mono.copyWith(
                  color: StatusMonitorTheme.blue,
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
              style: StatusMonitorTheme.inter.copyWith(
                color: StatusMonitorTheme.text,
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

class _NoStatusCard extends StatelessWidget {
  final StatusMonitorLocalizations l10n;

  const _NoStatusCard({required this.l10n});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: StatusMonitorTheme.cardDecoration(),
      child: Text(
        l10n.pageStatusDataNotReady,
        style: StatusMonitorTheme.inter.copyWith(
          color: StatusMonitorTheme.soft,
          fontSize: 13,
          height: 1.4,
        ),
      ),
    );
  }
}
