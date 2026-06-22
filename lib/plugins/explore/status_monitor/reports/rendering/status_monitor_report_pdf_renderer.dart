import 'dart:typed_data';

import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:smart_xdrip/reporting/domain/report_section.dart';
import 'package:smart_xdrip/reporting/domain/report_snapshot.dart';
import 'package:smart_xdrip/reporting/rendering/pdf/report_pdf_renderer.dart';

import '../status_monitor_report_payloads.dart';
import '../status_monitor_report_section_keys.dart';
import 'status_monitor_report_pdf_document_shell.dart';
import 'status_monitor_report_pdf_theme.dart';

class StatusMonitorReportPdfRenderer implements ReportPdfRenderer {
  final StatusMonitorReportPdfDocumentShell documentShell;

  const StatusMonitorReportPdfRenderer({
    this.documentShell = const StatusMonitorReportPdfDocumentShell(),
  });

  @override
  Future<Uint8List> build(ReportSnapshot snapshot) {
    return documentShell.build(
      title: snapshot.title,
      useCjkFont: _needsCjkFont(snapshot),
      children: [
        _statusHeader(snapshot.title),
        for (final section in snapshot.sections) ...[
          _section(section),
          pw.SizedBox(height: 8),
        ],
        _disclaimer(snapshot.disclaimer.text),
      ],
    );
  }

  bool _needsCjkFont(ReportSnapshot snapshot) {
    final values = [
      snapshot.title,
      snapshot.disclaimer.text,
      for (final section in snapshot.sections) section.title,
    ];
    return values.any(_hasNonAscii);
  }

  bool _hasNonAscii(String value) {
    return value.runes.any((codeUnit) => codeUnit > 0x7f);
  }

  pw.Widget _statusHeader(String title) {
    return pw.Container(
      padding: const pw.EdgeInsets.only(bottom: 10),
      margin: const pw.EdgeInsets.only(bottom: 14),
      decoration: const pw.BoxDecoration(
        border: pw.Border(
          bottom: pw.BorderSide(
            color: StatusMonitorReportPdfTheme.ink,
            width: 1.4,
          ),
        ),
      ),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          _mono('Solgo Insight', size: 8),
          _mono(title, size: 8),
        ],
      ),
    );
  }

  pw.Widget _section(ReportSection section) {
    final payload = section.payload;
    return switch (section.rendererKey) {
      StatusMonitorReportSectionKeys.hero
          when payload is StatusMonitorReportHeroPayload =>
        _hero(payload),
      StatusMonitorReportSectionKeys.meta
          when payload is StatusMonitorReportMetaPayload =>
        _meta(payload),
      StatusMonitorReportSectionKeys.supportTriage
          when payload is StatusMonitorSupportTriagePayload =>
        _supportTriage(payload),
      StatusMonitorReportSectionKeys.localCloud
          when payload is StatusMonitorLocalCloudPayload =>
        _localCloud(section.title, payload),
      StatusMonitorReportSectionKeys.dataChain
          when payload is StatusMonitorChainPayload =>
        _chain(section.title, payload),
      StatusMonitorReportSectionKeys.componentEvidence
          when payload is StatusMonitorComponentEvidencePayload =>
        _componentEvidence(section.title, payload),
      StatusMonitorReportSectionKeys.sourceCapabilities
          when payload is StatusMonitorCapabilitiesPayload =>
        _capabilities(section.title, payload),
      StatusMonitorReportSectionKeys.freshnessCompleteness
          when payload is StatusMonitorFreshnessPayload =>
        _freshness(section.title, payload),
      StatusMonitorReportSectionKeys.technicalEvidence
          when payload is StatusMonitorTechnicalEvidencePayload =>
        _technical(section.title, payload),
      StatusMonitorReportSectionKeys.firstLook
          when payload is StatusMonitorFirstLookPayload =>
        _firstLook(section.title, payload),
      _ => pw.SizedBox(),
    };
  }

  pw.Widget _hero(StatusMonitorReportHeroPayload payload) {
    return pw.Container(
      padding: const pw.EdgeInsets.only(bottom: 8),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          _mono(
            payload.eyebrow.toUpperCase(),
            color: StatusMonitorReportPdfTheme.green,
            size: 9,
            bold: true,
            letterSpacing: 1.2,
          ),
          pw.SizedBox(height: 5),
          pw.Text(
            payload.title,
            style: pw.TextStyle(
              color: StatusMonitorReportPdfTheme.ink,
              fontSize: 22,
              fontWeight: pw.FontWeight.bold,
            ),
          ),
          pw.SizedBox(height: 5),
          pw.Text(
            payload.summary,
            style: const pw.TextStyle(
              color: StatusMonitorReportPdfTheme.muted,
              fontSize: 10.5,
              lineSpacing: 3,
            ),
          ),
        ],
      ),
    );
  }

  pw.Widget _meta(StatusMonitorReportMetaPayload payload) {
    return _card(
      pw.Column(
        children: [
          pw.Row(
            children: [
              pw.Expanded(
                  child: _metaRow(payload.windowTitle, payload.windowLabel)),
              pw.SizedBox(width: 20),
              pw.Expanded(
                  child: _metaRow(payload.sourceModeTitle, payload.sourceMode)),
            ],
          ),
          pw.SizedBox(height: 6),
          pw.Row(
            children: [
              pw.Expanded(
                  child:
                      _metaRow(payload.generatedTitle, payload.generatedLabel)),
              pw.SizedBox(width: 20),
              pw.Expanded(
                  child: _metaRow(payload.privacyTitle, payload.privacyLabel)),
            ],
          ),
        ],
      ),
    );
  }

  pw.Widget _metaRow(String label, String value) {
    return pw.Row(
      children: [
        pw.SizedBox(
          width: 74,
          child: _mono(label, size: 8.2, bold: true),
        ),
        pw.SizedBox(width: 8),
        pw.Expanded(
          child: _mono(
            value,
            size: 8.6,
            color: StatusMonitorReportPdfTheme.ink,
            bold: true,
          ),
        ),
      ],
    );
  }

  pw.Widget _supportTriage(StatusMonitorSupportTriagePayload payload) {
    return pw.Row(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Expanded(
          flex: 11,
          child: _card(
            pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                _mono(
                  payload.label.toUpperCase(),
                  size: 7.8,
                  bold: true,
                  color: StatusMonitorReportPdfTheme.amber,
                ),
                pw.SizedBox(height: 5),
                pw.Text(
                  payload.title,
                  style: pw.TextStyle(
                    color: StatusMonitorReportPdfTheme.ink,
                    fontSize: 16,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
                pw.SizedBox(height: 5),
                _body(payload.body, size: 9.3),
                pw.SizedBox(height: 9),
                _supportReasonGrid(payload.reasons),
              ],
            ),
          ),
        ),
        pw.SizedBox(width: 12),
        pw.Expanded(
          flex: 9,
          child: pw.Column(
            children: [
              _card(
                pw.Row(
                  children: [
                    _scoreRing(payload.evidenceScore),
                    pw.SizedBox(width: 12),
                    pw.Expanded(
                      child: pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          _mono(
                            payload.evidenceScoreTitle.toUpperCase(),
                            size: 8,
                            bold: true,
                          ),
                          pw.SizedBox(height: 4),
                          pw.Text(
                            payload.evidenceScore.label,
                            style: pw.TextStyle(
                              color: StatusMonitorReportPdfTheme.tone(
                                payload.evidenceScore.tone,
                              ),
                              fontSize: 17,
                              fontWeight: pw.FontWeight.bold,
                            ),
                          ),
                          pw.SizedBox(height: 4),
                          _body(payload.evidenceScore.body, size: 9),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              pw.SizedBox(height: 8),
              _copyBox(
                text: payload.communityCopy.text,
                title: payload.communityCopyTitle,
                privacyLabel: payload.privacySafeLabel,
              ),
            ],
          ),
        ),
      ],
    );
  }

  pw.Widget _supportReasonGrid(
    List<StatusMonitorSupportReasonPayload> reasons,
  ) {
    return pw.Row(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        for (final reason in reasons) ...[
          pw.Expanded(
            child: pw.Container(
              padding: const pw.EdgeInsets.all(7),
              decoration: pw.BoxDecoration(
                color: StatusMonitorReportPdfTheme.panel,
                borderRadius: pw.BorderRadius.circular(6),
                border: pw.Border.all(color: StatusMonitorReportPdfTheme.line),
              ),
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  _mono(
                    reason.title,
                    size: 7.9,
                    bold: true,
                    color: StatusMonitorReportPdfTheme.ink,
                  ),
                  pw.SizedBox(height: 3),
                  _body(reason.body, size: 7.7),
                ],
              ),
            ),
          ),
          if (reason != reasons.last) pw.SizedBox(width: 7),
        ],
      ],
    );
  }

  pw.Widget _copyBox({
    required String text,
    required String title,
    required String privacyLabel,
  }) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(9),
      decoration: pw.BoxDecoration(
        color: StatusMonitorReportPdfTheme.panel2,
        borderRadius: pw.BorderRadius.circular(6),
        border: pw.Border.all(
          color: const PdfColor.fromInt(0xffcbd7d0),
          width: .8,
        ),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Row(
            children: [
              pw.Expanded(
                child: _mono(
                  title.toUpperCase(),
                  size: 7.3,
                  bold: true,
                ),
              ),
              _mono(privacyLabel.toUpperCase(), size: 7.3, bold: true),
            ],
          ),
          pw.SizedBox(height: 6),
          _mono(
            text,
            size: 7.8,
            color: const PdfColor.fromInt(0xff385748),
          ),
        ],
      ),
    );
  }

  pw.Widget _scoreRing(StatusMonitorScorePayload score) {
    return pw.Container(
      width: 76,
      height: 76,
      decoration: pw.BoxDecoration(
        shape: pw.BoxShape.circle,
        border: pw.Border.all(
          color: StatusMonitorReportPdfTheme.tone(score.tone),
          width: 8,
        ),
      ),
      child: pw.Center(
        child: _mono(
          score.value,
          size: 22,
          bold: true,
          color: StatusMonitorReportPdfTheme.tone(score.tone),
        ),
      ),
    );
  }

  pw.Widget _localCloud(
    String title,
    StatusMonitorLocalCloudPayload payload,
  ) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.stretch,
      children: [
        _sectionTitle('01', title, payload.trailing),
        _card(
          pw.Column(
            children: [
              pw.Row(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Expanded(child: _streamCard(payload.local)),
                  pw.SizedBox(width: 10),
                  pw.Expanded(child: _streamCard(payload.cloud)),
                ],
              ),
              pw.SizedBox(height: 7),
              _probeTable(payload.rows),
            ],
          ),
        ),
      ],
    );
  }

  pw.Widget _streamCard(StatusMonitorStreamComparisonPayload stream) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(9),
      decoration: pw.BoxDecoration(
        color: StatusMonitorReportPdfTheme.panel,
        borderRadius: pw.BorderRadius.circular(6),
        border: pw.Border.all(color: StatusMonitorReportPdfTheme.line),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            stream.title,
            style: pw.TextStyle(
              color: StatusMonitorReportPdfTheme.ink,
              fontSize: 11,
              fontWeight: pw.FontWeight.bold,
            ),
          ),
          pw.SizedBox(height: 2),
          _mono(stream.role.toUpperCase(), size: 7.2, bold: true),
          pw.SizedBox(height: 8),
          _mono(
            stream.value,
            size: 20,
            bold: true,
            color: StatusMonitorReportPdfTheme.tone(stream.tone),
          ),
          pw.SizedBox(height: 4),
          _body(stream.body, size: 8.5),
        ],
      ),
    );
  }

  pw.Widget _probeTable(List<StatusMonitorProbeRowPayload> rows) {
    return pw.Column(
      children: [
        for (final row in rows)
          pw.Container(
            padding: const pw.EdgeInsets.symmetric(vertical: 5),
            decoration: const pw.BoxDecoration(
              border: pw.Border(
                top: pw.BorderSide(color: PdfColor.fromInt(0xffedf2ef)),
              ),
            ),
            child: pw.Row(
              children: [
                pw.Expanded(child: _body(row.label, size: 8.8)),
                pw.SizedBox(width: 10),
                _mono(
                  row.value,
                  size: 8.4,
                  bold: true,
                  color: StatusMonitorReportPdfTheme.tone(row.tone),
                ),
              ],
            ),
          ),
      ],
    );
  }

  pw.Widget _chain(String title, StatusMonitorChainPayload payload) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.stretch,
      children: [
        _sectionTitle('02', title, payload.trailing),
        _card(
          pw.Row(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              for (final node in payload.nodes) ...[
                pw.Expanded(child: _chainNode(node)),
                if (node != payload.nodes.last) pw.SizedBox(width: 8),
              ],
            ],
          ),
        ),
      ],
    );
  }

  pw.Widget _chainNode(StatusMonitorChainNodePayload node) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(8),
      decoration: pw.BoxDecoration(
        color: StatusMonitorReportPdfTheme.panel,
        borderRadius: pw.BorderRadius.circular(6),
        border: pw.Border.all(color: StatusMonitorReportPdfTheme.line),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            node.title,
            style: pw.TextStyle(fontSize: 10.5, fontWeight: pw.FontWeight.bold),
          ),
          pw.SizedBox(height: 2),
          _mono(node.role.toUpperCase(), size: 7.2, bold: true),
          pw.SizedBox(height: 7),
          _pill(node.state, node.tone),
          pw.SizedBox(height: 5),
          _body(node.body, size: 8.5),
        ],
      ),
    );
  }

  pw.Widget _componentEvidence(
    String title,
    StatusMonitorComponentEvidencePayload payload,
  ) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.stretch,
      children: [
        _sectionTitle('03', title, null),
        _card(
          pw.Table(
            border: const pw.TableBorder(
              horizontalInside: pw.BorderSide(
                color: PdfColor.fromInt(0xffedf2ef),
                width: .7,
              ),
            ),
            columnWidths: const {
              0: pw.FlexColumnWidth(1.3),
              1: pw.FlexColumnWidth(.8),
              2: pw.FlexColumnWidth(1.6),
              3: pw.FlexColumnWidth(.8),
              4: pw.FlexColumnWidth(2.2),
            },
            children: [
              pw.TableRow(
                children: [
                  _th(payload.componentTitle),
                  _th(payload.statusTitle),
                  _th(payload.takeawayTitle),
                  _th(payload.checksTitle),
                  _th(payload.evidenceTitle),
                ],
              ),
              for (final row in payload.rows)
                pw.TableRow(
                  children: [
                    _td('${row.component}\n${row.role}', boldFirst: true),
                    _td(row.status,
                        color: StatusMonitorReportPdfTheme.tone(row.tone)),
                    _td(row.takeaway),
                    _td(row.checks),
                    _td(row.evidence),
                  ],
                ),
            ],
          ),
        ),
      ],
    );
  }

  pw.Widget _capabilities(
    String title,
    StatusMonitorCapabilitiesPayload payload,
  ) {
    final rows = <List<StatusMonitorCapabilityTilePayload>>[];
    for (var index = 0; index < payload.tiles.length; index += 4) {
      rows.add(payload.tiles.skip(index).take(4).toList());
    }
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.stretch,
      children: [
        _sectionTitle('05', title, payload.trailing),
        _card(
          pw.Column(
            children: [
              for (final row in rows) ...[
                pw.Row(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    for (var i = 0; i < 4; i++) ...[
                      pw.Expanded(
                        child: i < row.length
                            ? _capabilityTile(row[i])
                            : pw.SizedBox(),
                      ),
                      if (i != 3) pw.SizedBox(width: 8),
                    ],
                  ],
                ),
                if (row != rows.last) pw.SizedBox(height: 8),
              ],
            ],
          ),
        ),
      ],
    );
  }

  pw.Widget _capabilityTile(StatusMonitorCapabilityTilePayload tile) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(7),
      decoration: pw.BoxDecoration(
        color: StatusMonitorReportPdfTheme.panel,
        borderRadius: pw.BorderRadius.circular(6),
        border: pw.Border.all(color: StatusMonitorReportPdfTheme.line),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          _mono(
            tile.label,
            size: 8.5,
            bold: true,
            color: StatusMonitorReportPdfTheme.ink,
          ),
          pw.SizedBox(height: 3),
          _body(tile.value, size: 8),
        ],
      ),
    );
  }

  pw.Widget _freshness(String title, StatusMonitorFreshnessPayload payload) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.stretch,
      children: [
        _sectionTitle('04', title, payload.trailing),
        _card(
          pw.Column(
            children: [
              pw.Row(
                children: [
                  for (final tick in payload.ticks) ...[
                    pw.Expanded(
                      child: pw.Container(
                        height: 22,
                        decoration: pw.BoxDecoration(
                          color: StatusMonitorReportPdfTheme.timelineToneBg(
                            tick.tone,
                          ),
                          borderRadius: pw.BorderRadius.circular(2),
                          border: pw.Border.all(
                            color:
                                StatusMonitorReportPdfTheme.timelineToneBorder(
                              tick.tone,
                            ),
                            width: .6,
                          ),
                        ),
                      ),
                    ),
                    if (tick != payload.ticks.last) pw.SizedBox(width: 2),
                  ],
                ],
              ),
              pw.SizedBox(height: 7),
              _timelineLegend(payload),
              pw.SizedBox(height: 8),
              for (final row in payload.rows)
                pw.Container(
                  padding: const pw.EdgeInsets.symmetric(vertical: 5),
                  decoration: const pw.BoxDecoration(
                    border: pw.Border(
                      top: pw.BorderSide(color: PdfColor.fromInt(0xffedf2ef)),
                    ),
                  ),
                  child: pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      _body(row.label, size: 9.5),
                      _mono(
                        row.value,
                        size: 9,
                        bold: true,
                        color: StatusMonitorReportPdfTheme.tone(row.tone),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }

  pw.Widget _technical(
    String title,
    StatusMonitorTechnicalEvidencePayload payload,
  ) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.stretch,
      children: [
        _sectionTitle('06', title, null),
        _card(
          pw.Row(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Expanded(
                child: _listBlock(payload.observedTitle, payload.observedFacts),
              ),
              pw.SizedBox(width: 12),
              pw.Expanded(
                child: _listBlock(payload.limitsTitle, payload.limits),
              ),
            ],
          ),
        ),
      ],
    );
  }

  pw.Widget _timelineLegend(StatusMonitorFreshnessPayload payload) {
    final items = [
      ('ok', payload.currentLegendLabel),
      ('watch', payload.partialLegendLabel),
      ('issue', payload.gapLegendLabel),
    ];
    return pw.Row(
      children: [
        for (final item in items) ...[
          pw.Container(
            width: 7,
            height: 7,
            decoration: pw.BoxDecoration(
              color: StatusMonitorReportPdfTheme.timelineToneBg(item.$1),
              borderRadius: pw.BorderRadius.circular(2),
              border: pw.Border.all(
                color: StatusMonitorReportPdfTheme.timelineToneBorder(item.$1),
              ),
            ),
          ),
          pw.SizedBox(width: 4),
          _mono(item.$2.toUpperCase(), size: 6.8, bold: true),
          pw.SizedBox(width: 10),
        ],
      ],
    );
  }

  pw.Widget _firstLook(String title, StatusMonitorFirstLookPayload payload) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.stretch,
      children: [
        _sectionTitle('07', title, null),
        _card(
          pw.Column(
            children: [
              for (final finding in payload.findings)
                _finding(finding.title, finding.body, finding.tone),
            ],
          ),
        ),
      ],
    );
  }

  pw.Widget _finding(String title, String body, String tone) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 6),
      child: pw.Row(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Container(
            width: 8,
            height: 8,
            margin: const pw.EdgeInsets.only(top: 4),
            decoration: pw.BoxDecoration(
              shape: pw.BoxShape.circle,
              color: StatusMonitorReportPdfTheme.tone(tone),
            ),
          ),
          pw.SizedBox(width: 9),
          pw.Expanded(
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text(
                  title,
                  style: pw.TextStyle(
                      fontSize: 11, fontWeight: pw.FontWeight.bold),
                ),
                pw.SizedBox(height: 2),
                _body(body, size: 9.5),
              ],
            ),
          ),
        ],
      ),
    );
  }

  pw.Widget _listBlock(String title, List<String> items) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          title,
          style: pw.TextStyle(fontSize: 11, fontWeight: pw.FontWeight.bold),
        ),
        pw.SizedBox(height: 5),
        for (final item in items)
          pw.Padding(
            padding: const pw.EdgeInsets.only(bottom: 3),
            child: _body('- $item', size: 9.5),
          ),
      ],
    );
  }

  pw.Widget _sectionTitle(String number, String title, String? trailing) {
    return pw.Container(
      margin: const pw.EdgeInsets.fromLTRB(0, 8, 0, 8),
      padding: const pw.EdgeInsets.only(bottom: 4),
      decoration: const pw.BoxDecoration(
        border: pw.Border(
          bottom: pw.BorderSide(color: StatusMonitorReportPdfTheme.line),
        ),
      ),
      child: pw.Row(
        children: [
          pw.Expanded(
            child: pw.RichText(
              text: pw.TextSpan(
                children: [
                  pw.TextSpan(
                    text: '$number ',
                    style: pw.TextStyle(
                      color: StatusMonitorReportPdfTheme.green,
                      fontSize: 8.5,
                      fontWeight: pw.FontWeight.bold,
                      letterSpacing: 1.2,
                    ),
                  ),
                  pw.TextSpan(
                    text: title.toUpperCase(),
                    style: pw.TextStyle(
                      color: StatusMonitorReportPdfTheme.muted,
                      fontSize: 8.5,
                      fontWeight: pw.FontWeight.bold,
                      letterSpacing: 1.2,
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (trailing != null) _mono(trailing, size: 8),
        ],
      ),
    );
  }

  pw.Widget _card(pw.Widget child) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(10),
      decoration: pw.BoxDecoration(
        color: StatusMonitorReportPdfTheme.panel2,
        borderRadius: pw.BorderRadius.circular(6),
        border: pw.Border.all(color: StatusMonitorReportPdfTheme.line),
      ),
      child: child,
    );
  }

  pw.Widget _pill(String text, String tone) {
    return pw.Container(
      padding: const pw.EdgeInsets.symmetric(horizontal: 6, vertical: 3),
      decoration: pw.BoxDecoration(
        color: StatusMonitorReportPdfTheme.toneBg(tone),
        borderRadius: pw.BorderRadius.circular(99),
        border: pw.Border.all(color: StatusMonitorReportPdfTheme.line),
      ),
      child: _mono(
        text.toUpperCase(),
        size: 7.4,
        bold: true,
        color: StatusMonitorReportPdfTheme.tone(tone),
      ),
    );
  }

  pw.Widget _th(String text) {
    return pw.Padding(
      padding: const pw.EdgeInsets.fromLTRB(4, 0, 4, 5),
      child: _mono(text.toUpperCase(), size: 7.5, bold: true),
    );
  }

  pw.Widget _td(String text, {PdfColor? color, bool boldFirst = false}) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(horizontal: 4, vertical: 5),
      child: pw.Text(
        text,
        style: pw.TextStyle(
          color: color ?? StatusMonitorReportPdfTheme.muted,
          fontSize: 8,
          fontWeight: boldFirst ? pw.FontWeight.bold : pw.FontWeight.normal,
          lineSpacing: 2,
        ),
      ),
    );
  }

  pw.Widget _disclaimer(String text) {
    return pw.Container(
      margin: const pw.EdgeInsets.only(top: 8),
      padding: const pw.EdgeInsets.only(top: 8),
      decoration: const pw.BoxDecoration(
        border: pw.Border(
          top: pw.BorderSide(color: StatusMonitorReportPdfTheme.line),
        ),
      ),
      child: _mono(text, size: 7.5),
    );
  }

  pw.Widget _body(String text, {double size = 10}) {
    return pw.Text(
      text,
      style: pw.TextStyle(
        color: StatusMonitorReportPdfTheme.muted,
        fontSize: size,
        lineSpacing: 3,
      ),
    );
  }

  pw.Widget _mono(
    String text, {
    double size = 8,
    PdfColor color = StatusMonitorReportPdfTheme.muted,
    bool bold = false,
    double? letterSpacing,
    pw.TextAlign? align,
  }) {
    return pw.Text(
      text,
      textAlign: align,
      style: pw.TextStyle(
        color: color,
        fontSize: size,
        fontWeight: bold ? pw.FontWeight.bold : pw.FontWeight.normal,
        letterSpacing: letterSpacing,
      ),
    );
  }
}
