import 'package:intl/intl.dart';

import '../../domain/history_time_filter.dart';
import '../../l10n/generated/history_localizations.dart';

class HistoryFilterTextBuilder {
  const HistoryFilterTextBuilder();

  String? label(HistoryTimeFilter? filter, HistoryLocalizations l10n) {
    if (filter == null) return null;
    return l10n.filterFocusedAround(DateFormat('HH:mm').format(filter.time));
  }
}
