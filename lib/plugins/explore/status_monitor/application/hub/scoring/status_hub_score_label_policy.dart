import '../../../domain/hub/path/status_hub_path_score_grade.dart';

class StatusHubScoreLabelPolicy {
  const StatusHubScoreLabelPolicy();

  StatusHubPathScoreGrade gradeFor(double score) {
    final clamped = score.clamp(0, 100);
    if (clamped >= 85) return StatusHubPathScoreGrade.good;
    if (clamped >= 65) return StatusHubPathScoreGrade.watch;
    if (clamped >= 40) return StatusHubPathScoreGrade.degraded;
    if (clamped > 0) return StatusHubPathScoreGrade.issue;
    return StatusHubPathScoreGrade.unknown;
  }

  String labelFor(double score) {
    final grade = gradeFor(score);
    return switch (grade) {
      StatusHubPathScoreGrade.good => score.round().toString(),
      StatusHubPathScoreGrade.watch => score.round().toString(),
      StatusHubPathScoreGrade.degraded => score.round().toString(),
      StatusHubPathScoreGrade.issue => score.round().toString(),
      StatusHubPathScoreGrade.unknown => '--',
    };
  }
}
