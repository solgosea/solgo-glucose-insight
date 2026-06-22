import 'status_level.dart';

class StatusThreshold {
  final String healthyLabel;
  final String watchLabel;
  final String issueLabel;

  const StatusThreshold({
    required this.healthyLabel,
    required this.watchLabel,
    required this.issueLabel,
  });

  String get compact => '$healthyLabel - $watchLabel - $issueLabel';
}

class StatusThresholdResult {
  final StatusLevel level;
  final StatusThreshold threshold;

  const StatusThresholdResult({
    required this.level,
    required this.threshold,
  });
}
