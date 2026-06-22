import '../../../domain/status_level.dart';

class XdripScoreLabelMapper {
  const XdripScoreLabelMapper();

  String labelFor(int? score) {
    if (score == null) return 'Limited data';
    if (score >= 85) return 'Fresh data link';
    if (score >= 70) return 'Mostly fresh';
    if (score >= 50) return 'Delayed link';
    return 'Weak data link';
  }

  StatusLevel levelFor(int? score) {
    if (score == null) return StatusLevel.unknown;
    if (score >= 85) return StatusLevel.healthy;
    if (score >= 50) return StatusLevel.watch;
    return StatusLevel.issue;
  }
}
