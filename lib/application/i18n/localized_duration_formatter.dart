import '../../l10n/generated/app_localizations.dart';

class LocalizedDurationFormatter {
  final AppLocalizations l10n;

  const LocalizedDurationFormatter(this.l10n);

  String short(Duration duration) {
    if (duration.inMinutes < 1) {
      return l10n.durationSecondsShort(duration.inSeconds.clamp(0, 59));
    }
    if (duration.inMinutes < 60) {
      return l10n.durationMinutesShort(duration.inMinutes);
    }
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    if (minutes == 0) return l10n.durationHoursShort(hours);
    return l10n.durationHoursMinutesShort(hours, minutes);
  }
}
