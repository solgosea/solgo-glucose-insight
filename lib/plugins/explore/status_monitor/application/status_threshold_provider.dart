import '../domain/status_level.dart';
import '../domain/status_threshold.dart';

class StatusThresholdProvider {
  const StatusThresholdProvider();

  StatusThresholdResult sensorLifetime(Duration? remaining) {
    const threshold = StatusThreshold(
      healthyLabel: 'healthy >2d',
      watchLabel: 'watch 1-2d',
      issueLabel: 'issue <1d',
    );
    if (remaining == null) {
      return const StatusThresholdResult(
        level: StatusLevel.unknown,
        threshold: threshold,
      );
    }
    if (remaining.inHours > 48) {
      return const StatusThresholdResult(
        level: StatusLevel.healthy,
        threshold: threshold,
      );
    }
    if (remaining.inHours >= 24) {
      return const StatusThresholdResult(
        level: StatusLevel.watch,
        threshold: threshold,
      );
    }
    return const StatusThresholdResult(
      level: StatusLevel.issue,
      threshold: threshold,
    );
  }

  StatusThresholdResult cgmCv(double cv) {
    const threshold = StatusThreshold(
      healthyLabel: 'healthy <36%',
      watchLabel: 'watch 36-50%',
      issueLabel: 'issue >50%',
    );
    return StatusThresholdResult(
      level: cv < 36
          ? StatusLevel.healthy
          : cv <= 50
              ? StatusLevel.watch
              : StatusLevel.issue,
      threshold: threshold,
    );
  }

  StatusThresholdResult suddenChanges(int count) {
    const threshold = StatusThreshold(
      healthyLabel: 'healthy 0',
      watchLabel: 'watch 1-2',
      issueLabel: 'issue >=3',
    );
    return StatusThresholdResult(
      level: count == 0
          ? StatusLevel.healthy
          : count <= 2
              ? StatusLevel.watch
              : StatusLevel.issue,
      threshold: threshold,
    );
  }

  StatusThresholdResult flatLine(Duration longest) {
    const threshold = StatusThreshold(
      healthyLabel: 'healthy none',
      watchLabel: 'watch one >=30m',
      issueLabel: 'issue multiple/current',
    );
    return StatusThresholdResult(
      level: longest.inMinutes >= 30 ? StatusLevel.watch : StatusLevel.healthy,
      threshold: threshold,
    );
  }

  StatusThresholdResult freshness(Duration age) {
    const threshold = StatusThreshold(
      healthyLabel: 'healthy <7m',
      watchLabel: 'watch 7-15m',
      issueLabel: 'issue >15m',
    );
    return StatusThresholdResult(
      level: age.inMinutes < 7
          ? StatusLevel.healthy
          : age.inMinutes <= 15
              ? StatusLevel.watch
              : StatusLevel.issue,
      threshold: threshold,
    );
  }

  StatusThresholdResult completeness(double ratio) {
    const threshold = StatusThreshold(
      healthyLabel: 'healthy >95%',
      watchLabel: 'watch 85-95%',
      issueLabel: 'issue <85%',
    );
    return StatusThresholdResult(
      level: ratio > .95
          ? StatusLevel.healthy
          : ratio >= .85
              ? StatusLevel.watch
              : StatusLevel.issue,
      threshold: threshold,
    );
  }

  StatusThresholdResult uploadLatency(Duration latency) {
    const threshold = StatusThreshold(
      healthyLabel: 'healthy <15s',
      watchLabel: 'watch 15-30s',
      issueLabel: 'issue >30s',
    );
    return StatusThresholdResult(
      level: latency.inSeconds < 15
          ? StatusLevel.healthy
          : latency.inSeconds <= 30
              ? StatusLevel.watch
              : StatusLevel.issue,
      threshold: threshold,
    );
  }

  StatusThresholdResult battery(int percent) {
    const threshold = StatusThreshold(
      healthyLabel: 'healthy >30%',
      watchLabel: 'watch 15-30%',
      issueLabel: 'issue <15%',
    );
    return StatusThresholdResult(
      level: percent > 30
          ? StatusLevel.healthy
          : percent >= 15
              ? StatusLevel.watch
              : StatusLevel.issue,
      threshold: threshold,
    );
  }

  StatusThresholdResult apiReachable(bool reachable, {bool slow = false}) {
    const threshold = StatusThreshold(
      healthyLabel: 'healthy 200 OK',
      watchLabel: 'watch slow >3s',
      issueLabel: 'issue timeout/5xx',
    );
    return StatusThresholdResult(
      level: !reachable
          ? StatusLevel.issue
          : slow
              ? StatusLevel.watch
              : StatusLevel.healthy,
      threshold: threshold,
    );
  }

  StatusThresholdResult responseTime(Duration duration) {
    const threshold = StatusThreshold(
      healthyLabel: 'healthy <500ms',
      watchLabel: 'watch 500ms-3s',
      issueLabel: 'issue >3s',
    );
    return StatusThresholdResult(
      level: duration.inMilliseconds < 500
          ? StatusLevel.healthy
          : duration.inSeconds <= 3
              ? StatusLevel.watch
              : StatusLevel.issue,
      threshold: threshold,
    );
  }
}
