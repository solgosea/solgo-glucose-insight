import 'package:flutter_test/flutter_test.dart';
import 'package:smart_xdrip/application/plugin_text/plugin_text_render_context.dart';
import 'package:smart_xdrip/plugins/history/application/text/history_text_renderer.dart';

void main() {
  test('history text renderer renders episode callout from structured facts',
      () {
    const renderer = HistoryTextRenderer();

    final text = renderer.render(HistoryTextTemplate.episodeCallout, {
      'time': '03:20',
      'value': '3.1 mmol/L',
      'durationMinutes': 23,
      'extraText': 'Nocturnal low, rate -0.18 mmol/L/min',
    });

    expect(text, contains('03:20'));
    expect(text, contains('3.1 mmol/L'));
    expect(text, contains('23 min'));
    expect(text, contains('Nocturnal low'));
  });

  test('history text renderer renders high event detail variants', () {
    const renderer = HistoryTextRenderer();

    final text = renderer.render(HistoryTextTemplate.highEventDetail, {
      'rate': '+0.10 mmol/L/min',
      'durationMinutes': 38,
      'highThreshold': '10.0',
    });

    expect(text, '+0.10 mmol/L/min - 38 min above 10.0');
  });

  test('history text renderer prefers Chinese templates by locale', () {
    const renderer = HistoryTextRenderer();
    const context = PluginTextRenderContext(locale: 'zh');

    final callout = renderer.render(
      HistoryTextTemplate.episodeCallout,
      {
        'time': '03:20',
        'value': '3.1 mmol/L',
        'durationMinutes': 23,
        'extraText': '夜间低血糖',
      },
      context: context,
    );
    final detail = renderer.render(
      HistoryTextTemplate.highEventDetail,
      {
        'rate': '+0.10 mmol/L/min',
        'durationMinutes': 38,
        'highThreshold': '10.0',
      },
      context: context,
    );
    final value = renderer.render(
      HistoryTextTemplate.highValueSuffix,
      {'value': '12.1 mmol/L'},
      context: context,
    );

    expect(callout, '03:20 - 3.1 mmol/L，持续 23 分钟。夜间低血糖');
    expect(detail, '+0.10 mmol/L/min - 高于 10.0 持续 38 分钟');
    expect(value, '12.1 mmol/L - 峰值');
  });
}
