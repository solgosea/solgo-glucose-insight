import '../../../domain/status_level.dart';

class AapsScoreLabelMapper {
  const AapsScoreLabelMapper();

  String labelFor(int? score) {
    if (score == null) return 'Loop context unknown';
    if (score >= 85) return 'Loop context visible';
    if (score >= 70) return 'Loop context watch';
    if (score >= 50) return 'Loop context partial';
    return 'Loop context weak';
  }

  StatusLevel levelFor(int? score) {
    if (score == null) return StatusLevel.unknown;
    if (score >= 85) return StatusLevel.healthy;
    if (score >= 50) return StatusLevel.watch;
    return StatusLevel.issue;
  }
}
