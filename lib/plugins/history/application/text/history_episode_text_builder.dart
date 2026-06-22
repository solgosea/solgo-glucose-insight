import 'package:smart_xdrip/application/plugin_text/plugin_text_render_context.dart';

import '../../../../application/glucose_unit/glucose_unit_format_service.dart';
import '../../../../domain/entities/app_settings.dart';
import '../../../../domain/entities/glucose_event.dart';
import '../i18n/history_l10n_resolver.dart';
import '../../l10n/generated/history_localizations.dart';
import 'history_text_renderer.dart';

class HistoryEpisodeTextBuilder {
  final HistoryTextRenderer renderer;
  final GlucoseUnitFormatService glucoseFormatter;

  const HistoryEpisodeTextBuilder({
    this.renderer = const HistoryTextRenderer(),
    this.glucoseFormatter = const GlucoseUnitFormatService(),
  });

  String calloutSummary(
    GlucoseEvent event,
    AppSettings settings, {
    HistoryLocalizations? l10n,
  }) {
    final strings = l10n ?? HistoryL10nResolver.fallback;
    final context = PluginTextRenderContext(locale: strings.localeName);
    final isHigh = event.type == GlucoseEventType.highEpisode;
    final value = glucoseFormatter
        .value(event.peakOrNadir ?? event.value, settings.unit)
        .fullLabel;
    final extras = <String>[];
    if (event.isNocturnal && !isHigh) extras.add(strings.eventNocturnalLow);
    final rate = event.ratePerMin;
    if (rate != null && rate.abs() > 0.05) {
      extras.add(
        strings.eventRatePrefix(
          glucoseFormatter.rate(rate, settings.unit).fullLabel,
        ),
      );
    }
    final template = extras.isEmpty
        ? HistoryTextTemplate.episodeCalloutNoExtra
        : HistoryTextTemplate.episodeCallout;
    return renderer.render(
        template,
        {
          'time': _hm(event.time),
          'value': value,
          'durationMinutes': event.durationMinutes,
          'extraText': extras.join(', '),
        },
        context: context);
  }

  String _hm(DateTime time) =>
      '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
}
