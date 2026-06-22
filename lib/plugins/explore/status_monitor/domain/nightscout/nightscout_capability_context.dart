import '../status_level.dart';

class NightscoutCapabilityContext {
  final String label;
  final String valueLabel;
  final StatusLevel level;
  final String? note;

  const NightscoutCapabilityContext({
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
