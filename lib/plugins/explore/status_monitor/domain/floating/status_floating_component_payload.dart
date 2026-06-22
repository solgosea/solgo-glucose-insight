import '../status_level.dart';

class StatusFloatingComponentPayload {
  final String label;
  final StatusLevel level;
  final String glyph;
  final int? score;
  final String scoreLabel;

  const StatusFloatingComponentPayload({
    required this.label,
    required this.level,
    required this.glyph,
    required this.score,
    required this.scoreLabel,
  });

  Map<String, Object?> toMap() => {
        'label': label,
        'level': level.name,
        'glyph': glyph,
        'score': score,
        'scoreLabel': scoreLabel,
      };
}
