import '../../../application/subject/active_subject_service.dart';
import '../../../data/local/glucose_database.dart';
import '../../../domain/entities/app_settings.dart';
import '../domain/glance_snapshot.dart';
import '../domain/widget_graph_range.dart';
import 'glance_snapshot_builder.dart';

class GlanceSnapshotService {
  final GlucoseDatabase database;
  final ActiveSubjectService activeSubjectService;
  final AppSettings Function() settingsProvider;
  final GlanceSnapshotBuilder builder;
  final DateTime Function() now;

  const GlanceSnapshotService({
    required this.database,
    required this.activeSubjectService,
    required this.settingsProvider,
    this.builder = const GlanceSnapshotBuilder(),
    DateTime Function()? now,
  }) : now = now ?? DateTime.now;

  Future<GlanceSnapshot> current({
    GlanceWidgetGraphRange range = GlanceWidgetGraphRange.fourHours,
    GlucoseUnit? unit,
  }) async {
    final subjectId = activeSubjectService.current.id;
    final currentNow = now();
    final from = currentNow.subtract(Duration(hours: range.hours));
    final tirFrom = currentNow.subtract(const Duration(hours: 24));
    final readings = await database.readings.range(
      from,
      currentNow.add(const Duration(minutes: 1)),
      subjectId: subjectId,
    );
    final tirReadings = range == GlanceWidgetGraphRange.twentyFourHours
        ? readings
        : await database.readings.range(
            tirFrom,
            currentNow.add(const Duration(minutes: 1)),
            subjectId: subjectId,
          );
    final latest = readings.isNotEmpty
        ? readings.last
        : await database.latest(subjectId: subjectId);
    return builder.build(
      subjectId: subjectId,
      settings: settingsProvider().copyWith(unit: unit),
      latest: latest,
      trendReadings: readings,
      tirReadings24h: tirReadings,
      now: currentNow,
      sourceLabel: _sourceLabel(settingsProvider()),
    );
  }

  String _sourceLabel(AppSettings settings) {
    if (settings.xdripSyncEnabled) return 'xDrip+ Local';
    if (settings.nightscoutSyncEnabled) return 'Nightscout API';
    return 'SolgoInsight';
  }
}
