import 'package:smart_xdrip/domain/entities/glucose_reading.dart';
import 'package:smart_xdrip/domain/sources/i_glucose_source.dart';
import 'package:smart_xdrip/domain/subject/glucose_subject.dart';

class GlucoseSyncResult {
  final DataSource source;
  final String subjectId;
  final bool success;
  final bool available;
  final int fetchedCount;
  final int storedCount;
  final DateTime? cursor;
  final String? error;
  final List<GlucoseReading> readings;

  const GlucoseSyncResult({
    required this.source,
    this.subjectId = GlucoseSubject.selfId,
    required this.success,
    required this.available,
    required this.fetchedCount,
    required this.storedCount,
    required this.cursor,
    required this.error,
    required this.readings,
  });

  Set<String> get updatedSubjectIds =>
      success && storedCount > 0 ? {subjectId} : const {};

  factory GlucoseSyncResult.unavailable({
    required DataSource source,
    String subjectId = GlucoseSubject.selfId,
    String error = 'source_unavailable',
  }) {
    return GlucoseSyncResult(
      source: source,
      subjectId: subjectId,
      success: false,
      available: false,
      fetchedCount: 0,
      storedCount: 0,
      cursor: null,
      error: error,
      readings: const [],
    );
  }

  factory GlucoseSyncResult.failure({
    required DataSource source,
    String subjectId = GlucoseSubject.selfId,
    required String error,
  }) {
    return GlucoseSyncResult(
      source: source,
      subjectId: subjectId,
      success: false,
      available: true,
      fetchedCount: 0,
      storedCount: 0,
      cursor: null,
      error: error,
      readings: const [],
    );
  }
}
