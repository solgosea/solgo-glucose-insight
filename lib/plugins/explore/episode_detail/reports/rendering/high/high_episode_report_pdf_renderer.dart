import 'dart:math' as math;

import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:smart_xdrip/application/glucose_unit/glucose_unit_format_service.dart';
import 'package:smart_xdrip/domain/entities/app_settings.dart';
import 'package:smart_xdrip/reporting/domain/report_section.dart';
import 'package:smart_xdrip/reporting/domain/report_snapshot.dart';
import 'package:smart_xdrip/reporting/rendering/pdf/report_pdf_document_shell.dart';
import 'package:smart_xdrip/reporting/rendering/pdf/report_pdf_renderer.dart';

import '../../../application/i18n/episode_detail_l10n_resolver.dart';
import '../../../application/episode_detail_formatters.dart';
import '../../high/high_episode_report_payloads.dart';
import 'high_episode_report_pdf_theme.dart';

class HighEpisodeReportPdfRenderer implements ReportPdfRenderer {
  final ReportPdfDocumentShell shell;
  final GlucoseUnitFormatService formatter;

  const HighEpisodeReportPdfRenderer({
    this.shell = const ReportPdfDocumentShell(),
    this.formatter = const GlucoseUnitFormatService(),
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
          _hero(snapshot),
          pw.SizedBox(height: 10),
          _meta(snapshot),
          pw.SizedBox(height: 12),
          for (final section in snapshot.sections) ...[
            _section(section),
            pw.SizedBox(height: 8),
          ],
          _privacy(snapshot),
        ],
      ),
    );
    return doc.save();
  }

  pw.Widget _status(ReportSnapshot snapshot) {
    return pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
      children: [
        pw.Text(_strings.reportBrandName,
            style: HighEpisodeReportPdfTheme.label),
        pw.Text(
          '${snapshot.title} - ${_strings.pdfPreviewSuffix}',
          style: HighEpisodeReportPdfTheme.label,
        ),
      ],
    );
  }

  pw.Widget _hero(ReportSnapshot snapshot) {
    return pw.Container(
      padding: const pw.EdgeInsets.only(top: 4, bottom: 12),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            _strings.episodeReview.toUpperCase(),
            style: HighEpisodeReportPdfTheme.eyebrow,
          ),
          pw.SizedBox(height: 4),
          pw.Text(
            _strings.highEpisodeReportTitle,
            style: HighEpisodeReportPdfTheme.h1,
          ),
          pw.SizedBox(height: 7),
          _episodeHeroTime(snapshot),
          pw.SizedBox(height: 6),
          pw.Text(
            _strings.highReportHeroSummary,
            style: HighEpisodeReportPdfTheme.body,
          ),
        ],
      ),
    );
  }

  pw.Widget _meta(ReportSnapshot snapshot) {
    final high = _threshold(snapshot.unit, 10.0);
    final veryHigh = _threshold(snapshot.unit, 13.9);
    return _card(
      pw.Row(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Expanded(
            child: pw.Column(
              children: [
                _metaRow(_strings.reportPeriod,
                    _period(snapshot.range.start, snapshot.range.end)),
                _metaRow(_strings.episodeAnalyzed, _episodeLabel(snapshot)),
                _metaRow(
                    _strings.reportGenerated, _dateTime(snapshot.generatedAt)),
              ],
            ),
          ),
          pw.SizedBox(width: 18),
          pw.Expanded(
            child: pw.Column(
              children: [
                _metaRow(_strings.reportDataSource, snapshot.sourceLabel),
                _metaRow(
                  _strings.thresholds,
                  _strings.highThresholds(high, veryHigh),
                ),
              ],
            ),
          ),
        ],
      ),
      padding: const pw.EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    );
  }

  pw.Widget _episodeHeroTime(ReportSnapshot snapshot) {
    return pw.Container(
      padding: const pw.EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: pw.BoxDecoration(
        color: HighEpisodeReportPdfTheme.amberSoft,
        border: pw.Border.all(color: PdfColor.fromHex('#ead7b6')),
        borderRadius: pw.BorderRadius.circular(6),
      ),
      child: pw.Row(
        mainAxisSize: pw.MainAxisSize.min,
        children: [
          pw.Text(
            _strings.episodeAnalyzed.toUpperCase(),
            style: HighEpisodeReportPdfTheme.label,
          ),
          pw.SizedBox(width: 8),
          pw.Text(
            _episodeLabel(snapshot),
            style: pw.TextStyle(
              color: HighEpisodeReportPdfTheme.ink,
              fontSize: 10,
              fontWeight: pw.FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  pw.Widget _section(ReportSection section) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.stretch,
      children: [
        _sectionLabel(section),
        pw.SizedBox(height: 5),
        _sectionBody(section),
      ],
    );
  }

  pw.Widget _sectionLabel(ReportSection section) {
    final trailing = switch (section.id) {
      '01' => _strings.episodeView,
      '02' => '',
      '03' => _strings.sequence,
      '04' => _strings.past30Days,
      '05' => _strings.timeVsPeak,
      _ => '',
    };
    return pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
      children: [
        pw.Expanded(
          child: pw.Container(
            padding: const pw.EdgeInsets.only(bottom: 4),
            decoration: const pw.BoxDecoration(
              border: pw.Border(
                bottom: pw.BorderSide(
                  color: HighEpisodeReportPdfTheme.line,
                  width: .8,
                ),
              ),
            ),
            child: pw.RichText(
              text: pw.TextSpan(
                children: [
                  pw.TextSpan(
                    text: section.title.toUpperCase(),
                    style: HighEpisodeReportPdfTheme.section,
                  ),
                ],
              ),
            ),
          ),
        ),
        pw.SizedBox(width: 8),
        if (trailing.isNotEmpty) _pill(trailing),
      ],
    );
  }

  pw.Widget _sectionBody(ReportSection section) {
    final payload = section.payload;
    if (payload == null) return _insufficient();
    if (payload is HighEpisodeExposureSummaryPayload) {
      return _metricGrid(payload.metrics);
    }
    if (payload is HighEpisodeCurvePayload) {
      return _curve(payload);
    }
    if (payload is HighEpisodeLifecyclePayload) {
      return _lifecycle(payload);
    }
    if (payload is HighEpisodeRepeatPayload) {
      return _repeat(payload);
    }
    if (payload is HighEpisodeSimilarPayload) {
      return _similar(payload);
    }
    if (payload is HighEpisodeFindingListPayload) {
      return _findings(payload);
    }
    if (payload is HighEpisodeQualityPayload) {
      return _qualityGrid(payload.metrics);
    }
    return _insufficient();
  }

  pw.Widget _metricGrid(List<HighEpisodeReportMetric> metrics) {
    return _card(
      pw.Row(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          for (var i = 0; i < metrics.length; i++) ...[
            if (i > 0) pw.SizedBox(width: 8),
            pw.Expanded(child: _metric(metrics[i])),
          ],
        ],
      ),
      padding: const pw.EdgeInsets.all(10),
    );
  }

  pw.Widget _metric(HighEpisodeReportMetric metric) {
    final color = _tone(metric.tone);
    return pw.Container(
      padding: const pw.EdgeInsets.all(9),
      decoration: _box(
        color: HighEpisodeReportPdfTheme.soft,
        border: HighEpisodeReportPdfTheme.line,
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(metric.label, style: HighEpisodeReportPdfTheme.label),
          pw.SizedBox(height: 5),
          pw.Text(
            metric.value,
            style: pw.TextStyle(
              fontSize: 18,
              fontWeight: pw.FontWeight.bold,
              color: color,
            ),
          ),
          pw.SizedBox(height: 3),
          pw.Text(metric.note, style: HighEpisodeReportPdfTheme.label),
        ],
      ),
    );
  }

  pw.Widget _curve(HighEpisodeCurvePayload payload) {
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
                  decoration: _box(
                    color: PdfColors.white,
                    border: HighEpisodeReportPdfTheme.line2,
                  ),
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text(
                        _strings.peak,
                        style: HighEpisodeReportPdfTheme.label,
                      ),
                      pw.Text(
                        payload.peakLabel,
                        style: pw.TextStyle(
                          color: HighEpisodeReportPdfTheme.rose,
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
              (_strings.start, HighEpisodeReportPdfTheme.amber),
              (_strings.peak, HighEpisodeReportPdfTheme.rose),
              if (payload.returnTime != null)
                (_strings.returnLabel, HighEpisodeReportPdfTheme.green),
            ],
          ),
          pw.SizedBox(height: 8),
          pw.Row(
            children: [
              pw.Expanded(
                  child: _miniKpi(
                      payload.durationAboveRangeLabel, _strings.aboveRange)),
              pw.SizedBox(width: 7),
              pw.Expanded(
                  child: _miniKpi(
                      payload.veryHighMinutesLabel, _strings.veryHigh)),
              pw.SizedBox(width: 7),
              pw.Expanded(
                child: _miniKpi(payload.returnLabel, _strings.returnLabel),
              ),
            ],
          ),
        ],
      ),
      padding: const pw.EdgeInsets.all(8),
    );
  }

  pw.Widget _lifecycle(HighEpisodeLifecyclePayload payload) {
    return _card(
      pw.Stack(
        children: [
          pw.Positioned(
            left: 56,
            right: 56,
            top: 16,
            child:
                pw.Container(height: 1, color: HighEpisodeReportPdfTheme.line2),
          ),
          pw.Row(
            children: [
              for (var i = 0; i < payload.steps.length; i++) ...[
                if (i > 0) pw.SizedBox(width: 6),
                pw.Expanded(child: _lifeStep(payload.steps[i])),
              ],
            ],
          ),
        ],
      ),
      padding: const pw.EdgeInsets.symmetric(horizontal: 10, vertical: 11),
    );
  }

  pw.Widget _qualityGrid(List<HighEpisodeReportMetric> metrics) {
    return _card(
      pw.Row(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          for (var i = 0; i < metrics.length; i++) ...[
            if (i > 0) pw.SizedBox(width: 8),
            pw.Expanded(child: _qualityMetric(metrics[i])),
          ],
        ],
      ),
      padding: const pw.EdgeInsets.all(10),
    );
  }

  pw.Widget _qualityMetric(HighEpisodeReportMetric metric) {
    return pw.Container(
      padding: const pw.EdgeInsets.symmetric(horizontal: 9, vertical: 8),
      decoration: _box(
        color: HighEpisodeReportPdfTheme.soft,
        border: const PdfColor.fromInt(0xFFE2EAE5),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            metric.value,
            style: pw.TextStyle(
              fontSize: 14,
              fontWeight: pw.FontWeight.bold,
              color: _tone(metric.tone),
            ),
          ),
          pw.SizedBox(height: 3),
          pw.Text(metric.label.toLowerCase(),
              style: HighEpisodeReportPdfTheme.label),
        ],
      ),
    );
  }

  pw.Widget _lifeStep(HighEpisodeLifecycleStepPayload step) {
    final color = _tone(step.tone);
    return pw.Container(
      padding: const pw.EdgeInsets.symmetric(horizontal: 4),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.center,
        children: [
          pw.Container(
            width: 30,
            height: 30,
            alignment: pw.Alignment.center,
            decoration: pw.BoxDecoration(
              shape: pw.BoxShape.circle,
              color: step.tone == 'neutral'
                  ? HighEpisodeReportPdfTheme.panel
                  : color,
              border: pw.Border.all(
                color: step.tone == 'neutral'
                    ? HighEpisodeReportPdfTheme.line2
                    : color,
              ),
            ),
            child: pw.Text(
              step.code,
              style: pw.TextStyle(
                color: step.tone == 'neutral'
                    ? HighEpisodeReportPdfTheme.green
                    : PdfColors.white,
                fontSize: 8,
                fontWeight: pw.FontWeight.bold,
              ),
            ),
          ),
          pw.SizedBox(height: 5),
          pw.Text(
            step.label,
            textAlign: pw.TextAlign.center,
            style: HighEpisodeReportPdfTheme.body.copyWith(
              fontSize: 8.5,
              fontWeight: pw.FontWeight.bold,
            ),
          ),
          pw.SizedBox(height: 3),
          pw.Text(
            step.value,
            textAlign: pw.TextAlign.center,
            style: pw.TextStyle(
              color: HighEpisodeReportPdfTheme.muted,
              fontSize: 7.5,
            ),
          ),
        ],
      ),
    );
  }

  pw.Widget _repeat(HighEpisodeRepeatPayload payload) {
    final dataset = payload.dataset;
    return _card(
      pw.Row(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Expanded(
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                _noteBox(
                  dataset.takeaway.isEmpty
                      ? _strings.repeatLimitedPast30
                      : dataset.takeaway,
                ),
                pw.SizedBox(height: 8),
                pw.Wrap(
                  spacing: 4,
                  runSpacing: 4,
                  children: [
                    for (final mark in dataset.dayMarks.take(30))
                      pw.Container(
                        width: 14,
                        height: 12,
                        decoration: pw.BoxDecoration(
                          color: mark.isCurrent
                              ? HighEpisodeReportPdfTheme.green
                              : mark.isStrong
                                  ? HighEpisodeReportPdfTheme.rose
                                  : mark.hasEpisode
                                      ? HighEpisodeReportPdfTheme.amber
                                      : HighEpisodeReportPdfTheme.line,
                          borderRadius: pw.BorderRadius.circular(2),
                        ),
                      ),
                  ],
                ),
                pw.SizedBox(height: 8),
                _repeatLegend(),
              ],
            ),
          ),
          pw.SizedBox(width: 14),
          pw.Expanded(
            child: pw.Column(
              children: [
                for (final bucket in dataset.timeBlockBuckets)
                  _barRow(
                    bucket.label,
                    bucket.count,
                    bucket.normalizedHeight,
                    bucket.isDominant
                        ? HighEpisodeReportPdfTheme.rose
                        : HighEpisodeReportPdfTheme.amber,
                  ),
              ],
            ),
          ),
        ],
      ),
      padding: const pw.EdgeInsets.all(10),
    );
  }

  pw.Widget _similar(HighEpisodeSimilarPayload payload) {
    return _card(
      pw.Row(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Expanded(
            flex: 3,
            child: pw.Container(
              height: 150,
              child: pw.SvgImage(svg: _similarSvg(payload)),
            ),
          ),
          pw.SizedBox(width: 12),
          pw.Expanded(
            flex: 2,
            child: pw.Column(
              children: [
                _stackMetric(
                  _strings.similarHighs,
                  '${payload.similarCount}',
                  _strings.pastDays(payload.windowDays),
                  'amber',
                ),
                pw.SizedBox(height: 6),
                _stackMetric(
                  _strings.medianPeak,
                  payload.medianPeakLabel,
                  _strings.glucosePeak,
                  'rose',
                ),
                pw.SizedBox(height: 6),
                _stackMetric(
                  _strings.medianDuration,
                  payload.medianDurationLabel,
                  _strings.aboveRange,
                  'amber',
                ),
              ],
            ),
          ),
        ],
      ),
      padding: const pw.EdgeInsets.all(10),
    );
  }

  pw.Widget _findings(HighEpisodeFindingListPayload payload) {
    return _card(
      pw.Column(
        children: [
          for (final finding in payload.findings) ...[
            pw.Row(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Container(
                  width: 7,
                  height: 7,
                  margin: const pw.EdgeInsets.only(top: 3),
                  decoration: pw.BoxDecoration(
                    shape: pw.BoxShape.circle,
                    color: _tone(finding.tone),
                  ),
                ),
                pw.SizedBox(width: 8),
                pw.Expanded(
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text(
                        finding.title,
                        style: HighEpisodeReportPdfTheme.section,
                      ),
                      pw.SizedBox(height: 2),
                      pw.Text(finding.body,
                          style: HighEpisodeReportPdfTheme.body),
                    ],
                  ),
                ),
              ],
            ),
            pw.SizedBox(height: 8),
          ],
        ],
      ),
    );
  }

  pw.Widget _privacy(ReportSnapshot snapshot) {
    return pw.Container(
      margin: const pw.EdgeInsets.only(top: 8),
      padding: const pw.EdgeInsets.all(10),
      decoration: _box(
        color: const PdfColor.fromInt(0xFFF5F9FF),
        border: const PdfColor.fromInt(0xFFBFD6F2),
      ),
      child: pw.Text(snapshot.disclaimer.text,
          style: HighEpisodeReportPdfTheme.body),
    );
  }

  pw.Widget _metaRow(String label, String value) {
    return pw.Container(
      padding: const pw.EdgeInsets.symmetric(vertical: 4),
      decoration: const pw.BoxDecoration(
        border: pw.Border(
          top: pw.BorderSide(
            color: PdfColor.fromInt(0xFFEDF2EF),
            width: .5,
          ),
        ),
      ),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Text(label, style: HighEpisodeReportPdfTheme.label),
          pw.Text(
            value,
            style: HighEpisodeReportPdfTheme.body.copyWith(
              fontWeight: pw.FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  pw.Widget _card(
    pw.Widget child, {
    pw.EdgeInsets padding = const pw.EdgeInsets.all(11),
  }) {
    return pw.Container(
      padding: padding,
      decoration: _box(
        color: HighEpisodeReportPdfTheme.card,
        border: HighEpisodeReportPdfTheme.line,
      ),
      child: child,
    );
  }

  pw.Widget _repeatLegend() {
    return pw.Wrap(
      spacing: 8,
      runSpacing: 4,
      children: [
        _legendDot(_strings.none, HighEpisodeReportPdfTheme.line),
        _legendDot(_strings.high, HighEpisodeReportPdfTheme.amber),
        _legendDot(_strings.strongHigh, HighEpisodeReportPdfTheme.rose),
        _legendDot(_strings.current, HighEpisodeReportPdfTheme.green),
      ],
    );
  }

  pw.Widget _legendDot(String label, PdfColor color) {
    return pw.Row(
      mainAxisSize: pw.MainAxisSize.min,
      children: [
        pw.Container(
          width: 8,
          height: 8,
          decoration: pw.BoxDecoration(
            color: color,
            borderRadius: pw.BorderRadius.circular(2),
            border: pw.Border.all(color: HighEpisodeReportPdfTheme.line),
          ),
        ),
        pw.SizedBox(width: 3),
        pw.Text(label, style: HighEpisodeReportPdfTheme.label),
      ],
    );
  }

  pw.Widget _insufficient() {
    return _card(
      pw.Text(_strings.insufficientData, style: HighEpisodeReportPdfTheme.body),
    );
  }

  pw.Widget _pill(String text) {
    return pw.Container(
      padding: const pw.EdgeInsets.symmetric(horizontal: 7, vertical: 3),
      decoration: pw.BoxDecoration(
        color: HighEpisodeReportPdfTheme.amberSoft,
        borderRadius: pw.BorderRadius.circular(4),
      ),
      child: pw.Text(
        text.toUpperCase(),
        style: HighEpisodeReportPdfTheme.label.copyWith(
          color: HighEpisodeReportPdfTheme.amber,
        ),
      ),
    );
  }

  pw.Widget _noteBox(String text) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(8),
      decoration: _box(
        color: HighEpisodeReportPdfTheme.amberSoft,
        border: const PdfColor.fromInt(0xFFECD9B0),
      ),
      child: pw.Text(text, style: HighEpisodeReportPdfTheme.body),
    );
  }

  pw.Widget _miniKpi(String value, String label) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(8),
      decoration: _box(
        color: HighEpisodeReportPdfTheme.soft,
        border: HighEpisodeReportPdfTheme.line,
      ),
      child: pw.Column(
        children: [
          pw.Text(
            value,
            style: pw.TextStyle(
              fontSize: 11,
              fontWeight: pw.FontWeight.bold,
              color: HighEpisodeReportPdfTheme.ink,
            ),
          ),
          pw.Text(label, style: HighEpisodeReportPdfTheme.label),
        ],
      ),
    );
  }

  pw.Widget _stackMetric(String label, String value, String note, String tone) {
    return pw.Container(
      width: double.infinity,
      padding: const pw.EdgeInsets.all(8),
      decoration: _box(
        color: HighEpisodeReportPdfTheme.soft,
        border: HighEpisodeReportPdfTheme.line,
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(label, style: HighEpisodeReportPdfTheme.label),
          pw.SizedBox(height: 3),
          pw.Text(
            value,
            style: pw.TextStyle(
              fontSize: 15,
              fontWeight: pw.FontWeight.bold,
              color: _tone(tone),
            ),
          ),
          pw.Text(note, style: HighEpisodeReportPdfTheme.label),
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
              pw.Text(item.$1, style: HighEpisodeReportPdfTheme.label),
            ],
          ),
      ],
    );
  }

  pw.Widget _barRow(
      String label, int count, double normalized, PdfColor color) {
    return pw.Padding(
      padding: const pw.EdgeInsets.only(bottom: 6),
      child: pw.Row(
        children: [
          pw.SizedBox(
            width: 48,
            child: pw.Text(label, style: HighEpisodeReportPdfTheme.label),
          ),
          pw.Expanded(
            child: pw.Stack(
              children: [
                pw.Container(
                  height: 8,
                  decoration: pw.BoxDecoration(
                    color: HighEpisodeReportPdfTheme.line,
                    borderRadius: pw.BorderRadius.circular(4),
                  ),
                ),
                pw.Container(
                  width: 90 * normalized.clamp(0.04, 1.0),
                  height: 8,
                  decoration: pw.BoxDecoration(
                    color: color,
                    borderRadius: pw.BorderRadius.circular(4),
                  ),
                ),
              ],
            ),
          ),
          pw.SizedBox(width: 6),
          pw.Text('$count', style: HighEpisodeReportPdfTheme.label),
        ],
      ),
    );
  }

  pw.BoxDecoration _box({
    required PdfColor color,
    required PdfColor border,
  }) {
    return pw.BoxDecoration(
      color: color,
      borderRadius: pw.BorderRadius.circular(8),
      border: pw.Border.all(color: border, width: .8),
    );
  }

  PdfColor _tone(String tone) {
    return switch (tone) {
      'rose' => HighEpisodeReportPdfTheme.rose,
      'hot' => HighEpisodeReportPdfTheme.rose,
      'amber' => HighEpisodeReportPdfTheme.amber,
      'warning' => HighEpisodeReportPdfTheme.amber,
      'blue' => HighEpisodeReportPdfTheme.blue,
      'green' => HighEpisodeReportPdfTheme.green,
      _ => HighEpisodeReportPdfTheme.ink,
    };
  }

  String _curveSvg(HighEpisodeCurvePayload payload) {
    const width = 704.0;
    const height = 254.0;
    const left = 54.0;
    const right = 648.0;
    const top = 18.0;
    const bottom = 210.0;
    final values = payload.readings.map((e) => e.value).toList();
    final minValue = math.min(
      values.isEmpty ? payload.highThresholdMmol * .7 : values.reduce(math.min),
      payload.highThresholdMmol * .7,
    );
    final maxValue = math.max(
      values.isEmpty
          ? payload.veryHighThresholdMmol * 1.15
          : values.reduce(math.max),
      payload.veryHighThresholdMmol * 1.15,
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
        .map((r) =>
            '${x(r.timestamp).toStringAsFixed(1)},${y(r.value).toStringAsFixed(1)}')
        .join(' ');
    final highY = y(payload.highThresholdMmol).toStringAsFixed(1);
    final veryHighY = y(payload.veryHighThresholdMmol).toStringAsFixed(1);
    final onsetX = x(payload.onsetTime).toStringAsFixed(1);
    final peakX = x(payload.peakTime).toStringAsFixed(1);
    final peakReading = payload.readings.isEmpty
        ? payload.veryHighThresholdMmol
        : payload.readings.reduce((a, b) => a.value >= b.value ? a : b).value;
    final peakY = y(peakReading).toStringAsFixed(1);
    final returnX = payload.returnTime == null
        ? null
        : x(payload.returnTime!).toStringAsFixed(1);
    return '''
<svg viewBox="0 0 $width $height" xmlns="http://www.w3.org/2000/svg">
  <rect x="$left" y="$veryHighY" width="${right - left}" height="${double.parse(highY) - double.parse(veryHighY)}" fill="#fdeceb"/>
  <rect x="$left" y="$highY" width="${right - left}" height="${bottom - double.parse(highY)}" fill="#fff4df"/>
  <line x1="$left" y1="$veryHighY" x2="$right" y2="$veryHighY" stroke="#dfaaa5" stroke-dasharray="6 5"/>
  <line x1="$left" y1="$highY" x2="$right" y2="$highY" stroke="#d9bf8e" stroke-dasharray="6 5"/>
  <line x1="$left" y1="$bottom" x2="$right" y2="$bottom" stroke="#dfe6e2"/>
  <polyline points="$points" fill="none" stroke="#c74742" stroke-width="5" stroke-linecap="round" stroke-linejoin="round"/>
  <line x1="$onsetX" y1="22" x2="$onsetX" y2="$bottom" stroke="#b87518" stroke-dasharray="5 5"/>
  <line x1="$peakX" y1="22" x2="$peakX" y2="$bottom" stroke="#c74742" stroke-dasharray="5 5"/>
  ${returnX == null ? '' : '<line x1="$returnX" y1="22" x2="$returnX" y2="$bottom" stroke="#1a9e5c" stroke-dasharray="5 5"/>'}
  <circle cx="$peakX" cy="$peakY" r="8" fill="#c74742" stroke="#fff" stroke-width="3"/>
  <text x="44" y="$veryHighY" text-anchor="end" fill="#61746b" font-size="11">${_threshold(payload.unit, payload.veryHighThresholdMmol)}</text>
  <text x="44" y="$highY" text-anchor="end" fill="#61746b" font-size="11">${_threshold(payload.unit, payload.highThresholdMmol)}</text>
  <text x="$left" y="236" fill="#61746b" font-size="11" text-anchor="middle">${EpisodeDetailFormatters.hm(payload.timeRangeStart)}</text>
  <text x="$right" y="236" fill="#61746b" font-size="11" text-anchor="middle">${EpisodeDetailFormatters.hm(payload.timeRangeEnd)}</text>
</svg>
''';
  }

  String _similarSvg(HighEpisodeSimilarPayload payload) {
    const left = 28.0;
    const right = 392.0;
    const top = 34.0;
    const bottom = 172.0;
    final values = payload.points.map((p) => p.valueMmol).toList();
    final minValue = values.isEmpty ? 10.0 : values.reduce(math.min) - 0.5;
    final maxValue = values.isEmpty ? 16.0 : values.reduce(math.max) + 0.5;
    double x(DateTime time) =>
        left + (right - left) * ((time.hour * 60 + time.minute) / (24 * 60));
    double y(double value) =>
        bottom -
        (bottom - top) *
            ((value - minValue) / math.max(.1, maxValue - minValue));
    final circles = payload.points.map((point) {
      final color = point.isCurrent
          ? '#c74742'
          : point.isSelected
              ? '#1a9e5c'
              : point.slowOrUnknownRecovery
                  ? '#b87518'
                  : '#7b8e85';
      final radius = (5 + math.min(point.durationMinutes, 120) / 20)
          .clamp(5, 11)
          .toStringAsFixed(1);
      return '<circle cx="${x(point.time).toStringAsFixed(1)}" cy="${y(point.valueMmol).toStringAsFixed(1)}" r="$radius" fill="$color" opacity=".82"/>';
    }).join();
    final yTop = maxValue.toStringAsFixed(1);
    final yMid = ((minValue + maxValue) / 2).toStringAsFixed(1);
    final yBottom = minValue.toStringAsFixed(1);
    return '''
<svg viewBox="0 0 410 210" xmlns="http://www.w3.org/2000/svg">
  <rect x="86" y="$top" width="78" height="${bottom - top}" rx="5" fill="#fff4df"/>
  <line x1="$left" y1="$top" x2="$right" y2="$top" stroke="#e2eae5"/>
  <line x1="$left" y1="${top + (bottom - top) * .5}" x2="$right" y2="${top + (bottom - top) * .5}" stroke="#e2eae5"/>
  <line x1="$left" y1="$bottom" x2="$right" y2="$bottom" stroke="#dfe6e2"/>
  $circles
  <text x="22" y="${top + 3}" text-anchor="end" fill="#61746b" font-size="10">$yTop</text>
  <text x="22" y="${top + (bottom - top) * .5 + 3}" text-anchor="end" fill="#61746b" font-size="10">$yMid</text>
  <text x="22" y="${bottom + 3}" text-anchor="end" fill="#61746b" font-size="10">$yBottom</text>
  <text x="$left" y="194" text-anchor="middle" fill="#61746b" font-size="10">00</text>
  <text x="${left + (right - left) * .25}" y="194" text-anchor="middle" fill="#61746b" font-size="10">06</text>
  <text x="${left + (right - left) * .5}" y="194" text-anchor="middle" fill="#61746b" font-size="10">12</text>
  <text x="${left + (right - left) * .75}" y="194" text-anchor="middle" fill="#61746b" font-size="10">18</text>
  <text x="$right" y="194" text-anchor="middle" fill="#61746b" font-size="10">24</text>
</svg>
''';
  }

  String _threshold(GlucoseUnit unit, double mmol) {
    return formatter.value(mmol, unit).valueLabel;
  }

  String _period(DateTime start, DateTime end) {
    return '${EpisodeDetailFormatters.shortDate(start)} - ${EpisodeDetailFormatters.shortDate(end)}, ${end.year}';
  }

  String _dateTime(DateTime time) {
    return '${EpisodeDetailFormatters.shortDate(time)}, ${time.year} ${EpisodeDetailFormatters.hm(time)}';
  }

  String _episodeLabel(ReportSnapshot snapshot) {
    HighEpisodeCurvePayload? curve;
    for (final section in snapshot.sections) {
      final payload = section.payload;
      if (payload is HighEpisodeCurvePayload) {
        curve = payload;
        break;
      }
    }
    if (curve == null) return _strings.episodeTimeUnavailable;
    final end = curve.returnTime ?? curve.timeRangeEnd;
    return '${EpisodeDetailFormatters.shortDate(curve.onsetTime)}, '
        '${curve.onsetTime.year} · ${EpisodeDetailFormatters.hm(curve.onsetTime)}'
        '-${EpisodeDetailFormatters.hm(end)}';
  }
}
