import '../status_level.dart';

class AapsEvidenceMatrixRow {
  final String title;
  final String copy;
  final String badge;
  final StatusLevel level;

  const AapsEvidenceMatrixRow({
    required this.title,
    required this.copy,
    required this.badge,
    required this.level,
  });

  Map<String, Object?> toJson() => {
        'title': title,
        'copy': copy,
        'badge': badge,
        'level': level.name,
      };
}
