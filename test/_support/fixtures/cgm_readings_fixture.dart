import 'package:smart_xdrip/domain/entities/glucose_event.dart';
import 'package:smart_xdrip/domain/entities/glucose_reading.dart';

class CgmReadingsFixture {
  const CgmReadingsFixture._();

  static DateTime get anchor => DateTime(2026, 6, 4, 12);

  static List<GlucoseReading> stableDay({
    DateTime? start,
    int count = 288,
    double value = 6.4,
  }) {
    final base = start ?? DateTime(2026, 6, 4);
    return List.generate(
      count,
      (index) => GlucoseReading(
        timestamp: base.add(Duration(minutes: index * 5)),
        value: value + (index % 12 - 6) * 0.02,
        ratePerMin: index == 0 ? null : 0.01,
      ),
    );
  }

  static List<GlucoseReading> dayWithHighAndLow({DateTime? start}) {
    final rows = stableDay(start: start);
    final output = <GlucoseReading>[];
    for (var i = 0; i < rows.length; i++) {
      final hour = rows[i].timestamp.hour;
      var value = rows[i].value;
      if (hour == 3) {
        value = 3.1 + (i % 4) * 0.05;
      } else if (hour == 9) {
        value = 10.8 + (i % 5) * 0.08;
      } else if (hour == 10) {
        value = 9.4 - (i % 6) * 0.08;
      }
      output.add(
        GlucoseReading(
          timestamp: rows[i].timestamp,
          value: value,
          ratePerMin: rows[i].ratePerMin,
        ),
      );
    }
    return output;
  }

  static List<Map<String, Object?>> nightscoutEntries(
    List<GlucoseReading> readings,
  ) {
    return readings
        .map(
          (reading) => {
            'date': reading.timestamp.millisecondsSinceEpoch,
            'sgv': (reading.value * 18).round(),
            'direction': 'Flat',
          },
        )
        .toList();
  }

  static GlucoseEvent highEpisode() {
    return GlucoseEvent(
      type: GlucoseEventType.highEpisode,
      time: DateTime(2026, 6, 4, 9, 10),
      endTime: DateTime(2026, 6, 4, 9, 45),
      value: 10.4,
      peakOrNadir: 11.2,
      ratePerMin: 0.12,
      areaOutOfRange: 22.5,
    );
  }

  static GlucoseEvent lowEpisode() {
    return GlucoseEvent(
      type: GlucoseEventType.lowEpisode,
      time: DateTime(2026, 6, 4, 3, 15),
      endTime: DateTime(2026, 6, 4, 3, 45),
      value: 3.5,
      peakOrNadir: 3.1,
      ratePerMin: -0.08,
      isNocturnal: true,
      areaOutOfRange: 12.0,
    );
  }
}
