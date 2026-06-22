import '../../../../application/analysis/analysis_facade.dart';
import '../../../../domain/entities/app_settings.dart';
import '../../../../domain/entities/glucose_reading.dart';
import '../engine/report_engine.dart';
import '../engine/report_engine_input.dart';
import '../engine/report_engine_output.dart';
import '../l10n/generated/report_localizations.dart';
import '../mappers/report_view_model_mapper.dart';
import '../models/report_period.dart';
import '../models/report_section.dart';
import '../models/report_view_model.dart';

class ReportService {
  final ReportEngine engine;
  final ReportViewModelMapper mapper;
  final DateTime Function() now;

  const ReportService({
    this.engine = const ReportEngine(),
    this.mapper = const ReportViewModelMapper(),
    DateTime Function()? now,
  }) : now = now ?? DateTime.now;

  ReportViewModel buildViewModel({
    required List<GlucoseReading> readings,
    required AppSettings settings,
    required ReportPeriod period,
    required List<ReportSectionToggle> sections,
    DateTime? generatedAt,
    ReportLocalizations? l10n,
  }) {
    final output = buildOutput(
      readings: readings,
      settings: settings,
      period: period,
      generatedAt: generatedAt,
    );
    return mapper.map(output: output, sections: sections, l10n: l10n);
  }

  ReportViewModel buildFromFacade({
    required AnalysisFacade facade,
    required ReportPeriod period,
    required List<ReportSectionToggle> sections,
    ReportLocalizations? l10n,
  }) {
    return buildViewModel(
      readings: facade.readingsForLastDays(period.days),
      settings: facade.settings,
      period: period,
      sections: sections,
      l10n: l10n,
    );
  }

  ReportEngineOutput buildOutput({
    required List<GlucoseReading> readings,
    required AppSettings settings,
    required ReportPeriod period,
    DateTime? generatedAt,
  }) {
    return engine.run(
      ReportEngineInput(
        readings: readings,
        settings: settings,
        period: period,
        generatedAt: generatedAt ?? now(),
      ),
    );
  }
}
