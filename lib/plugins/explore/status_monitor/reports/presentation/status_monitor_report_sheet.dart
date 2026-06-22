import 'package:flutter/material.dart';
import 'package:smart_xdrip/reporting/domain/report_snapshot.dart';

import '../../application/i18n/status_monitor_l10n.dart';
import '../status_monitor_report_payloads.dart';
import '../status_monitor_report_section_keys.dart';

class StatusMonitorReportSheet extends StatelessWidget {
  final ReportSnapshot snapshot;

  const StatusMonitorReportSheet({super.key, required this.snapshot});

  static const _sheet = Colors.white;
  static const _panel = Color(0xfffbfcfb);
  static const _panel2 = Color(0xfff7f9f8);
  static const _ink = Color(0xff15201a);
  static const _muted = Color(0xff61746b);
  static const _line = Color(0xffdfe6e2);
  static const _green = Color(0xff1a9e5c);
  static const _amber = Color(0xffb87518);
  static const _rose = Color(0xffc74742);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final horizontalPadding = width < 430
            ? 14.0
            : width < 640
                ? 22.0
                : 36.0;
        return ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 794),
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: _sheet,
              boxShadow: const [
                BoxShadow(
                  color: Color(0x22000000),
                  blurRadius: 22,
                  offset: Offset(0, 12),
                ),
              ],
            ),
            child: Padding(
              padding: EdgeInsets.fromLTRB(
                  horizontalPadding, 28, horizontalPadding, 28),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _statusHeader(context),
                  for (final section in snapshot.sections) ...[
                    _section(section.rendererKey, section.payload),
                    const SizedBox(height: 10),
                  ],
                  _privacy(snapshot.disclaimer.text),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _section(String key, Object? payload) {
    if (key == StatusMonitorReportSectionKeys.hero &&
        payload is StatusMonitorReportHeroPayload) {
      return _Hero(payload);
    }
    if (key == StatusMonitorReportSectionKeys.meta &&
        payload is StatusMonitorReportMetaPayload) {
      return _Meta(payload);
    }
    if (key == StatusMonitorReportSectionKeys.supportTriage &&
        payload is StatusMonitorSupportTriagePayload) {
      return _SupportTriage(payload);
    }
    if (key == StatusMonitorReportSectionKeys.localCloud &&
        payload is StatusMonitorLocalCloudPayload) {
      return _LocalCloud(payload);
    }
    if (key == StatusMonitorReportSectionKeys.dataChain &&
        payload is StatusMonitorChainPayload) {
      return _Chain(payload);
    }
    if (key == StatusMonitorReportSectionKeys.componentEvidence &&
        payload is StatusMonitorComponentEvidencePayload) {
      return _ComponentEvidence(payload);
    }
    if (key == StatusMonitorReportSectionKeys.sourceCapabilities &&
        payload is StatusMonitorCapabilitiesPayload) {
      return _Capabilities(payload);
    }
    if (key == StatusMonitorReportSectionKeys.freshnessCompleteness &&
        payload is StatusMonitorFreshnessPayload) {
      return _Freshness(payload);
    }
    if (key == StatusMonitorReportSectionKeys.technicalEvidence &&
        payload is StatusMonitorTechnicalEvidencePayload) {
      return _Technical(payload);
    }
    if (key == StatusMonitorReportSectionKeys.firstLook &&
        payload is StatusMonitorFirstLookPayload) {
      return _FirstLook(payload);
    }
    return const SizedBox.shrink();
  }

  Widget _statusHeader(BuildContext context) {
    final l10n = context.statusMonitorL10n;
    return Container(
      padding: const EdgeInsets.only(bottom: 10),
      margin: const EdgeInsets.only(bottom: 14),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: _ink, width: 1.4)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _Mono(l10n.reportHeaderBrand, size: 9),
          _Mono(l10n.reportSupportTitle, size: 9),
        ],
      ),
    );
  }

  Widget _privacy(String text) {
    return Container(
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.only(top: 8),
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: _line)),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: _muted,
          fontFamily: 'JetBrains Mono',
          fontSize: 8,
          height: 1.45,
        ),
      ),
    );
  }

  static Color tone(String tone) {
    return switch (tone) {
      'ok' => _green,
      'watch' => _amber,
      'issue' => _rose,
      _ => _muted,
    };
  }

  static Color toneBg(String tone) {
    return switch (tone) {
      'ok' => const Color(0xffedf7f0),
      'watch' => const Color(0xfffff7e8),
      'issue' => const Color(0xfffff0ef),
      _ => const Color(0xfff1f4f2),
    };
  }

  static Color timelineToneBg(String tone) {
    return switch (tone) {
      'ok' => const Color(0xffcdeed8),
      'watch' => const Color(0xffffdda3),
      'issue' => const Color(0xffffc6c2),
      _ => const Color(0xffe2e9e5),
    };
  }

  static Color timelineToneBorder(String tone) {
    return switch (tone) {
      'ok' => const Color(0xff8fd4a6),
      'watch' => const Color(0xffe7b64f),
      'issue' => const Color(0xffe68d87),
      _ => const Color(0xffc8d4ce),
    };
  }
}

class _Hero extends StatelessWidget {
  final StatusMonitorReportHeroPayload payload;

  const _Hero(this.payload);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            payload.eyebrow.toUpperCase(),
            style: const TextStyle(
              color: StatusMonitorReportSheet._green,
              fontSize: 9,
              fontFamily: 'JetBrains Mono',
              fontWeight: FontWeight.w900,
              letterSpacing: 1.4,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            payload.title,
            style: const TextStyle(
              color: StatusMonitorReportSheet._ink,
              fontSize: 22,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            payload.summary,
            style: const TextStyle(
              color: StatusMonitorReportSheet._muted,
              fontSize: 11,
              height: 1.55,
            ),
          ),
        ],
      ),
    );
  }
}

class _Meta extends StatelessWidget {
  final StatusMonitorReportMetaPayload payload;

  const _Meta(this.payload);

  @override
  Widget build(BuildContext context) {
    return _Card(
      child: LayoutBuilder(
        builder: (context, constraints) {
          final rows = [
            _MetaRow(payload.windowTitle, payload.windowLabel),
            _MetaRow(payload.sourceModeTitle, payload.sourceMode),
            _MetaRow(payload.generatedTitle, payload.generatedLabel),
            _MetaRow(payload.privacyTitle, payload.privacyLabel),
          ];
          if (constraints.maxWidth < 460) return Column(children: rows);
          return Column(
            children: [
              Row(children: [
                Expanded(child: rows[0]),
                const SizedBox(width: 18),
                Expanded(child: rows[1])
              ]),
              Row(children: [
                Expanded(child: rows[2]),
                const SizedBox(width: 18),
                Expanded(child: rows[3])
              ]),
            ],
          );
        },
      ),
    );
  }
}

class _SupportTriage extends StatelessWidget {
  final StatusMonitorSupportTriagePayload payload;

  const _SupportTriage(this.payload);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final firstLook = _Card(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _Mono(payload.label.toUpperCase(),
                  size: 8, bold: true, color: StatusMonitorReportSheet._amber),
              const SizedBox(height: 5),
              Text(
                payload.title,
                style: const TextStyle(
                  color: StatusMonitorReportSheet._ink,
                  fontSize: 17,
                  fontWeight: FontWeight.w900,
                  height: 1.2,
                ),
              ),
              const SizedBox(height: 6),
              _Body(payload.body),
              const SizedBox(height: 10),
              _ReasonGrid(payload.reasons),
            ],
          ),
        );
        final scoreAndCopy = Column(
          children: [
            _Card(
              child: Row(
                children: [
                  _ScoreRing(payload.evidenceScore),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _Mono(
                          payload.evidenceScoreTitle.toUpperCase(),
                          size: 8,
                          bold: true,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          payload.evidenceScore.label,
                          style: TextStyle(
                            color: StatusMonitorReportSheet.tone(
                                payload.evidenceScore.tone),
                            fontSize: 18,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        const SizedBox(height: 4),
                        _Body(payload.evidenceScore.body),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            _CopyBox(
              text: payload.communityCopy.text,
              title: payload.communityCopyTitle,
              privacyLabel: payload.privacySafeLabel,
            ),
          ],
        );
        if (constraints.maxWidth < 560) {
          return Column(
            children: [firstLook, const SizedBox(height: 10), scoreAndCopy],
          );
        }
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(flex: 11, child: firstLook),
            const SizedBox(width: 12),
            Expanded(flex: 9, child: scoreAndCopy),
          ],
        );
      },
    );
  }
}

class _ReasonGrid extends StatelessWidget {
  final List<StatusMonitorSupportReasonPayload> reasons;

  const _ReasonGrid(this.reasons);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final columns = constraints.maxWidth < 420 ? 1 : 3;
        final width = (constraints.maxWidth - (columns - 1) * 7) / columns;
        return Wrap(
          spacing: 7,
          runSpacing: 7,
          children: [
            for (final reason in reasons)
              SizedBox(
                width: width,
                child: Container(
                  padding: const EdgeInsets.all(7),
                  decoration: BoxDecoration(
                    color: StatusMonitorReportSheet._panel,
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: StatusMonitorReportSheet._line),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _Mono(reason.title,
                          size: 8.6,
                          bold: true,
                          color: StatusMonitorReportSheet._ink),
                      const SizedBox(height: 3),
                      _TableBody(reason.body),
                    ],
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}

class _CopyBox extends StatelessWidget {
  final String text;
  final String title;
  final String privacyLabel;

  const _CopyBox({
    required this.text,
    required this.title,
    required this.privacyLabel,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: StatusMonitorReportSheet._panel2,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: const Color(0xffcbd7d0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: _Mono(title.toUpperCase(), size: 7.5, bold: true),
              ),
              _Mono(privacyLabel.toUpperCase(), size: 7.5, bold: true),
            ],
          ),
          const SizedBox(height: 7),
          _Mono(text, size: 8.3, color: Color(0xff385748)),
        ],
      ),
    );
  }
}

class _LocalCloud extends StatelessWidget {
  final StatusMonitorLocalCloudPayload payload;

  const _LocalCloud(this.payload);

  @override
  Widget build(BuildContext context) {
    final l10n = context.statusMonitorL10n;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _SectionTitle('01', l10n.reportLocalCloudFreshness, payload.trailing),
        _Card(
          child: Column(
            children: [
              LayoutBuilder(
                builder: (context, constraints) {
                  final local = _StreamCard(payload.local);
                  final cloud = _StreamCard(payload.cloud);
                  if (constraints.maxWidth < 520) {
                    return Column(
                      children: [local, const SizedBox(height: 10), cloud],
                    );
                  }
                  return Row(
                    children: [
                      Expanded(child: local),
                      const SizedBox(width: 10),
                      Expanded(child: cloud),
                    ],
                  );
                },
              ),
              const SizedBox(height: 8),
              _ProbeTable(payload.rows),
            ],
          ),
        ),
      ],
    );
  }
}

class _StreamCard extends StatelessWidget {
  final StatusMonitorStreamComparisonPayload stream;

  const _StreamCard(this.stream);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: StatusMonitorReportSheet._panel,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: StatusMonitorReportSheet._line),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            stream.title,
            style: const TextStyle(
              color: StatusMonitorReportSheet._ink,
              fontSize: 12,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 2),
          _Mono(stream.role.toUpperCase(), size: 7.5, bold: true),
          const SizedBox(height: 9),
          _Mono(
            stream.value,
            size: 22,
            bold: true,
            color: StatusMonitorReportSheet.tone(stream.tone),
          ),
          const SizedBox(height: 5),
          _Body(stream.body),
        ],
      ),
    );
  }
}

class _ProbeTable extends StatelessWidget {
  final List<StatusMonitorProbeRowPayload> rows;

  const _ProbeTable(this.rows);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (final row in rows)
          Container(
            padding: const EdgeInsets.symmetric(vertical: 6),
            decoration: const BoxDecoration(
              border: Border(top: BorderSide(color: Color(0xffedf2ef))),
            ),
            child: Row(
              children: [
                Expanded(child: _Body(row.label)),
                const SizedBox(width: 12),
                Flexible(
                  child: _Mono(
                    row.value,
                    size: 8.8,
                    bold: true,
                    color: StatusMonitorReportSheet.tone(row.tone),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}

class _Chain extends StatelessWidget {
  final StatusMonitorChainPayload payload;

  const _Chain(this.payload);

  @override
  Widget build(BuildContext context) {
    final l10n = context.statusMonitorL10n;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _SectionTitle('02', l10n.reportDataChainSnapshot, payload.trailing),
        _Card(
            child: _ResponsiveWrap(
                children: [for (final n in payload.nodes) _ChainNode(n)])),
      ],
    );
  }
}

class _ComponentEvidence extends StatelessWidget {
  final StatusMonitorComponentEvidencePayload payload;

  const _ComponentEvidence(this.payload);

  @override
  Widget build(BuildContext context) {
    final l10n = context.statusMonitorL10n;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _SectionTitle(
          '03',
          l10n.reportComponentEvidence,
          l10n.reportMatchesComponents,
        ),
        _Card(
          child: Column(
            children: [
              _ComponentEvidenceHeader(payload),
              for (final row in payload.rows)
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 7),
                  decoration: const BoxDecoration(
                    border: Border(
                      bottom: BorderSide(color: Color(0xffedf2ef)),
                    ),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 13,
                        child: Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: _TableComponentName(row.component, row.role),
                        ),
                      ),
                      Expanded(
                        flex: 8,
                        child: Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: Text(
                            row.status,
                            style: TextStyle(
                              color: StatusMonitorReportSheet.tone(row.tone),
                              fontSize: 8.5,
                              fontWeight: FontWeight.w900,
                              height: 1.25,
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 17,
                        child: Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: _TableBody(row.takeaway),
                        ),
                      ),
                      Expanded(
                        flex: 9,
                        child: Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: _Mono(row.checks, size: 7.5, bold: true),
                        ),
                      ),
                      Expanded(flex: 19, child: _TableBody(row.evidence)),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}

class _Capabilities extends StatelessWidget {
  final StatusMonitorCapabilitiesPayload payload;

  const _Capabilities(this.payload);

  @override
  Widget build(BuildContext context) {
    final l10n = context.statusMonitorL10n;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _SectionTitle('05', l10n.reportSourceCapabilities, payload.trailing),
        _Card(
            child: _ResponsiveWrap(
                children: [for (final t in payload.tiles) _CapTile(t)])),
      ],
    );
  }
}

class _Freshness extends StatelessWidget {
  final StatusMonitorFreshnessPayload payload;

  const _Freshness(this.payload);

  @override
  Widget build(BuildContext context) {
    final l10n = context.statusMonitorL10n;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _SectionTitle(
          '04',
          l10n.reportFreshnessCompleteness,
          payload.trailing,
        ),
        _Card(
          child: Column(
            children: [
              Row(
                children: [
                  for (final tick in payload.ticks) ...[
                    Expanded(
                      child: Container(
                        height: 24,
                        decoration: BoxDecoration(
                          color: StatusMonitorReportSheet.timelineToneBg(
                              tick.tone),
                          borderRadius: BorderRadius.circular(2),
                          border: Border.all(
                            color: StatusMonitorReportSheet.timelineToneBorder(
                              tick.tone,
                            ),
                            width: 0.8,
                          ),
                        ),
                      ),
                    ),
                    if (tick != payload.ticks.last) const SizedBox(width: 2),
                  ],
                ],
              ),
              const SizedBox(height: 8),
              _TimelineLegend(payload),
              const SizedBox(height: 8),
              for (final row in payload.rows)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _Body(row.label),
                      _Mono(row.value,
                          size: 9,
                          bold: true,
                          color: StatusMonitorReportSheet.tone(row.tone)),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}

class _Technical extends StatelessWidget {
  final StatusMonitorTechnicalEvidencePayload payload;

  const _Technical(this.payload);

  @override
  Widget build(BuildContext context) {
    final l10n = context.statusMonitorL10n;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _SectionTitle(
          '06',
          l10n.reportTechnicalEvidence,
          l10n.reportSafeToShare,
        ),
        _Card(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final observed =
                  _ListBlock(payload.observedTitle, payload.observedFacts);
              final limits = _ListBlock(payload.limitsTitle, payload.limits);
              if (constraints.maxWidth < 520) {
                return Column(
                    children: [observed, const SizedBox(height: 10), limits]);
              }
              return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(child: observed),
                    const SizedBox(width: 12),
                    Expanded(child: limits)
                  ]);
            },
          ),
        ),
      ],
    );
  }
}

class _TimelineLegend extends StatelessWidget {
  final StatusMonitorFreshnessPayload payload;

  const _TimelineLegend(this.payload);

  @override
  Widget build(BuildContext context) {
    final items = [
      ('ok', payload.currentLegendLabel),
      ('watch', payload.partialLegendLabel),
      ('issue', payload.gapLegendLabel),
    ];
    return Row(
      children: [
        for (final item in items) ...[
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: StatusMonitorReportSheet.timelineToneBg(item.$1),
              borderRadius: BorderRadius.circular(2),
              border: Border.all(
                color: StatusMonitorReportSheet.timelineToneBorder(item.$1),
              ),
            ),
          ),
          const SizedBox(width: 4),
          _Mono(item.$2.toUpperCase(), size: 7.3, bold: true),
          const SizedBox(width: 10),
        ],
      ],
    );
  }
}

class _FirstLook extends StatelessWidget {
  final StatusMonitorFirstLookPayload payload;

  const _FirstLook(this.payload);

  @override
  Widget build(BuildContext context) {
    final l10n = context.statusMonitorL10n;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _SectionTitle('07', l10n.reportSuggestedFirstLook, null),
        _Card(
            child: Column(
                children: [for (final f in payload.findings) _Finding(f)])),
      ],
    );
  }
}

class _ResponsiveWrap extends StatelessWidget {
  final List<Widget> children;

  const _ResponsiveWrap({required this.children});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final columns = constraints.maxWidth < 430
            ? 1
            : constraints.maxWidth < 620
                ? 2
                : 4;
        final width = (constraints.maxWidth - (columns - 1) * 8) / columns;
        return Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            for (final child in children) SizedBox(width: width, child: child)
          ],
        );
      },
    );
  }
}

class _ChainNode extends StatelessWidget {
  final StatusMonitorChainNodePayload node;

  const _ChainNode(this.node);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(9),
      decoration: BoxDecoration(
        color: StatusMonitorReportSheet._panel,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: StatusMonitorReportSheet._line),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(node.title,
              style: const TextStyle(
                color: StatusMonitorReportSheet._ink,
                fontSize: 11,
                fontWeight: FontWeight.w900,
              )),
          const SizedBox(height: 2),
          _Mono(node.role.toUpperCase(), size: 8, bold: true),
          const SizedBox(height: 7),
          _Pill(node.state, node.tone),
          const SizedBox(height: 5),
          _Body(node.body),
        ],
      ),
    );
  }
}

class _CapTile extends StatelessWidget {
  final StatusMonitorCapabilityTilePayload tile;

  const _CapTile(this.tile);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: StatusMonitorReportSheet._panel,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: StatusMonitorReportSheet._line),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _Mono(tile.label,
              size: 10, bold: true, color: StatusMonitorReportSheet._ink),
          const SizedBox(height: 3),
          _Body(tile.value),
        ],
      ),
    );
  }
}

class _ComponentEvidenceHeader extends StatelessWidget {
  final StatusMonitorComponentEvidencePayload payload;

  const _ComponentEvidenceHeader(this.payload);

  @override
  Widget build(BuildContext context) {
    const style = TextStyle(
      color: StatusMonitorReportSheet._muted,
      fontFamily: 'JetBrains Mono',
      fontSize: 7.5,
      fontWeight: FontWeight.w900,
      letterSpacing: 1,
    );
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          Expanded(
            flex: 13,
            child: Text(payload.componentTitle, style: style),
          ),
          Expanded(
            flex: 8,
            child: Text(payload.statusTitle, style: style),
          ),
          Expanded(
            flex: 16,
            child: Text(payload.takeawayTitle, style: style),
          ),
          Expanded(
            flex: 9,
            child: Text(payload.checksTitle, style: style),
          ),
          Expanded(
            flex: 20,
            child: Text(payload.evidenceTitle, style: style),
          ),
        ],
      ),
    );
  }
}

class _ScoreRing extends StatelessWidget {
  final StatusMonitorScorePayload score;

  const _ScoreRing(this.score);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 76,
      height: 76,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
            color: StatusMonitorReportSheet.tone(score.tone), width: 8),
      ),
      alignment: Alignment.center,
      child: _Mono(score.value,
          size: 22,
          bold: true,
          color: StatusMonitorReportSheet.tone(score.tone)),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String number;
  final String title;
  final String? trailing;

  const _SectionTitle(this.number, this.title, this.trailing);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(0, 12, 0, 8),
      padding: const EdgeInsets.only(bottom: 4),
      decoration: const BoxDecoration(
        border:
            Border(bottom: BorderSide(color: StatusMonitorReportSheet._line)),
      ),
      child: Row(
        children: [
          Expanded(
            child: RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                      text: '$number ',
                      style: const TextStyle(
                          color: StatusMonitorReportSheet._green,
                          fontWeight: FontWeight.w900,
                          fontSize: 9,
                          letterSpacing: 1.3)),
                  TextSpan(
                      text: title.toUpperCase(),
                      style: const TextStyle(
                          color: StatusMonitorReportSheet._muted,
                          fontWeight: FontWeight.w900,
                          fontSize: 9,
                          letterSpacing: 1.3)),
                ],
              ),
            ),
          ),
          if (trailing != null) _Mono(trailing!, size: 8),
        ],
      ),
    );
  }
}

class _MetaRow extends StatelessWidget {
  final String label;
  final String value;

  const _MetaRow(this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: [
          Expanded(child: _Mono(label.toUpperCase(), size: 8, bold: true)),
          const SizedBox(width: 10),
          Flexible(
              child:
                  _Mono(value, size: 9, color: StatusMonitorReportSheet._ink)),
        ],
      ),
    );
  }
}

class _Card extends StatelessWidget {
  final Widget child;

  const _Card({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: StatusMonitorReportSheet._panel2,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: StatusMonitorReportSheet._line),
      ),
      child: child,
    );
  }
}

class _Pill extends StatelessWidget {
  final String text;
  final String tone;

  const _Pill(this.text, this.tone);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
      decoration: BoxDecoration(
        color: StatusMonitorReportSheet.toneBg(tone),
        borderRadius: BorderRadius.circular(99),
        border: Border.all(color: StatusMonitorReportSheet._line),
      ),
      child: _Mono(text.toUpperCase(),
          size: 8, bold: true, color: StatusMonitorReportSheet.tone(tone)),
    );
  }
}

class _ListBlock extends StatelessWidget {
  final String title;
  final List<String> items;

  const _ListBlock(this.title, this.items);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title,
            style: const TextStyle(
              color: StatusMonitorReportSheet._ink,
              fontSize: 12,
              fontWeight: FontWeight.w900,
            )),
        const SizedBox(height: 5),
        for (final item in items)
          Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: _Body('- $item')),
      ],
    );
  }
}

class _Finding extends StatelessWidget {
  final StatusMonitorFindingPayload finding;

  const _Finding(this.finding);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 8,
            height: 8,
            margin: const EdgeInsets.only(top: 4),
            decoration: BoxDecoration(
              color: StatusMonitorReportSheet.tone(finding.tone),
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 9),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(finding.title,
                    style: const TextStyle(
                      color: StatusMonitorReportSheet._ink,
                      fontSize: 12,
                      fontWeight: FontWeight.w900,
                    )),
                const SizedBox(height: 2),
                _Body(finding.body),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TableComponentName extends StatelessWidget {
  final String title;
  final String role;

  const _TableComponentName(this.title, this.role);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title,
            style: const TextStyle(
              color: StatusMonitorReportSheet._ink,
              fontWeight: FontWeight.w900,
              fontSize: 8.8,
              height: 1.25,
            )),
        _Mono(role.toUpperCase(), size: 6.6, bold: true),
      ],
    );
  }
}

class _TableBody extends StatelessWidget {
  final String text;

  const _TableBody(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        color: StatusMonitorReportSheet._muted,
        fontSize: 8.2,
        height: 1.35,
      ),
    );
  }
}

class _Body extends StatelessWidget {
  final String text;

  const _Body(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
          color: StatusMonitorReportSheet._muted, fontSize: 10, height: 1.45),
    );
  }
}

class _Mono extends StatelessWidget {
  final String text;
  final double size;
  final bool bold;
  final Color color;

  const _Mono(
    this.text, {
    this.size = 8,
    this.bold = false,
    this.color = StatusMonitorReportSheet._muted,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        color: color,
        fontFamily: 'JetBrains Mono',
        fontSize: size,
        fontWeight: bold ? FontWeight.w900 : FontWeight.w600,
        height: 1.35,
      ),
    );
  }
}
