import 'dart:math' as math;

import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:smart_xdrip/domain/entities/app_settings.dart';
import 'package:smart_xdrip/reporting/domain/report_section.dart';
import 'package:smart_xdrip/reporting/domain/report_snapshot.dart';
import 'package:smart_xdrip/reporting/rendering/pdf/report_pdf_document_shell.dart';
import 'package:smart_xdrip/reporting/rendering/pdf/report_pdf_renderer.dart';

import '../../../application/i18n/episode_detail_l10n_resolver.dart';
import '../../../application/episode_detail_formatters.dart';
import '../../low/low_episode_report_payloads.dart';
import 'low_episode_report_pdf_theme.dart';

class LowEpisodeReportPdfRenderer implements ReportPdfRenderer {
  final ReportPdfDocumentShell shell;

  const LowEpisodeReportPdfRenderer({
    this.shell = const ReportPdfDocumentShell(),
  });

  get _strings => EpisodeDetailL10nResolver.fallback;

  @override
  Future<List<int>> build(ReportSnapshot snapshot) async {
    final doc = shell.create(snapshot);
    doc.addPage(
      pw.MultiPage(
        pageTheme: shell.pageTheme(),
        footer: (_) => shell.footer(snapshot),
        build: (_) => [
          _status(snapshot),
          pw.SizedBox(height: 12),
          _hero(snapshot),
          pw.SizedBox(height: 10),
          _meta(snapshot),
          pw.SizedBox(height: 12),
          for (final section in snapshot.sections) ...[
            _section(section),
            pw.SizedBox(height: 8),
          ],
          _privacy(snapshot.disclaimer.text),
        ],
      ),
    );
    return doc.save();
  }

  pw.Widget _status(ReportSnapshot snapshot) {
    return pw.Container(
      padding: const pw.EdgeInsets.only(bottom: 8),
      decoration: const pw.BoxDecoration(
        border: pw.Border(
          bottom: pw.BorderSide(color: LowEpisodeReportPdfTheme.ink, width: 2),
        ),
      ),
      child: pw.Row(
        children: [
          pw.Text(_strings.reportBrandName,
              style: LowEpisodeReportPdfTheme.label),
          pw.Spacer(),
          pw.Text('${snapshot.title} - ${_strings.pdfPreviewSuffix}',
              style: LowEpisodeReportPdfTheme.label),
        ],
      ),
    );
  }

  pw.Widget _hero(ReportSnapshot snapshot) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(_strings.episodeReview.toUpperCase(),
            style: LowEpisodeReportPdfTheme.eyebrow),
        pw.SizedBox(height: 4),
        pw.Text(_strings.lowEpisodeReportTitle,
            style: LowEpisodeReportPdfTheme.h1),
        pw.SizedBox(height: 7),
        _episodeHeroTime(snapshot),
        pw.SizedBox(height: 5),
        pw.Text(
          _strings.lowReportHeroSummary,
          style: LowEpisodeReportPdfTheme.body.copyWith(
            color: LowEpisodeReportPdfTheme.muted,
          ),
        ),
      ],
    );
  }

  pw.Widget _meta(ReportSnapshot snapshot) {
    final rows = [
      (
        _strings.reportPeriod,
        _period(snapshot.range.start, snapshot.range.end)
      ),
      (_strings.episodeAnalyzed, _episodeLabel(snapshot)),
      (_strings.reportDataSource, snapshot.sourceLabel),
      (_strings.reportGenerated, _dateTime(snapshot.generatedAt)),
      (_strings.thresholds, _thresholds(snapshot.unit)),
    ];
    return _card(
      pw.Row(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Expanded(
            child: pw.Column(children: [
              _metaRow(rows[0].$1, rows[0].$2),
              _metaRow(rows[1].$1, rows[1].$2),
              _metaRow(rows[3].$1, rows[3].$2),
            ]),
          ),
          pw.SizedBox(width: 18),
          pw.Expanded(
            child: pw.Column(children: [
              _metaRow(rows[2].$1, rows[2].$2),
              _metaRow(rows[4].$1, rows[4].$2),
            ]),
          ),
        ],
      ),
    );
  }

  pw.Widget _episodeHeroTime(ReportSnapshot snapshot) {
    return pw.Container(
      padding: const pw.EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: pw.BoxDecoration(
        color: PdfColor.fromHex('#e9f3fa'),
        border: pw.Border.all(color: PdfColor.fromHex('#c9deee')),
        borderRadius: pw.BorderRadius.circular(6),
      ),
      child: pw.Row(
        mainAxisSize: pw.MainAxisSize.min,
        children: [
          pw.Text(
            _strings.episodeAnalyzed.toUpperCase(),
            style: LowEpisodeReportPdfTheme.label,
          ),
          pw.SizedBox(width: 8),
          pw.Text(
            _episodeLabel(snapshot),
            style: pw.TextStyle(
              color: LowEpisodeReportPdfTheme.ink,
              fontSize: 10,
              fontWeight: pw.FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  pw.Widget _section(ReportSection section) {
    final trailing = switch (section.id) {
      'summary' => _strings.episodeView,
      'curve' => _curveTrailing(section),
      'lifecycle' => _strings.sequence,
      'repeat' => _strings.past30Days,
      _ => '',
    };
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.stretch,
      children: [
        pw.Container(
          padding: const pw.EdgeInsets.only(bottom: 4),
          decoration: const pw.BoxDecoration(
            border: pw.Border(
              bottom: pw.BorderSide(color: LowEpisodeReportPdfTheme.line),
            ),
          ),
          child: pw.Row(
            children: [
              pw.Expanded(
                child: pw.Text(
                  section.title.toUpperCase(),
                  style: LowEpisodeReportPdfTheme.section,
                ),
              ),
              if (trailing.isNotEmpty) _pill(trailing),
            ],
          ),
        ),
        pw.SizedBox(height: 8),
        _sectionBody(section),
        pw.SizedBox(height: 8),
      ],
    );
  }

  pw.Widget _sectionBody(ReportSection section) {
    final payload = section.payload;
    if (payload == null) return _insufficient();
    if (payload is LowEpisodeExposureSummaryPayload) {
      return _metricGrid(payload.metrics);
    }
    if (payload is LowEpisodeCurvePayload) return _curve(payload);
    if (payload is LowEpisodeLifecyclePayload) return _lifecycle(payload);
    if (payload is LowEpisodeRepeatPayload) return _repeat(payload);
    if (payload is LowEpisodeFindingListPayload) return _findings(payload);
    if (payload is LowEpisodeQualityPayload) {
      return _metricGrid(payload.metrics);
    }
    return _insufficient();
  }

  pw.Widget _metricGrid(List<LowEpisodeReportMetric> metrics) {
    return _card(
      pw.Wrap(
        spacing: 8,
        runSpacing: 8,
        children: [
          for (final metric in metrics)
            pw.SizedBox(width: 118, child: _metric(metric)),
        ],
      ),
    );
  }

  pw.Widget _metric(LowEpisodeReportMetric metric) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(8),
      decoration: pw.BoxDecoration(
        color: LowEpisodeReportPdfTheme.soft,
        border: pw.Border.all(color: LowEpisodeReportPdfTheme.line),
        borderRadius: pw.BorderRadius.circular(6),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(metric.label.toUpperCase(),
              style: LowEpisodeReportPdfTheme.label),
          pw.SizedBox(height: 4),
          pw.Text(
            metric.value,
            style: pw.TextStyle(
              color: _tone(metric.tone),
              fontSize: 18,
              fontWeight: pw.FontWeight.bold,
            ),
          ),
          pw.SizedBox(height: 2),
          pw.Text(metric.note,
              style: LowEpisodeReportPdfTheme.label.copyWith(fontSize: 7)),
        ],
      ),
    );
  }

  pw.Widget _curve(LowEpisodeCurvePayload payload) {
    return _card(
      pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.stretch,
        children: [
          pw.Stack(
            children: [
              pw.Container(
                height: 170,
                child: pw.SvgImage(svg: _curveSvg(payload)),
              ),
              pw.Positioned(
                right: 10,
                top: 4,
                child: pw.Container(
                  padding: const pw.EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 6,
                  ),
                  decoration: pw.BoxDecoration(
                    color: PdfColors.white,
                    border:
                        pw.Border.all(color: LowEpisodeReportPdfTheme.line2),
                    borderRadius: pw.BorderRadius.circular(6),
                  ),
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text(_strings.nadir,
                          style: LowEpisodeReportPdfTheme.label),
                      pw.Text(
                        payload.nadirLabel,
                        style: pw.TextStyle(
                          color: LowEpisodeReportPdfTheme.blue,
                          fontSize: 11,
                          fontWeight: pw.FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          pw.SizedBox(height: 8),
          _curveMarkerLegend(
            items: [
              (_strings.start, LowEpisodeReportPdfTheme.amber),
              (_strings.nadir, LowEpisodeReportPdfTheme.blue),
              if (payload.recoveryTime != null)
                (_strings.recover, LowEpisodeReportPdfTheme.green),
            ],
          ),
          pw.SizedBox(height: 8),
          pw.Row(
            children: [
              pw.Expanded(
                  child: _miniKpi(
                      payload.durationBelowRangeLabel, _strings.belowRange)),
              pw.SizedBox(width: 7),
              pw.Expanded(
                  child:
                      _miniKpi(payload.veryLowMinutesLabel, _strings.veryLow)),
              pw.SizedBox(width: 7),
              pw.Expanded(
                child: _miniKpi(payload.recoveryLabel, _strings.recovery),
              ),
            ],
          ),
        ],
      ),
      padding: const pw.EdgeInsets.all(8),
    );
  }

  pw.Widget _lifecycle(LowEpisodeLifecyclePayload payload) {
    return _card(
      pw.Row(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          for (final step in payload.steps)
            pw.Expanded(
              child: pw.Column(
                children: [
                  pw.Container(
                    width: 26,
                    height: 26,
                    alignment: pw.Alignment.center,
                    decoration: pw.BoxDecoration(
                      color: _tone(step.tone),
                      shape: pw.BoxShape.circle,
                    ),
                    child: pw.Text(
                      step.code,
                      style: pw.TextStyle(
                        color: PdfColors.white,
                        fontSize: 7,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                  ),
                  pw.SizedBox(height: 5),
                  pw.Text(step.label,
                      style: LowEpisodeReportPdfTheme.body
                          .copyWith(fontWeight: pw.FontWeight.bold)),
                  pw.SizedBox(height: 2),
                  pw.Text(step.value,
                      textAlign: pw.TextAlign.center,
                      style: LowEpisodeReportPdfTheme.label),
                ],
              ),
            ),
        ],
      ),
    );
  }

  pw.Widget _repeat(LowEpisodeRepeatPayload payload) {
    final dataset = payload.dataset;
    return _card(
      pw.Row(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Expanded(
            flex: 3,
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                _note(dataset.takeaway.isEmpty
                    ? _strings.repeatLimitedPast30
                    : dataset.takeaway),
                pw.SizedBox(height: 8),
                pw.Wrap(
                  spacing: 3,
                  runSpacing: 3,
                  children: [
                    for (final mark in dataset.dayMarks.take(30))
                      pw.Container(
                        width: 11,
                        height: 11,
                        decoration: pw.BoxDecoration(
                          color: mark.isCurrent
                              ? LowEpisodeReportPdfTheme.green
                              : mark.hasEpisode
                                  ? LowEpisodeReportPdfTheme.cyan
                                  : LowEpisodeReportPdfTheme.line,
                          borderRadius: pw.BorderRadius.circular(3),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
          pw.SizedBox(width: 18),
          pw.Expanded(
            flex: 2,
            child: pw.Column(
              children: [
                for (final bucket in dataset.timeBlockBuckets)
                  _barRow(
                    bucket.label,
                    bucket.count,
                    bucket.normalizedHeight,
                    bucket.isDominant
                        ? LowEpisodeReportPdfTheme.blue
                        : bucket.isSecondary
                            ? LowEpisodeReportPdfTheme.cyan
                            : LowEpisodeReportPdfTheme.softInk,
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  pw.Widget _findings(LowEpisodeFindingListPayload payload) {
    return _card(
      pw.Column(
        children: [
          for (var i = 0; i < payload.findings.length; i++) ...[
            if (i > 0) pw.Divider(color: LowEpisodeReportPdfTheme.line),
            pw.Row(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Container(
                  width: 7,
                  height: 7,
                  margin: const pw.EdgeInsets.only(top: 3),
                  decoration: pw.BoxDecoration(
                    color: _tone(payload.findings[i].tone),
                    shape: pw.BoxShape.circle,
                  ),
                ),
                pw.SizedBox(width: 8),
                pw.Expanded(
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text(payload.findings[i].title,
                          style: LowEpisodeReportPdfTheme.body
                              .copyWith(fontWeight: pw.FontWeight.bold)),
                      pw.Text(
                        payload.findings[i].body,
                        style: LowEpisodeReportPdfTheme.body.copyWith(
                          color: LowEpisodeReportPdfTheme.muted,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  pw.Widget _card(
    pw.Widget child, {
    pw.EdgeInsetsGeometry padding = const pw.EdgeInsets.all(10),
  }) {
    return pw.Container(
      padding: padding,
      decoration: pw.BoxDecoration(
        color: LowEpisodeReportPdfTheme.panel,
        border: pw.Border.all(color: LowEpisodeReportPdfTheme.line),
        borderRadius: pw.BorderRadius.circular(6),
      ),
      child: child,
    );
  }

  pw.Widget _metaRow(String label, String value) {
    return pw.Container(
      padding: const pw.EdgeInsets.symmetric(vertical: 5),
      decoration: const pw.BoxDecoration(
        border:
            pw.Border(top: pw.BorderSide(color: LowEpisodeReportPdfTheme.line)),
      ),
      child: pw.Row(
        children: [
          pw.Text(label.toUpperCase(), style: LowEpisodeReportPdfTheme.label),
          pw.SizedBox(width: 10),
          pw.Expanded(
            child: pw.Text(
              value,
              textAlign: pw.TextAlign.right,
              style: LowEpisodeReportPdfTheme.label,
            ),
          ),
        ],
      ),
    );
  }

  pw.Widget _miniKpi(String value, String label) {
    return pw.Container(
      padding: const pw.EdgeInsets.symmetric(horizontal: 6, vertical: 7),
      decoration: pw.BoxDecoration(
        color: LowEpisodeReportPdfTheme.soft,
        border: pw.Border.all(color: LowEpisodeReportPdfTheme.line),
        borderRadius: pw.BorderRadius.circular(6),
      ),
      child: pw.Column(
        children: [
          pw.Text(
            value,
            style: LowEpisodeReportPdfTheme.body
                .copyWith(fontWeight: pw.FontWeight.bold),
          ),
          pw.SizedBox(height: 2),
          pw.Text(label.toUpperCase(), style: LowEpisodeReportPdfTheme.label),
        ],
      ),
    );
  }

  pw.Widget _curveMarkerLegend({
    required List<(String, PdfColor)> items,
  }) {
    return pw.Wrap(
      spacing: 10,
      runSpacing: 4,
      children: [
        for (final item in items)
          pw.Row(
            mainAxisSize: pw.MainAxisSize.min,
            children: [
              pw.Container(
                width: 7,
                height: 7,
                decoration: pw.BoxDecoration(
                  color: item.$2,
                  borderRadius: pw.BorderRadius.circular(2),
                ),
              ),
              pw.SizedBox(width: 4),
              pw.Text(item.$1, style: LowEpisodeReportPdfTheme.label),
            ],
          ),
      ],
    );
  }

  pw.Widget _note(String text) {
    return pw.Container(
      padding: const pw.EdgeInsets.symmetric(horizontal: 9, vertical: 8),
      decoration: pw.BoxDecoration(
        color: LowEpisodeReportPdfTheme.blueSoft,
        border: pw.Border.all(color: LowEpisodeReportPdfTheme.line),
        borderRadius: pw.BorderRadius.circular(6),
      ),
      child: pw.Text(
        text,
        style: LowEpisodeReportPdfTheme.body.copyWith(
          color: LowEpisodeReportPdfTheme.muted,
        ),
      ),
    );
  }

  pw.Widget _barRow(
    String label,
    int count,
    double fraction,
    PdfColor color,
  ) {
    return pw.Container(
      padding: const pw.EdgeInsets.symmetric(vertical: 5),
      decoration: const pw.BoxDecoration(
        border:
            pw.Border(top: pw.BorderSide(color: LowEpisodeReportPdfTheme.line)),
      ),
      child: pw.Row(
        children: [
          pw.SizedBox(
            width: 58,
            child: pw.Text(label, style: LowEpisodeReportPdfTheme.label),
          ),
          pw.Expanded(
            child: pw.Row(
              children: [
                pw.Expanded(
                  flex: (fraction.clamp(.03, 1) * 100).round(),
                  child: pw.Container(height: 8, color: color),
                ),
                pw.Expanded(
                  flex: ((1 - fraction.clamp(.03, 1)) * 100).round(),
                  child: pw.Container(
                    height: 8,
                    color: LowEpisodeReportPdfTheme.line,
                  ),
                ),
              ],
            ),
          ),
          pw.SizedBox(width: 8),
          pw.Text('$count', style: LowEpisodeReportPdfTheme.label),
        ],
      ),
    );
  }

  pw.Widget _pill(String text) {
    return pw.Container(
      padding: const pw.EdgeInsets.symmetric(horizontal: 7, vertical: 3),
      decoration: pw.BoxDecoration(
        color: LowEpisodeReportPdfTheme.blueSoft,
        border: pw.Border.all(color: LowEpisodeReportPdfTheme.line2),
        borderRadius: pw.BorderRadius.circular(4),
      ),
      child: pw.Text(
        text,
        style: LowEpisodeReportPdfTheme.label.copyWith(
          color: LowEpisodeReportPdfTheme.blue,
        ),
      ),
    );
  }

  pw.Widget _privacy(String text) {
    return pw.Container(
      margin: const pw.EdgeInsets.only(top: 14),
      padding: const pw.EdgeInsets.only(top: 8),
      decoration: const pw.BoxDecoration(
        border:
            pw.Border(top: pw.BorderSide(color: LowEpisodeReportPdfTheme.line)),
      ),
      child: pw.Text(
        text,
        style: LowEpisodeReportPdfTheme.label.copyWith(fontSize: 7),
      ),
    );
  }

  pw.Widget _insufficient() {
    return _card(pw.Text(_strings.insufficientData,
        style: LowEpisodeReportPdfTheme.body));
  }

  String _curveTrailing(ReportSection section) {
    final payload = section.payload;
    if (payload is LowEpisodeCurvePayload) {
      final end = payload.recoveryTime ?? payload.timeRangeEnd;
      return '${EpisodeDetailFormatters.hm(payload.onsetTime)}-${EpisodeDetailFormatters.hm(end)}';
    }
    return '';
  }

  String _period(DateTime start, DateTime end) {
    return '${EpisodeDetailFormatters.shortDate(start)} - ${EpisodeDetailFormatters.shortDate(end)}, ${end.year}';
  }

  String _dateTime(DateTime time) {
    return '${EpisodeDetailFormatters.shortDate(time)}, ${time.year} ${EpisodeDetailFormatters.hm(time)}';
  }

  String _episodeLabel(ReportSnapshot snapshot) {
    LowEpisodeCurvePayload? curve;
    for (final section in snapshot.sections) {
      final payload = section.payload;
      if (payload is LowEpisodeCurvePayload) {
        curve = payload;
        break;
      }
    }
    if (curve == null) return _strings.episodeTimeUnavailable;
    final end = curve.recoveryTime ?? curve.timeRangeEnd;
    return '${EpisodeDetailFormatters.shortDate(curve.onsetTime)}, '
        '${curve.onsetTime.year} · ${EpisodeDetailFormatters.hm(curve.onsetTime)}'
        '-${EpisodeDetailFormatters.hm(end)}';
  }

  String _thresholds(GlucoseUnit unit) {
    return unit == GlucoseUnit.mgDl
        ? _strings.lowThresholds('70', '54')
        : _strings.lowThresholds('3.9', '3.0');
  }

  String _curveSvg(LowEpisodeCurvePayload payload) {
    const width = 704.0;
    const height = 254.0;
    const left = 54.0;
    const right = 648.0;
    const top = 18.0;
    const bottom = 210.0;
    final values = payload.readings.map((e) => e.value).toList();
    final minValue = math.min(
      values.isEmpty
          ? payload.veryLowThresholdMmol * .7
          : values.reduce(math.min) - .5,
      payload.veryLowThresholdMmol * .85,
    );
    final maxValue = math.max(
      values.isEmpty ? payload.lowThresholdMmol * 1.9 : values.reduce(math.max),
      payload.lowThresholdMmol * 1.8,
    );
    double x(DateTime time) {
      final total = payload.timeRangeEnd
          .difference(payload.timeRangeStart)
          .inMilliseconds;
      if (total <= 0) return left;
      final delta = time.difference(payload.timeRangeStart).inMilliseconds;
      return left + (right - left) * (delta / total).clamp(0, 1);
    }

    double y(double value) {
      final span = math.max(.1, maxValue - minValue);
      return bottom - (bottom - top) * ((value - minValue) / span).clamp(0, 1);
    }

    final points = payload.readings
        .map((reading) =>
            '${x(reading.timestamp).toStringAsFixed(1)},${y(reading.value).toStringAsFixed(1)}')
        .join(' ');
    final lowY = y(payload.lowThresholdMmol).toStringAsFixed(1);
    final veryLowY = y(payload.veryLowThresholdMmol).toStringAsFixed(1);
    final onsetX = x(payload.onsetTime).toStringAsFixed(1);
    final nadirX = x(payload.nadirTime).toStringAsFixed(1);
    final nadirReading = payload.readings.isEmpty
        ? payload.veryLowThresholdMmol
        : payload.readings.reduce((a, b) => a.value <= b.value ? a : b).value;
    final nadirY = y(nadirReading).toStringAsFixed(1);
    final recoveryX = payload.recoveryTime == null
        ? null
        : x(payload.recoveryTime!).toStringAsFixed(1);
    return '''
<svg viewBox="0 0 $width $height" xmlns="http://www.w3.org/2000/svg">
  <rect x="$left" y="$top" width="${right - left}" height="${double.parse(lowY) - top}" fill="#e8f5ed"/>
  <rect x="$left" y="$lowY" width="${right - left}" height="${bottom - double.parse(lowY)}" fill="#e9f3fa"/>
  <rect x="$left" y="$veryLowY" width="${right - left}" height="${bottom - double.parse(veryLowY)}" fill="#dceef8"/>
  <line x1="$left" y1="$lowY" x2="$right" y2="$lowY" stroke="#a7cde6" stroke-dasharray="6 5"/>
  <line x1="$left" y1="$veryLowY" x2="$right" y2="$veryLowY" stroke="#78afd2" stroke-dasharray="6 5"/>
  <line x1="$left" y1="$bottom" x2="$right" y2="$bottom" stroke="#dfe6e2"/>
  <polyline points="$points" fill="none" stroke="#2d7ab0" stroke-width="5" stroke-linecap="round" stroke-linejoin="round"/>
  <line x1="$onsetX" y1="22" x2="$onsetX" y2="$bottom" stroke="#b87518" stroke-dasharray="5 5"/>
  <line x1="$nadirX" y1="22" x2="$nadirX" y2="$bottom" stroke="#2d7ab0" stroke-dasharray="5 5"/>
  ${recoveryX == null ? '' : '<line x1="$recoveryX" y1="22" x2="$recoveryX" y2="$bottom" stroke="#1a9e5c" stroke-dasharray="5 5"/>'}
  <circle cx="$nadirX" cy="$nadirY" r="8" fill="#2d7ab0" stroke="#fff" stroke-width="3"/>
  <text x="44" y="$lowY" text-anchor="end" fill="#61746b" font-size="11">${_threshold(payload.unit, payload.lowThresholdMmol)}</text>
  <text x="44" y="$veryLowY" text-anchor="end" fill="#61746b" font-size="11">${_threshold(payload.unit, payload.veryLowThresholdMmol)}</text>
  <text x="$left" y="236" fill="#61746b" font-size="11" text-anchor="middle">${EpisodeDetailFormatters.hm(payload.timeRangeStart)}</text>
  <text x="$right" y="236" fill="#61746b" font-size="11" text-anchor="middle">${EpisodeDetailFormatters.hm(payload.timeRangeEnd)}</text>
</svg>
''';
  }

  String _threshold(GlucoseUnit unit, double mmol) {
    if (unit == GlucoseUnit.mgDl) return (mmol * 18.0182).round().toString();
    return mmol.toStringAsFixed(1);
  }

  PdfColor _tone(String tone) {
    return switch (tone) {
      'blue' => LowEpisodeReportPdfTheme.blue,
      'cyan' => LowEpisodeReportPdfTheme.cyan,
      'amber' || 'warning' => LowEpisodeReportPdfTheme.amber,
      'green' => LowEpisodeReportPdfTheme.green,
      _ => LowEpisodeReportPdfTheme.ink,
    };
  }
}
