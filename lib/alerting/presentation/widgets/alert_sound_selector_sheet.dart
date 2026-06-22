import 'package:flutter/material.dart';

import '../../../foundation/theme/app_colors.dart';
import '../../application/i18n/alerting_l10n.dart';
import '../../application/sound/alert_sound_catalog.dart';
import '../../domain/resource/alert_sound_ref.dart';

class AlertSoundSelectorSheet extends StatelessWidget {
  final AlertSoundRef selected;
  final bool importing;
  final AlertSoundRef? previewing;
  final ValueChanged<AlertSoundRef> onSelected;
  final Future<void> Function(AlertSoundRef sound) onPreview;
  final VoidCallback onImportCustom;

  const AlertSoundSelectorSheet({
    super.key,
    required this.selected,
    required this.importing,
    required this.previewing,
    required this.onSelected,
    required this.onPreview,
    required this.onImportCustom,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = context.alertingL10n;
    const catalog = AlertSoundCatalog();
    final builtInSounds = catalog.builtInSounds();
    final quietSounds = catalog.quietSounds();
    final customSound =
        selected.source == AlertSoundSource.file ? selected : null;

    final maxHeight = MediaQuery.sizeOf(context).height * .86;

    return SafeArea(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxHeight: maxHeight),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(20, 14, 20, 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Container(
                  width: 42,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.borderMid,
                    borderRadius: BorderRadius.circular(999),
                  ),
                ),
              ),
              const SizedBox(height: 18),
              Text(
                l10n.chooseSoundSourceTitle,
                style: const TextStyle(
                  color: AppColors.text,
                  fontSize: 20,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                l10n.chooseSoundSourceSubtitle,
                style: const TextStyle(
                  color: AppColors.textSoft,
                  fontSize: 12,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 18),
              _SectionTitle(l10n.builtInSoundsSection),
              for (final sound in builtInSounds)
                _SoundOptionTile(
                  sound: sound,
                  selected: _sameSound(sound, selected),
                  previewing: previewing,
                  onSelected: onSelected,
                  onPreview: onPreview,
                ),
              const SizedBox(height: 10),
              _SectionTitle(l10n.quietSection),
              for (final sound in quietSounds)
                _SoundOptionTile(
                  sound: sound,
                  selected: _sameSound(sound, selected),
                  previewing: previewing,
                  onSelected: onSelected,
                  onPreview: onPreview,
                ),
              const SizedBox(height: 10),
              _SectionTitle(l10n.customSection),
              if (customSound != null)
                _SoundOptionTile(
                  sound: customSound,
                  selected: true,
                  previewing: previewing,
                  onSelected: onSelected,
                  onPreview: onPreview,
                ),
              const SizedBox(height: 8),
              OutlinedButton.icon(
                onPressed: importing ? null : onImportCustom,
                icon: importing
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: AppColors.green,
                        ),
                      )
                    : const Icon(Icons.folder_open_rounded),
                label: Text(
                  importing ? l10n.importing : l10n.chooseAudioFile,
                ),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.green,
                  side: const BorderSide(color: AppColors.borderMid),
                  padding: const EdgeInsets.symmetric(vertical: 13),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  bool _sameSound(AlertSoundRef left, AlertSoundRef right) {
    return left.source == right.source && left.uri == right.uri;
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;

  const _SectionTitle(this.title);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        title.toUpperCase(),
        style: const TextStyle(
          color: AppColors.textDim,
          fontSize: 10,
          fontWeight: FontWeight.w900,
          letterSpacing: 0,
        ),
      ),
    );
  }
}

class _SoundOptionTile extends StatelessWidget {
  final AlertSoundRef sound;
  final bool selected;
  final AlertSoundRef? previewing;
  final ValueChanged<AlertSoundRef> onSelected;
  final Future<void> Function(AlertSoundRef sound) onPreview;

  const _SoundOptionTile({
    required this.sound,
    required this.selected,
    required this.previewing,
    required this.onSelected,
    required this.onPreview,
  });

  @override
  Widget build(BuildContext context) {
    final playable = sound.isPlayable;
    final isPreviewing = previewing != null && _sameSound(sound, previewing!);
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: selected
              ? AppColors.green.withValues(alpha: .12)
              : AppColors.bgCard,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: selected ? AppColors.green : AppColors.border,
          ),
        ),
        child: ListTile(
          dense: true,
          contentPadding: const EdgeInsets.fromLTRB(12, 4, 8, 4),
          leading: Container(
            width: 38,
            height: 38,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: AppColors.bgCard2,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              _iconFor(sound.source),
              color: selected ? AppColors.green : AppColors.textSoft,
              size: 20,
            ),
          ),
          title: Text(
            _displayNameFor(context, sound),
            style: const TextStyle(
              color: AppColors.text,
              fontSize: 14,
              fontWeight: FontWeight.w800,
            ),
          ),
          subtitle: Text(
            _subtitleFor(context, sound),
            style: const TextStyle(
              color: AppColors.textSoft,
              fontSize: 11,
            ),
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (playable)
                TextButton.icon(
                  onPressed: isPreviewing ? null : () => onPreview(sound),
                  icon: const Icon(
                    Icons.play_arrow_rounded,
                    size: 16,
                  ),
                  label: Text(
                    isPreviewing
                        ? context.alertingL10n.playing
                        : context.alertingL10n.preview,
                  ),
                  style: TextButton.styleFrom(
                    foregroundColor: AppColors.green,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 6,
                    ),
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                ),
              IconButton(
                tooltip: context.alertingL10n.select,
                onPressed: () => onSelected(sound),
                icon: Icon(
                  selected
                      ? Icons.check_circle_rounded
                      : Icons.radio_button_unchecked_rounded,
                  color: selected ? AppColors.green : AppColors.textDim,
                ),
              ),
            ],
          ),
          onTap: () => onSelected(sound),
        ),
      ),
    );
  }

  IconData _iconFor(AlertSoundSource source) {
    return switch (source) {
      AlertSoundSource.asset => Icons.graphic_eq_rounded,
      AlertSoundSource.file => Icons.audio_file_rounded,
      AlertSoundSource.silent => Icons.volume_off_rounded,
    };
  }

  String _displayNameFor(BuildContext context, AlertSoundRef sound) {
    final l10n = context.alertingL10n;
    if (sound.source == AlertSoundSource.silent) {
      return l10n.soundSilent;
    }
    return switch (sound.uri) {
      'audio/alerts/steady_ping.wav' => l10n.soundSteadyPing,
      'audio/alerts/urgent_pulse.wav' => l10n.soundUrgentPulse,
      'audio/alerts/gentle_chime.wav' => l10n.soundGentleChime,
      'audio/alerts/soft_bell.wav' => l10n.soundSoftBell,
      _ => sound.displayName,
    };
  }

  String _subtitleFor(BuildContext context, AlertSoundRef sound) {
    final l10n = context.alertingL10n;
    return switch (sound.source) {
      AlertSoundSource.asset => l10n.soundSubtitleAsset,
      AlertSoundSource.file => l10n.soundSubtitleFile,
      AlertSoundSource.silent => l10n.soundSubtitleSilent,
    };
  }

  bool _sameSound(AlertSoundRef left, AlertSoundRef right) {
    return left.source == right.source && left.uri == right.uri;
  }
}
