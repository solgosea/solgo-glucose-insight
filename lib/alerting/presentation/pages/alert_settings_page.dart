import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../app/di/app_container.dart';
import '../../../foundation/theme/app_colors.dart';
import '../../../presentation/common/widgets/section_label.dart';
import '../controllers/alert_settings_controller.dart';
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
            final snapshot = _controller.snapshot;
            return ListView(
              padding: const EdgeInsets.only(bottom: 28),
              children: [
                _Header(
                  onBack:
                      () =>
                          context.canPop()
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
                  const SectionLabel('Alert System'),
                  AlertSettingsCard(
                    icon: Icons.power_settings_new_rounded,
                    title: 'Enable alerts',
                    subtitle:
                        'Master switch for glucose safety alerts and future alert sources.',
                    enabled: snapshot.globalEnabled,
                    onChanged: _controller.toggleGlobal,
                    details: [
                      snapshot.criticalOnly
                          ? 'Critical only'
                          : 'All severities',
                    ],
                  ),
                  AlertSettingsCard(
                    icon: Icons.priority_high_rounded,
                    title: 'Critical only',
                    subtitle:
                        'Only urgent events can trigger delivery strategies.',
                    enabled: snapshot.criticalOnly,
                    onChanged: _controller.toggleCriticalOnly,
                  ),
                  const SectionLabel('Delivery Strategies'),
                  AlertSettingsCard(
                    icon: Icons.web_asset_rounded,
                    title: 'In-app alert',
                    subtitle:
                        'Show a visible alert card while the app is open.',
                    enabled: snapshot.inAppEnabled,
                    onChanged: _controller.toggleInApp,
                    details: [
                      snapshot.fullScreenForCritical
                          ? 'Critical full screen ready'
                          : 'Compact mode',
                    ],
                  ),
                  AlertSettingsCard(
                    icon: Icons.notifications_active_rounded,
                    title: 'System notification',
                    subtitle: 'Use the operating system notification channel.',
                    enabled: snapshot.localNotificationEnabled,
                    onChanged: _controller.toggleLocalNotification,
                    details: const ['High priority channel'],
                  ),
                  AlertSettingsCard(
                    icon: Icons.volume_up_rounded,
                    title: 'Sound alert',
                    subtitle:
                        'Choose system, built-in, custom, or silent sound behavior.',
                    enabled: snapshot.soundEnabled,
                    onChanged: _controller.toggleSound,
                    onTap: _openSoundSelector,
                    details: [
                      snapshot.soundLabel,
                      '${snapshot.soundMaxDurationSeconds}s max',
                      snapshot.repeatCriticalSound
                          ? 'Repeat critical'
                          : 'Single',
                    ],
                  ),
                  AlertSettingsCard(
                    icon: Icons.vibration_rounded,
                    title: 'Vibration alert',
                    subtitle:
                        'Use vibration patterns for warning and critical events.',
                    enabled: snapshot.vibrationEnabled,
                    onChanged: _controller.toggleVibration,
                    details: [
                      'Critical: ${snapshot.criticalVibrationLabel}',
                      'Warning: ${snapshot.warningVibrationLabel}',
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
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Previewing ${sound.displayName}'),
                      duration: const Duration(milliseconds: 700),
                    ),
                  );
                  await _controller.previewSound(sound);
                } catch (_) {
                  if (!context.mounted) return;
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Could not preview this sound'),
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
                    const SnackBar(
                      content: Text(
                        'Could not import this audio file. Try a smaller local file.',
                      ),
                    ),
                  );
                } catch (_) {
                  if (!context.mounted) return;
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Could not import this audio file'),
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
}

class _Header extends StatelessWidget {
  final VoidCallback onBack;

  const _Header({required this.onBack});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 8),
      child: Row(
        children: [
          IconButton(
            onPressed: onBack,
            icon: const Icon(Icons.arrow_back_rounded, color: AppColors.text),
          ),
          const SizedBox(width: 6),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Alert Settings',
                  style: TextStyle(
                    color: AppColors.text,
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Configure notification, sound, vibration, and in-app behavior.',
                  style: TextStyle(color: AppColors.textSoft, fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
