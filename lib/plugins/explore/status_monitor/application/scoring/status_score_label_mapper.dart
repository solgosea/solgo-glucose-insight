import '../../domain/status_level.dart';

class StatusScoreLabelMapper {
  const StatusScoreLabelMapper();

  String labelFor(int? score) {
    if (score == null) return 'Limited data';
    if (score >= 85) return 'Stable checks';
    if (score >= 70) return 'Worth watching';
    if (score >= 50) return 'Needs a glance';
    return 'Limited checks';
  }

  StatusLevel levelFor(int? score) {
    if (score == null) return StatusLevel.unknown;
    if (score >= 85) return StatusLevel.healthy;
    if (score >= 50) return StatusLevel.watch;
    return StatusLevel.issue;
  }
}
