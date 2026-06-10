import 'package:smart_xdrip/domain/entities/glucose_reading.dart';

class SourceRecordIdentityPolicy {
  const SourceRecordIdentityPolicy();

  String sourceRecordId({
    required String source,
    required GlucoseReading reading,
  }) {
    final ts = reading.timestamp.millisecondsSinceEpoch;
    final value = reading.value.toStringAsFixed(3);
    final rate = reading.ratePerMin?.toStringAsFixed(4) ?? 'na';
    return '$source:$ts:$value:$rate';
  }

  String rawId({required String source, required String sourceRecordId}) {
    return '$source:$sourceRecordId';
  }
}
