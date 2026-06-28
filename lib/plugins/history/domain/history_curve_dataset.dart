import '../../../domain/entities/glucose_event.dart';
import '../../../domain/entities/glucose_reading.dart';

class HistoryCurveDataset {
  final DateTime selectedDay;
  final DateTime rangeStart;
  final DateTime rangeEnd;
  final List<GlucoseReading> readings;
  final List<GlucoseEvent> events;

  const HistoryCurveDataset({
    required this.selectedDay,
    required this.rangeStart,
    required this.rangeEnd,
    required this.readings,
    required this.events,
  });
}
