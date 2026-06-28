import '../../../domain/hub/status_hub_enums.dart';
import '../scoring/status_hub_metric_star_policy.dart';
import 'status_hub_metric_thresholds.dart';

class StatusHubMetricQuantification {
  final double score;
  final int stars;
  final StatusHubState state;

  const StatusHubMetricQuantification({
    required this.score,
    required this.stars,
    required this.state,
  });
}

class StatusHubMetricNormalizer {
  final StatusHubMetricStarPolicy starPolicy;

  const StatusHubMetricNormalizer({
    this.starPolicy = const StatusHubMetricStarPolicy(),
  });

  StatusHubMetricQuantification unknown() => _quantify(0);

  StatusHubMetricQuantification age(Duration? age) {
    if (age == null) return unknown();
    final score = _durationScore(
      age.abs(),
      excellent: StatusHubMetricThresholds.freshAgeExcellent,
      good: StatusHubMetricThresholds.freshAgeGood,
      watch: StatusHubMetricThresholds.freshAgeWatch,
      degraded: StatusHubMetricThresholds.freshAgeDegraded,
    );
    return _quantify(score);
  }

  StatusHubMetricQuantification delay(Duration? delay) {
    if (delay == null) return unknown();
    if (delay.isNegative) return _quantify(82);
    final score = _durationScore(
      delay.abs(),
      excellent: StatusHubMetricThresholds.delayExcellent,
      good: StatusHubMetricThresholds.delayGood,
      watch: StatusHubMetricThresholds.delayWatch,
      degraded: StatusHubMetricThresholds.delayDegraded,
    );
    return _quantify(score);
  }

  StatusHubMetricQuantification responseMs(int? value) {
    if (value == null) return unknown();
    final score = value <= StatusHubMetricThresholds.responseExcellentMs
        ? 100.0
        : value <= StatusHubMetricThresholds.responseGoodMs
            ? 82.0
            : value <= StatusHubMetricThresholds.responseWatchMs
                ? 52.0
                : 18.0;
    return _quantify(score);
  }

  StatusHubMetricQuantification boolean(
    bool observed, {
    bool partial = false,
  }) {
    if (observed) return _quantify(100);
    if (partial) return _quantify(52);
    return _quantify(0);
  }

  StatusHubMetricQuantification ratio(int available, int expected) {
    if (expected <= 0) return unknown();
    final score = (available / expected * 100).clamp(0, 100).toDouble();
    return _quantify(score);
  }

  double _durationScore(
    Duration value, {
    required Duration excellent,
    required Duration good,
    required Duration watch,
    required Duration degraded,
  }) {
    if (value <= excellent) return 100;
    if (value <= good) return 82;
    if (value <= watch) return 62;
    if (value <= degraded) return 42;
    return 18;
  }

  StatusHubMetricQuantification _quantify(double score) {
    final clamped = score.clamp(0, 100).toDouble();
    return StatusHubMetricQuantification(
      score: clamped,
      stars: starPolicy.starsFor(clamped),
      state: starPolicy.stateFor(clamped),
    );
  }
}
