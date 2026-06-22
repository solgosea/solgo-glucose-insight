import 'dart:ui';

import 'package:smart_xdrip/application/analysis/analysis_facade.dart';
import 'package:smart_xdrip/reporting/domain/report_context.dart';
import 'package:smart_xdrip/reporting/domain/report_date_range.dart';
import 'package:smart_xdrip/reporting/domain/report_format.dart';
import 'package:smart_xdrip/reporting/domain/report_privacy_level.dart';
import 'package:smart_xdrip/reporting/domain/report_provider.dart';
import 'package:smart_xdrip/reporting/domain/report_snapshot.dart';

import '../../application/episode_detail_service.dart';
import '../../application/i18n/episode_detail_l10n_resolver.dart';
import '../../domain/episode_detail_entry_intent.dart';
import 'low_episode_report_adapter.dart';

class LowEpisodeReportProvider implements ReportProvider {
  final EpisodeDetailEntryIntent intent;
  final EpisodeDetailService service;
  final LowEpisodeReportAdapter adapter;
  final AnalysisFacade Function() facadeProvider;

  const LowEpisodeReportProvider({
    required this.intent,
    required this.service,
    required this.facadeProvider,
    this.adapter = const LowEpisodeReportAdapter(),
  });

  @override
  String get id => 'episode_detail.low_episode.report';

  @override
  String get title => EpisodeDetailL10nResolver.fallback.lowEpisodeReportTitle;

  @override
  Set<ReportFormat> get supportedFormats => const {ReportFormat.pdf};

  @override
  ReportPrivacyLevel get defaultPrivacyLevel => ReportPrivacyLevel.standard;

  @override
  Future<ReportSnapshot> buildReport(ReportContext context) async {
    final output = service.load(intent: intent);
    return adapter.map(
      output,
      sourceLabel: context.sourceLabel,
      l10n: EpisodeDetailL10nResolver.resolve(context.locale),
    );
  }

  static ReportContext defaultContext({
    required EpisodeDetailEntryIntent intent,
    required AnalysisFacade facade,
  }) {
    final anchor = intent.focus?.eventTime ??
        intent.sourceDay ??
        facade.latestReading?.timestamp ??
        DateTime.now();
    return ReportContext(
      range: ReportDateRange(
        start: anchor.subtract(const Duration(days: 30)),
        end: anchor,
      ),
      unit: facade.settings.unit,
      privacyLevel: ReportPrivacyLevel.standard,
      locale: const Locale('en'),
      sourceLabel: facade.settings.xdripSyncEnabled
          ? 'xDrip+ Local'
          : facade.settings.nightscoutSyncEnabled
              ? 'Nightscout'
              : 'SolgoInsight',
    );
  }
}
