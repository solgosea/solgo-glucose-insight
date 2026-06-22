import '../../domain/status_level.dart';

class UnknownMetricPolicy {
  const UnknownMetricPolicy();

  bool affectsComponentLevel(StatusLevel level) {
    return level != StatusLevel.unknown;
  }
}
