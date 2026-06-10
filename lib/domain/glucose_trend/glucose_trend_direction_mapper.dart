import 'glucose_trend_direction.dart';

class GlucoseTrendDirectionMapper {
  const GlucoseTrendDirectionMapper();

  GlucoseTrendDirection map(String? rawDirection) {
    final raw = rawDirection?.trim().toLowerCase();
    return switch (raw) {
      'doubleup' || 'double_up' || 'upup' => GlucoseTrendDirection.doubleUp,
      'singleup' || 'single_up' || 'up' => GlucoseTrendDirection.singleUp,
      'fortyfiveup' ||
      'forty_five_up' ||
      '45up' => GlucoseTrendDirection.fortyFiveUp,
      'flat' || 'steady' => GlucoseTrendDirection.flat,
      'fortyfivedown' ||
      'forty_five_down' ||
      '45down' => GlucoseTrendDirection.fortyFiveDown,
      'singledown' ||
      'single_down' ||
      'down' => GlucoseTrendDirection.singleDown,
      'doubledown' ||
      'double_down' ||
      'downdown' => GlucoseTrendDirection.doubleDown,
      _ => GlucoseTrendDirection.unknown,
    };
  }

  double? fallbackRatePerMin(String? rawDirection) {
    return switch (map(rawDirection)) {
      GlucoseTrendDirection.doubleUp => 0.16,
      GlucoseTrendDirection.singleUp => 0.10,
      GlucoseTrendDirection.fortyFiveUp => 0.06,
      GlucoseTrendDirection.flat => 0.0,
      GlucoseTrendDirection.fortyFiveDown => -0.06,
      GlucoseTrendDirection.singleDown => -0.10,
      GlucoseTrendDirection.doubleDown => -0.16,
      GlucoseTrendDirection.unknown => null,
    };
  }
}
