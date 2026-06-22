import '../status_level.dart';

class CgmSuddenJumpEvent {
  final DateTime at;
  final double deltaMmol;
  final StatusLevel level;

  const CgmSuddenJumpEvent({
    required this.at,
    required this.deltaMmol,
    required this.level,
  });

  Map<String, Object?> toJson() => {
        'atMs': at.millisecondsSinceEpoch,
        'deltaMmol': deltaMmol,
        'level': level.name,
      };
}
