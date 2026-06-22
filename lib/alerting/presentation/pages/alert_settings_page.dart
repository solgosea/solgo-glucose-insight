import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../app/di/app_container.dart';
import '../../runtime/alert_runtime_coordinator.dart';
import '../../../foundation/theme/app_colors.dart';
import '../../../presentation/common/widgets/section_label.dart';
import '../../application/i18n/alerting_l10n.dart';
import '../../domain/resource/alert_sound_ref.dart';
import '../../l10n/generated/alerting_localizations.dart';
import '../controllers/alert_settings_controller.dart';
import '../widgets/alert_runtime_notice.dart';
import '../widgets/alert_settings_card.dart';
import '../widgets/alert_sound_selector_sheet.dart';

class AlertSettingsPage extends StatefulWidget {
  const AlertSettingsPage({super.key});

  @override
  State<AlertSettingsPage> createState() => _AlertSettingsPageState();
}

class _AlertSettingsPageState extends State<AlertSettingsPage> {
  late final AlertSettingsController _controller;

  @override
  void initState() {
    super.initState();
    final factory = context.read<AppContainer>().alertingRuntimeFactory;
    _controller = AlertSettingsController(
      repository: factory.configRepository(),
    );
    _controller.load();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: SafeArea(
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, _) {
            final l10n = context.alertingL10n;
            final snapshot = _controller.snapshot;
            final container = context.read<AppContainer>();
            final alertRuntimeStatus = AlertRuntimeCoordinator(
              platformCapabilities: container.platformRuntimeCapabilities,
            ).status;
            return ListView(
              padding: const EdgeInsets.only(bottom: 28),
              children: [
                _Header(
                  onBack: () => context.canPop()
                      ? context.pop()
                      : context.go('/settings'),
                ),
                if (_controller.loading)
                  const Padding(
                    padding: EdgeInsets.only(top: 40),
                    child: Center(
                      child: CircularProgressIndicator(color: AppColors.green),
                    ),
                  )
                else ...[
                  SectionLabel(l10n.alertSystemSection),
                  AlertRuntimeNotice(
                    status: alertRuntimeStatus,
                  ),
                  AlertSettingsCard(
                    icon: Icons.power_settings_new_rounded,
                    title: l10n.enableAlertsTitle,
                    subtitle: l10n.enableAlertsSubtitle,
                    enabled: snapshot.globalEnabled,
                    onChanged: _controller.toggleGlobal,
                    details: [
                      snapshot.criticalOnly
                          ? l10n.detailCriticalOnly
                          : l10n.detailAllSeverities,
                    ],
                  ),
                  AlertSettingsCard(
                    icon: Icons.priority_high_rounded,
                    title: l10n.criticalOnlyTitle,
                    subtitle: l10n.criticalOnlySubtitle,
                    enabled: snapshot.criticalOnly,
                    onChanged: _controller.toggleCriticalOnly,
                  ),
                  SectionLabel(l10n.deliveryStrategiesSection),
                  AlertSettingsCard(
                    icon: Icons.web_asset_rounded,
                    title: l10n.inAppAlertTitle,
                    subtitle: l10n.inAppAlertSubtitle,
                    enabled: snapshot.inAppEnabled,
                    onChanged: _controller.toggleInApp,
                    details: [
                      snapshot.fullScreenForCritical
                          ? l10n.detailCriticalFullScreenReady
                          : l10n.detailCompactMode,
                    ],
                  ),
                  AlertSettingsCard(
                    icon: Icons.notifications_active_rounded,
                    title: l10n.systemNotificationTitle,
                    subtitle: l10n.systemNotificationSubtitle,
                    enabled: snapshot.localNotificationEnabled,
                    onChanged: _controller.toggleLocalNotification,
                    details: [l10n.detailHighPriorityChannel],
                  ),
                  AlertSettingsCard(
                    icon: Icons.volume_up_rounded,
                    title: l10n.soundAlertTitle,
                    subtitle: l10n.soundAlertSubtitle,
                    enabled: snapshot.soundEnabled,
                    onChanged: _controller.toggleSound,
                    onTap: _openSoundSelector,
                    details: [
                      _soundDisplayName(l10n, _controller.selectedSound),
                      l10n.soundMaxDuration(
                        snapshot.soundMaxDurationSeconds,
                      ),
                      snapshot.repeatCriticalSound
                          ? l10n.detailRepeatCritical
                          : l10n.detailSingle,
                    ],
                  ),
                  AlertSettingsCard(
                    icon: Icons.vibration_rounded,
                    title: l10n.vibrationAlertTitle,
                    subtitle: l10n.vibrationAlertSubtitle,
                    enabled: snapshot.vibrationEnabled,
                    onChanged: _controller.toggleVibration,
                    details: [
                      l10n.vibrationCritical(
                        _vibrationLabel(l10n, snapshot.criticalVibrationLabel),
                      ),
                      l10n.vibrationWarning(
                        _vibrationLabel(l10n, snapshot.warningVibrationLabel),
                      ),
                    ],
                  ),
                ],
              ],
            );
          },
        ),
      ),
    );
  }

  Future<void> _openSoundSelector() async {
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: AppColors.bg,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (context) {
        return AnimatedBuilder(
          animation: _controller,
          builder: (context, _) {
            return AlertSoundSelectorSheet(
              selected: _controller.selectedSound,
              importing: _controller.importingSound,
              previewing: _controller.previewingSound,
              onPreview: (sound) async {
                try {
                  final l10n = context.alertingL10n;
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(l10n.previewingSound(sound.displayName)),
                      duration: const Duration(milliseconds: 700),
                    ),
                  );
                  await _controller.previewSound(sound);
                } catch (_) {
                  if (!context.mounted) return;
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(context.alertingL10n.couldNotPreviewSound),
                    ),
                  );
                }
              },
              onSelected: (sound) async {
                await _controller.selectSound(sound);
                if (context.mounted) Navigator.of(context).pop();
              },
              onImportCustom: () async {
                try {
                  final sound = await _controller.importCustomSound();
                  if (!context.mounted) return;
                  if (sound != null) {
                    Navigator.of(context).pop();
                    return;
                  }
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        context.alertingL10n.couldNotImportAudioTrySmaller,
                      ),
                    ),
                  );
                } catch (_) {
                  if (!context.mounted) return;
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(context.alertingL10n.couldNotImportAudio),
                    ),
                  );
                }
              },
            );
          },
        );
      },
    );
  }

  String _soundDisplayName(
    AlertingLocalizations l10n,
    AlertSoundRef sound,
  ) {
    if (sound.source == AlertSoundSource.silent) return l10n.soundSilent;
    return switch (sound.uri) {
      'audio/alerts/steady_ping.wav' => l10n.soundSteadyPing,
      'audio/alerts/urgent_pulse.wav' => l10n.soundUrgentPulse,
      'audio/alerts/gentle_chime.wav' => l10n.soundGentleChime,
      'audio/alerts/soft_bell.wav' => l10n.soundSoftBell,
      _ => sound.displayName,
    };
  }

  String _vibrationLabel(AlertingLocalizations l10n, String label) {
    return switch (label) {
      'Critical repeat' => l10n.vibrationCriticalRepeat,
      'Short warning' => l10n.vibrationShortWarning,
      _ => label,
    };
  }
}

class _Header extends StatelessWidget {
  final VoidCallback onBack;

  const _Header({required this.onBack});

  @override
  Widget build(BuildContext context) {
    final l10n = context.alertingL10n;
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 8),
      child: Row(
        children: [
          IconButton(
            onPressed: onBack,
            icon: const Icon(Icons.arrow_back_rounded, color: AppColors.text),
          ),
          const SizedBox(width: 6),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.alertingTitle,
                  style: const TextStyle(
                    color: AppColors.text,
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  l10n.alertingSubtitle,
                  style:
                      const TextStyle(color: AppColors.textSoft, fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
