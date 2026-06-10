import 'package:smart_xdrip/domain/entities/glucose_reading.dart';
import 'package:smart_xdrip/domain/entities/app_settings.dart';
import 'package:smart_xdrip/domain/subject/analysis_subject.dart';
import 'package:smart_xdrip/presentation/common/sync_status/sync_status_view_model.dart';
import 'home_chart_range.dart';
import 'home_glucose_summary_view_model.dart';
import 'home_stat_card_view_model.dart';
import 'home_tir_view_model.dart';

class HomeViewModel {
  final SyncStatusViewModel syncStatus;
  final AnalysisSubject activeSubject;
  final HomeGlucoseSummaryViewModel glucose;
  final HomeChartRange selectedRange;
  final List<HomeChartRange> availableRanges;
  final List<GlucoseReading> chartReadings;
  final GlucoseUnit unit;
  final double lowThreshold;
  final double highThreshold;
  final List<HomeStatCardViewModel> stats;
  final HomeTirViewModel tir;
  final String insightText;

  const HomeViewModel({
    required this.syncStatus,
    required this.activeSubject,
    required this.glucose,
    required this.selectedRange,
    required this.availableRanges,
    required this.chartReadings,
    required this.unit,
    required this.lowThreshold,
    required this.highThreshold,
    required this.stats,
    required this.tir,
    required this.insightText,
  });
}
