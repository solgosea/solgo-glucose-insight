import '../../../../domain/entities/glucose_event.dart';
import '../../../../domain/entities/glucose_reading.dart';
import '../../domain/history_curve_dataset.dart';

class HistoryCurveDatasetCalculator {
  const HistoryCurveDatasetCalculator();

  HistoryCurveDataset calculate({
    required DateTime selectedDay,
    required DateTime rangeStart,
    required DateTime rangeEnd,
    required List<GlucoseReading> readings,
    required List<GlucoseEvent> events,
  }) {
    return HistoryCurveDataset(
      selectedDay: selectedDay,
      rangeStart: rangeStart,
      rangeEnd: rangeEnd,
      readings: readings,
      events: events,
    );
  }
}
