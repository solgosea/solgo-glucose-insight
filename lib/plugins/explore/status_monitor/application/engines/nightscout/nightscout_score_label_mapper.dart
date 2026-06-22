import '../../../domain/status_level.dart';

class NightscoutScoreLabelMapper {
  const NightscoutScoreLabelMapper();

  String labelFor(int? score) {
    if (score == null) return 'Limited cloud data';
    if (score >= 85) return 'Cloud link healthy';
    if (score >= 70) return 'Cloud link watch';
    if (score >= 50) return 'Cloud link delayed';
    return 'Cloud link weak';
  }

  StatusLevel levelFor(int? score) {
    if (score == null) return StatusLevel.unknown;
    if (score >= 85) return StatusLevel.healthy;
    if (score >= 50) return StatusLevel.watch;
    return StatusLevel.issue;
  }
}
