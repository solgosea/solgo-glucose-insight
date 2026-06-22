import '../status_level.dart';

class StatusSignalSummary {
  final String id;
  final String label;
  final String valueLabel;
  final StatusLevel level;
  final String? note;

  const StatusSignalSummary({
    required this.id,
    required this.label,
    required this.valueLabel,
    required this.level,
    this.note,
  });

  Map<String, Object?> toJson() => {
        'id': id,
        'label': label,
        'valueLabel': valueLabel,
        'level': level.name,
        'note': note,
      };
}
