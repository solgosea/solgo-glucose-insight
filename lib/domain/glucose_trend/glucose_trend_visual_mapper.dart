import 'glucose_trend_band.dart';
import 'glucose_trend_visual.dart';

class GlucoseTrendVisualMapper {
  const GlucoseTrendVisualMapper();

  GlucoseTrendVisual map(double? ratePerMin) {
    if (ratePerMin == null) {
      return const GlucoseTrendVisual(
        band: GlucoseTrendBand.unknown,
        arrow: '--',
        label: 'Trend unavailable',
      );
    }
    if (ratePerMin > 0.15) {
      return const GlucoseTrendVisual(
        band: GlucoseTrendBand.risingFast,
        arrow: '↑↑',
        label: 'Rising fast',
      );
    }
    if (ratePerMin > 0.06) {
      return const GlucoseTrendVisual(
        band: GlucoseTrendBand.rising,
        arrow: '↑',
        label: 'Rising',
      );
    }
    if (ratePerMin < -0.15) {
      return const GlucoseTrendVisual(
        band: GlucoseTrendBand.fallingFast,
        arrow: '↓↓',
        label: 'Falling fast',
      );
    }
    if (ratePerMin < -0.06) {
      return const GlucoseTrendVisual(
        band: GlucoseTrendBand.falling,
        arrow: '↓',
        label: 'Falling',
      );
    }
    return const GlucoseTrendVisual(
      band: GlucoseTrendBand.flat,
      arrow: '→',
      label: 'Flat',
    );
  }
}
