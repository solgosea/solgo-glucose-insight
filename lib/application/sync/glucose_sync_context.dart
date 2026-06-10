import 'package:smart_xdrip/data/local/glucose_database.dart';
import 'package:smart_xdrip/domain/entities/app_settings.dart';
import 'package:smart_xdrip/domain/entities/glucose_reading.dart';
import 'package:smart_xdrip/domain/entities/source_sync_state.dart';
import 'package:smart_xdrip/domain/glucose_etl/glucose_etl_result.dart';
import 'package:smart_xdrip/domain/sources/i_glucose_source.dart';
import 'package:smart_xdrip/domain/subject/glucose_subject.dart';

import 'glucose_sync_plan.dart';
import 'glucose_sync_policy.dart';
import 'glucose_sync_result.dart';

class GlucoseSyncContext {
  final GlucoseDatabase database;
  final IGlucoseSource source;
  final AppSettings settings;
  final String subjectId;
  final GlucoseSyncPolicy policy;

  SourceSyncState? sourceState;
  GlucoseSyncPlan? plan;
  List<GlucoseReading> readings = const [];
  GlucoseEtlResult? etlResult;
  GlucoseSyncResult? result;

  GlucoseSyncContext({
    required this.database,
    required this.source,
    required this.settings,
    this.subjectId = GlucoseSubject.selfId,
  }) : policy = GlucoseSyncPolicy.fromSettings(
         initialSyncDays: settings.initialSyncDays,
       );

  String get sourceKey => source.type.name;
  bool get stopped => result != null;

  void stopWith(GlucoseSyncResult value) {
    result = value;
  }
}
