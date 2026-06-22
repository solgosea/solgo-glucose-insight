import '../status_level.dart';

class XdripContextSignal {
  final String label;
  final String valueLabel;
  final StatusLevel level;
  final String? note;

  const XdripContextSignal({
    required this.label,
    required this.valueLabel,
    required this.level,
    this.note,
  });

  Map<String, Object?> toJson() => {
        'label': label,
        'valueLabel': valueLabel,
        'level': level.name,
        'note': note,
      };
}
