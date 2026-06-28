import 'package:flutter_test/flutter_test.dart';
import 'package:smart_xdrip/application/analysis/analysis_facade.dart';
import 'package:smart_xdrip/domain/entities/app_settings.dart';
import 'package:smart_xdrip/plugins/profile/analyzers/profile_summary_analyzer.dart';
import 'package:smart_xdrip/plugins/profile/l10n/generated/profile_localizations_en.dart';
import 'package:smart_xdrip/plugins/profile/l10n/generated/profile_localizations_zh.dart';
import 'package:smart_xdrip/plugins/profile/mappers/profile_view_model_mapper.dart';
import 'package:smart_xdrip/plugins/profile/models/profile_analysis_result.dart';

void main() {
  test('maps profile labels with simplified Chinese localization', () {
    final viewModel = ProfileViewModelMapper(
      analyzer: _FakeProfileSummaryAnalyzer(),
    ).map(
      facade: AnalysisFacade.current(),
      settings: const AppSettings(unit: GlucoseUnit.mmolL),
      l10n: ProfileLocalizationsZh(),
    );

    expect(viewModel.header.title, isNotEmpty);
    expect(viewModel.header.primaryBadge, isNotEmpty);
    expect(viewModel.stats, hasLength(3));
  });

  test('maps profile labels with English localization', () {
    final viewModel = ProfileViewModelMapper(
      analyzer: _FakeProfileSummaryAnalyzer(),
    ).map(
      facade: AnalysisFacade.current(),
      settings: const AppSettings(unit: GlucoseUnit.mmolL),
      l10n: ProfileLocalizationsEn(),
    );

    expect(viewModel.header.title, 'My Profile');
    expect(viewModel.header.primaryBadge, '14 days recorded');
    expect(viewModel.stats.map((stat) => stat.label), [
      'TIR 14d',
      'Avg 14d',
      'CV 14d',
    ]);
  });
}

class _FakeProfileSummaryAnalyzer extends ProfileSummaryAnalyzer {
  @override
  ProfileAnalysisResult analyze({
    required AnalysisFacade facade,
    DateTime? now,
  }) {
    return ProfileAnalysisResult(
      tir14d: 82,
      average14d: 6.4,
      cv14d: 24,
      latestReadingAt: DateTime(2026, 6, 6, 12),
      lastReceivedMinutesAgo: 5,
    );
  }
}
