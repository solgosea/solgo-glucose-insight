import 'package:smart_xdrip/application/analysis/analysis_facade.dart';

import '../models/profile_analysis_result.dart';

class ProfileSummaryAnalyzer {
  const ProfileSummaryAnalyzer();

  ProfileAnalysisResult analyze({
    required AnalysisFacade facade,
    DateTime? now,
  }) {
    final current = now ?? DateTime.now();
    final readings14d = facade.readingsForLastDays(14, now: current);
    final tir = facade.tirForReadings(readings14d);
    final latest = facade.latestReading;
    final lastReceivedMinutesAgo = latest == null
        ? null
        : current.difference(latest.timestamp).inMinutes.clamp(0, 1 << 31);

    return ProfileAnalysisResult(
      tir14d: facade.averageTirForLastDays(14, now: current) ?? tir.tir,
      average14d: facade.averageMeanForLastDays(14, now: current) ?? tir.mean,
      cv14d: facade.averageCvForLastDays(14, now: current) ?? tir.cv,
      latestReadingAt: latest?.timestamp,
      lastReceivedMinutesAgo: lastReceivedMinutesAgo,
    );
  }
}
