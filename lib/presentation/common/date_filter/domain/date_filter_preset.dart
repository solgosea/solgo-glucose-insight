import 'date_filter_selection.dart';

class DateFilterPreset {
  final String id;
  final String label;
  final DateFilterSelection Function(DateTime now) resolve;

  const DateFilterPreset({
    required this.id,
    required this.label,
    required this.resolve,
  });
}
