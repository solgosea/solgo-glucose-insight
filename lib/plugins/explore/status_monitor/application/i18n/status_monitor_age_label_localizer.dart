import '../../l10n/generated/status_monitor_localizations.dart';

class StatusMonitorAgeLabelLocalizer {
  const StatusMonitorAgeLabelLocalizer();

  String localize(
    String value,
    StatusMonitorLocalizations l10n, {
    String? fallback,
  }) {
    final parsed = parse(value);
    if (parsed == null) return fallback ?? value;
    final (amount, unit) = parsed;
    return switch (unit) {
      's' => l10n.pageJustNow,
      'm' => l10n.pageMinutesAgoShort(amount),
      'h' => l10n.pageHoursAgoShort(amount),
      'd' => l10n.pageDaysAgoShort(amount),
      _ => fallback ?? value,
    };
  }

  int? minutes(String value) {
    final parsed = parse(value);
    if (parsed == null) return null;
    final (amount, unit) = parsed;
    return switch (unit) {
      's' => 0,
      'm' => amount,
      'h' => amount * 60,
      'd' => amount * 1440,
      _ => null,
    };
  }

  (int, String)? parse(String value) {
    final normalized = value.trim().toLowerCase();
    final match = RegExp(r'^(\d+)\s*([smhd])$').firstMatch(normalized);
    if (match == null) return null;
    final amount = int.tryParse(match.group(1) ?? '');
    final unit = match.group(2);
    if (amount == null || unit == null) return null;
    return (amount, unit);
  }
}
