import 'package:flutter/material.dart';
import 'package:smart_xdrip/domain/entities/app_settings.dart';
import 'package:smart_xdrip/plugins/explore/episode_detail/application/episode_detail_formatters.dart';
import 'package:smart_xdrip/plugins/explore/episode_detail/application/i18n/episode_detail_l10n.dart';
import 'package:smart_xdrip/reporting/domain/report_section.dart';
import 'package:smart_xdrip/reporting/domain/report_snapshot.dart';

import '../../low/low_episode_report_payloads.dart';

class LowEpisodeReportSheet extends StatelessWidget {
  final ReportSnapshot snapshot;

  const LowEpisodeReportSheet({
    super.key,
    required this.snapshot,
  });

  static const _ink = Color(0xFF15201A);
  static const _muted = Color(0xFF61746B);
  static const _soft = Color(0xFF7B8E85);
  static const _line = Color(0xFFDFE6E2);
  static const _panel = Color(0xFFF7F9F8);
  static const _panel2 = Color(0xFFFBFCFB);
  static const _green = Color(0xFF1A9E5C);
  static const _amber = Color(0xFFB87518);
  static const _blue = Color(0xFF2D7AB0);
  static const _cyan = Color(0xFF5DB8F0);

  @override
  Widget build(BuildContext context) {
    final compact = MediaQuery.sizeOf(context).width < 760;
    return Container(
      width: double.infinity,
      constraints: const BoxConstraints(maxWidth: 794, minHeight: 1020),
      padding: EdgeInsets.fromLTRB(
        compact ? 18 : 36,
        compact ? 24 : 32,
        compact ? 18 : 36,
        30,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Color(0x2E000000),
            blurRadius: 24,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _Status(title: snapshot.title),
          const SizedBox(height: 14),
          _Hero(episodeLabel: _episodeLabel(context, snapshot)),
          _Meta(snapshot: snapshot),
          for (final section in snapshot.sections) ...[
            _SectionLabel(section: section),
            _SectionBody(section: section),
          ],
          _Privacy(text: snapshot.disclaimer.text),
        ],
      ),
    );
  }
}

String _episodeLabel(BuildContext context, ReportSnapshot snapshot) {
  LowEpisodeCurvePayload? curve;
  for (final section in snapshot.sections) {
    final payload = section.payload;
    if (payload is LowEpisodeCurvePayload) {
      curve = payload;
      break;
    }
  }
  if (curve == null) return context.episodeDetailL10n.episodeTimeUnavailable;
  final end = curve.recoveryTime ?? curve.timeRangeEnd;
  return '${_shortDate(context, curve.onsetTime)}, '
      '${curve.onsetTime.year} · ${EpisodeDetailFormatters.hm(curve.onsetTime)}'
      '-${EpisodeDetailFormatters.hm(end)}';
}

String _shortDate(BuildContext context, DateTime value) {
  final l10n = context.episodeDetailL10n;
  if (l10n.localeName.startsWith('zh')) return '${value.month}月${value.day}日';
  final month = switch (value.month) {
    1 => l10n.monthJan,
    2 => l10n.monthFeb,
    3 => l10n.monthMar,
    4 => l10n.monthApr,
    5 => l10n.monthMay,
    6 => l10n.monthJun,
    7 => l10n.monthJul,
    8 => l10n.monthAug,
    9 => l10n.monthSep,
    10 => l10n.monthOct,
    11 => l10n.monthNov,
    12 => l10n.monthDec,
    _ => '${value.month}',
  };
  return '$month ${value.day}';
}

class _Status extends StatelessWidget {
  final String title;

  const _Status({required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(bottom: 10),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: LowEpisodeReportSheet._ink, width: 2),
        ),
      ),
      child: Row(
        children: [
          Text(
            context.episodeDetailL10n.reportBrandName,
            style: const TextStyle(
              color: LowEpisodeReportSheet._muted,
              fontFamily: 'JetBrainsMono',
              fontSize: 9,
              fontWeight: FontWeight.w700,
            ),
          ),
          const Spacer(),
          Text(
            '$title - ${context.episodeDetailL10n.pdfPreviewSuffix}',
            style: const TextStyle(
              color: LowEpisodeReportSheet._muted,
              fontFamily: 'JetBrainsMono',
              fontSize: 9,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _Hero extends StatelessWidget {
  final String episodeLabel;

  const _Hero({required this.episodeLabel});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.episodeDetailL10n.episodeReview.toUpperCase(),
            style: const TextStyle(
              color: LowEpisodeReportSheet._green,
              fontFamily: 'JetBrainsMono',
              fontSize: 9,
              letterSpacing: 1.4,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            context.episodeDetailL10n.lowEpisodeTitle,
            style: const TextStyle(
              color: LowEpisodeReportSheet._ink,
              fontSize: 22,
              height: 1.08,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 8),
          _EpisodeHeroTime(label: episodeLabel),
          const SizedBox(height: 6),
          Text(
            context.episodeDetailL10n.lowReportHeroSummary,
            style: const TextStyle(
              color: LowEpisodeReportSheet._muted,
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
  final ReportSnapshot snapshot;

  const _Meta({required this.snapshot});

  @override
  Widget build(BuildContext context) {
    final l10n = context.episodeDetailL10n;
    final rows = [
      (
        l10n.reportPeriod,
        _period(context, snapshot.range.start, snapshot.range.end),
      ),
      (l10n.episodeAnalyzed, _episodeLabel(context, snapshot)),
      (l10n.reportDataSource, snapshot.sourceLabel),
      (l10n.reportGenerated, _dateTime(context, snapshot.generatedAt)),
      (l10n.thresholds, _thresholds(context, snapshot.unit)),
    ];
    return _Card(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final children = [
            for (final row in rows) _MetaRow(label: row.$1, value: row.$2),
          ];
          if (constraints.maxWidth <= 520) return Column(children: children);
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  children: [children[0], children[1], children[3]],
                ),
              ),
              const SizedBox(width: 18),
              Expanded(child: Column(children: [children[2], children[4]])),
            ],
          );
        },
      ),
    );
  }

  static String _period(BuildContext context, DateTime start, DateTime end) {
    return '${_shortDate(context, start)} - ${_shortDate(context, end)}, ${end.year}';
  }

  static String _dateTime(BuildContext context, DateTime time) {
    return '${_shortDate(context, time)}, ${time.year} ${EpisodeDetailFormatters.hm(time)}';
  }

  static String _thresholds(BuildContext context, GlucoseUnit unit) {
    final l10n = context.episodeDetailL10n;
    return unit == GlucoseUnit.mgDl
        ? l10n.lowThresholds('70', '54')
        : l10n.lowThresholds('3.9', '3.0');
  }
}

class _EpisodeHeroTime extends StatelessWidget {
  final String label;

  const _EpisodeHeroTime({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFFE9F3FA),
        border: Border.all(color: const Color(0xFFC9DEEE)),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            context.episodeDetailL10n.episodeAnalyzed.toUpperCase(),
            style: const TextStyle(
              color: LowEpisodeReportSheet._soft,
              fontFamily: 'JetBrainsMono',
              fontSize: 9,
              letterSpacing: .8,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            label,
            style: const TextStyle(
              color: LowEpisodeReportSheet._ink,
              fontFamily: 'JetBrainsMono',
              fontSize: 10,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }
}

class _MetaRow extends StatelessWidget {
  final String label;
  final String value;

  const _MetaRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 5),
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: Color(0xFFEDF2EF))),
      ),
      child: Row(
        children: [
          Text(
            label.toUpperCase(),
            style: const TextStyle(
              color: LowEpisodeReportSheet._soft,
              fontFamily: 'JetBrainsMono',
              fontSize: 8,
              letterSpacing: .8,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: const TextStyle(
                color: LowEpisodeReportSheet._muted,
                fontFamily: 'JetBrainsMono',
                fontSize: 9,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final ReportSection section;

  const _SectionLabel({required this.section});

  @override
  Widget build(BuildContext context) {
    final l10n = context.episodeDetailL10n;
    final trailing = switch (section.id) {
      'summary' => l10n.episodeView,
      'curve' => _curveTrailing(section),
      'lifecycle' => l10n.sequence,
      'repeat' => l10n.past30Days,
      _ => '',
    };
    return Container(
      margin: const EdgeInsets.only(top: 14, bottom: 10),
      padding: const EdgeInsets.only(bottom: 4),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: LowEpisodeReportSheet._line)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              section.title.toUpperCase(),
              style: const TextStyle(
                color: LowEpisodeReportSheet._muted,
                fontFamily: 'JetBrainsMono',
                fontSize: 9,
                letterSpacing: 1.3,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
          if (trailing.isNotEmpty) _Pill(text: trailing),
        ],
      ),
    );
  }

  static String _curveTrailing(ReportSection section) {
    final payload = section.payload;
    if (payload is LowEpisodeCurvePayload) {
      final end = payload.recoveryTime ?? payload.timeRangeEnd;
      return '${EpisodeDetailFormatters.hm(payload.onsetTime)}-${EpisodeDetailFormatters.hm(end)}';
    }
    return '';
  }
}

class _SectionBody extends StatelessWidget {
  final ReportSection section;

  const _SectionBody({required this.section});

  @override
  Widget build(BuildContext context) {
    final payload = section.payload;
    final l10n = context.episodeDetailL10n;
    if (payload == null) {
      return _Card(child: Text(l10n.insufficientData));
    }
    if (payload is LowEpisodeExposureSummaryPayload) {
      return _MetricsGrid(metrics: payload.metrics);
    }
    if (payload is LowEpisodeCurvePayload) return _Curve(payload: payload);
    if (payload is LowEpisodeLifecyclePayload) {
      return _Lifecycle(payload: payload);
    }
    if (payload is LowEpisodeRepeatPayload) return _Repeat(payload: payload);
    if (payload is LowEpisodeFindingListPayload) {
      return _Findings(payload: payload);
    }
    if (payload is LowEpisodeQualityPayload) {
      return _Quality(metrics: payload.metrics);
    }
    return _Card(child: Text(l10n.insufficientData));
  }
}

class _MetricsGrid extends StatelessWidget {
  final List<LowEpisodeReportMetric> metrics;

  const _MetricsGrid({required this.metrics});

  @override
  Widget build(BuildContext context) {
    return _Card(
      child: LayoutBuilder(
        builder: (context, constraints) {
          final width = (constraints.maxWidth - 24) / 4;
          return Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final metric in metrics)
                SizedBox(
                  width: width < 135 ? (constraints.maxWidth - 8) / 2 : width,
                  child: _Metric(metric: metric),
                ),
            ],
          );
        },
      ),
    );
  }
}

class _Metric extends StatelessWidget {
  final LowEpisodeReportMetric metric;

  const _Metric({required this.metric});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(10, 9, 10, 10),
      decoration: BoxDecoration(
        color: LowEpisodeReportSheet._panel,
        border: Border.all(color: const Color(0xFFE2EAE5)),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            metric.label.toUpperCase(),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: LowEpisodeReportSheet._soft,
              fontFamily: 'JetBrainsMono',
              fontSize: 8,
              letterSpacing: .7,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 5),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(
              metric.value,
              style: TextStyle(
                color: _tone(metric.tone),
                fontSize: 20,
                height: 1,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
          const SizedBox(height: 3),
          Text(
            metric.note,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: Color(0xFF8A9992),
              fontSize: 9,
              height: 1.35,
            ),
          ),
        ],
      ),
    );
  }
}

class _Curve extends StatelessWidget {
  final LowEpisodeCurvePayload payload;

  const _Curve({required this.payload});

  @override
  Widget build(BuildContext context) {
    final l10n = context.episodeDetailL10n;
    return _Card(
      padding: const EdgeInsets.fromLTRB(8, 8, 8, 4),
      child: Column(
        children: [
          SizedBox(
            height: 254,
            child: CustomPaint(
              painter: _LowCurvePainter(payload),
              child: Align(
                alignment: Alignment.topRight,
                child: Container(
                  margin: const EdgeInsets.only(top: 8, right: 10),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(.94),
                    border: Border.all(color: const Color(0xFFCBD7D0)),
                    borderRadius: BorderRadius.circular(6),
                    boxShadow: const [
                      BoxShadow(color: Color(0x12000000), blurRadius: 12),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.nadir,
                        style: const TextStyle(
                          color: LowEpisodeReportSheet._muted,
                          fontFamily: 'JetBrainsMono',
                          fontSize: 8,
                        ),
                      ),
                      Text(
                        payload.nadirLabel,
                        style: const TextStyle(
                          color: LowEpisodeReportSheet._blue,
                          fontFamily: 'JetBrainsMono',
                          fontSize: 12,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          _CurveMarkerLegend(
            items: [
              _CurveMarkerLegendItem(l10n.start, LowEpisodeReportSheet._amber),
              _CurveMarkerLegendItem(l10n.nadir, LowEpisodeReportSheet._blue),
              if (payload.recoveryTime != null)
                _CurveMarkerLegendItem(
                  l10n.recover,
                  LowEpisodeReportSheet._green,
                ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: _MiniKpi(
                  value: payload.durationBelowRangeLabel,
                  label: l10n.timeBelowRange,
                ),
              ),
              const SizedBox(width: 7),
              Expanded(
                child: _MiniKpi(
                  value: payload.veryLowMinutesLabel,
                  label: l10n.veryLow,
                ),
              ),
              const SizedBox(width: 7),
              Expanded(
                child: _MiniKpi(
                    value: payload.recoveryLabel, label: l10n.recovery),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _CurveMarkerLegendItem {
  final String label;
  final Color color;

  const _CurveMarkerLegendItem(this.label, this.color);
}

class _CurveMarkerLegend extends StatelessWidget {
  final List<_CurveMarkerLegendItem> items;

  const _CurveMarkerLegend({required this.items});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 10,
      runSpacing: 4,
      children: [
        for (final item in items)
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 7,
                height: 7,
                decoration: BoxDecoration(
                  color: item.color,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 4),
              Text(
                item.label,
                style: const TextStyle(
                  color: LowEpisodeReportSheet._muted,
                  fontFamily: 'JetBrainsMono',
                  fontSize: 9,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
      ],
    );
  }
}

class _Lifecycle extends StatelessWidget {
  final LowEpisodeLifecyclePayload payload;

  const _Lifecycle({required this.payload});

  @override
  Widget build(BuildContext context) {
    return _Card(
      child: Stack(
        children: [
          Positioned(
            left: 54,
            right: 54,
            top: 15,
            child: Container(height: 1, color: const Color(0xFFCBD7D0)),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (final step in payload.steps)
                Expanded(child: _LifeStep(step: step)),
            ],
          ),
        ],
      ),
    );
  }
}

class _LifeStep extends StatelessWidget {
  final LowEpisodeLifecycleStepPayload step;

  const _LifeStep({required this.step});

  @override
  Widget build(BuildContext context) {
    final color = _tone(step.tone);
    final neutral = step.tone == 'neutral';
    return Column(
      children: [
        Container(
          width: 30,
          height: 30,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: neutral ? LowEpisodeReportSheet._panel : color,
            shape: BoxShape.circle,
            border: Border.all(
              color: neutral ? const Color(0xFFCBD7D0) : color,
            ),
          ),
          child: Text(
            step.code,
            style: TextStyle(
              color: neutral ? LowEpisodeReportSheet._green : Colors.white,
              fontFamily: 'JetBrainsMono',
              fontSize: 9,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          step.label,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 9, fontWeight: FontWeight.w800),
        ),
        const SizedBox(height: 2),
        Text(
          step.value,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: LowEpisodeReportSheet._muted,
            fontFamily: 'JetBrainsMono',
            fontSize: 7.5,
          ),
        ),
      ],
    );
  }
}

class _Repeat extends StatelessWidget {
  final LowEpisodeRepeatPayload payload;

  const _Repeat({required this.payload});

  @override
  Widget build(BuildContext context) {
    final dataset = payload.dataset;
    return _Card(
      child: LayoutBuilder(
        builder: (context, constraints) {
          final compact = constraints.maxWidth < 560;
          final left = Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _NoteBox(
                text: dataset.takeaway.isEmpty
                    ? context.episodeDetailL10n.repeatLimitedPast30
                    : dataset.takeaway,
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 4,
                runSpacing: 4,
                children: [
                  for (final mark in dataset.dayMarks.take(30))
                    Container(
                      width: compact ? 12 : 16,
                      height: 16,
                      decoration: BoxDecoration(
                        color: mark.isCurrent
                            ? LowEpisodeReportSheet._green
                            : mark.isStrong
                                ? LowEpisodeReportSheet._blue
                                : mark.hasEpisode
                                    ? LowEpisodeReportSheet._cyan
                                    : const Color(0xFFEEF3F0),
                        border: Border.all(
                          color: mark.hasEpisode
                              ? LowEpisodeReportSheet._blue
                              : LowEpisodeReportSheet._line,
                        ),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 8),
              const _LegendRow(),
            ],
          );
          final right = Column(
            children: [
              for (final bucket in dataset.timeBlockBuckets)
                _BarRow(
                  label: bucket.label,
                  count: bucket.count,
                  fraction: bucket.normalizedHeight,
                  color: bucket.isDominant
                      ? LowEpisodeReportSheet._blue
                      : bucket.isSecondary
                          ? LowEpisodeReportSheet._cyan
                          : LowEpisodeReportSheet._soft,
                ),
            ],
          );
          if (compact) {
            return Column(children: [left, const SizedBox(height: 12), right]);
          }
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(flex: 3, child: left),
              const SizedBox(width: 18),
              Expanded(flex: 2, child: right),
            ],
          );
        },
      ),
    );
  }
}

class _Findings extends StatelessWidget {
  final LowEpisodeFindingListPayload payload;

  const _Findings({required this.payload});

  @override
  Widget build(BuildContext context) {
    return _Card(
      child: Column(
        children: [
          for (var i = 0; i < payload.findings.length; i++) ...[
            if (i > 0) const Divider(height: 17, color: Color(0xFFEDF2EF)),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 8,
                  height: 8,
                  margin: const EdgeInsets.only(top: 4),
                  decoration: BoxDecoration(
                    color: _tone(payload.findings[i].tone),
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 9),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        payload.findings[i].title,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        payload.findings[i].body,
                        style: const TextStyle(
                          color: LowEpisodeReportSheet._muted,
                          fontSize: 10.5,
                          height: 1.55,
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
}

class _Quality extends StatelessWidget {
  final List<LowEpisodeReportMetric> metrics;

  const _Quality({required this.metrics});

  @override
  Widget build(BuildContext context) {
    return _MetricsGrid(metrics: metrics);
  }
}

class _Card extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;

  const _Card({
    required this.child,
    this.padding = const EdgeInsets.all(10),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: padding,
      decoration: BoxDecoration(
        color: LowEpisodeReportSheet._panel2,
        border: Border.all(color: LowEpisodeReportSheet._line),
        borderRadius: BorderRadius.circular(6),
      ),
      child: child,
    );
  }
}

class _MiniKpi extends StatelessWidget {
  final String value;
  final String label;

  const _MiniKpi({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 7),
      decoration: BoxDecoration(
        color: LowEpisodeReportSheet._panel,
        border: Border.all(color: const Color(0xFFE2EAE5)),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: const TextStyle(
              color: LowEpisodeReportSheet._ink,
              fontFamily: 'JetBrainsMono',
              fontSize: 12,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            label.toUpperCase(),
            style: const TextStyle(
              color: LowEpisodeReportSheet._soft,
              fontFamily: 'JetBrainsMono',
              fontSize: 7,
            ),
          ),
        ],
      ),
    );
  }
}

class _NoteBox extends StatelessWidget {
  final String text;

  const _NoteBox({required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 9),
      decoration: BoxDecoration(
        color: const Color(0xFFE9F3FA),
        border: Border.all(color: const Color(0xFFC7DCEC)),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: LowEpisodeReportSheet._muted,
          fontSize: 10.5,
          height: 1.55,
        ),
      ),
    );
  }
}

class _Pill extends StatelessWidget {
  final String text;

  const _Pill({required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
      decoration: BoxDecoration(
        color: const Color(0xFFE9F3FA),
        border: Border.all(color: const Color(0xFFC7DCEC)),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: LowEpisodeReportSheet._blue,
          fontFamily: 'JetBrainsMono',
          fontSize: 8,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }
}

class _LegendRow extends StatelessWidget {
  const _LegendRow();

  @override
  Widget build(BuildContext context) {
    final l10n = context.episodeDetailL10n;
    return Wrap(
      spacing: 10,
      runSpacing: 4,
      children: [
        _LegendDot(label: l10n.none, color: const Color(0xFFEEF3F0)),
        _LegendDot(label: l10n.low, color: LowEpisodeReportSheet._cyan),
        _LegendDot(label: l10n.current, color: LowEpisodeReportSheet._green),
      ],
    );
  }
}

class _LegendDot extends StatelessWidget {
  final String label;
  final Color color;

  const _LegendDot({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(3),
          ),
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: const TextStyle(
            color: LowEpisodeReportSheet._muted,
            fontFamily: 'JetBrainsMono',
            fontSize: 8,
          ),
        ),
      ],
    );
  }
}

class _BarRow extends StatelessWidget {
  final String label;
  final int count;
  final double fraction;
  final Color color;

  const _BarRow({
    required this.label,
    required this.count,
    required this.fraction,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 7),
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: Color(0xFFEDF2EF))),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 88,
            child: Text(
              label,
              style: const TextStyle(
                color: LowEpisodeReportSheet._muted,
                fontFamily: 'JetBrainsMono',
                fontSize: 9,
              ),
            ),
          ),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(999),
              child: SizedBox(
                height: 10,
                child: Stack(
                  children: [
                    Container(color: const Color(0xFFEDF2EF)),
                    FractionallySizedBox(
                      widthFactor: fraction.clamp(.03, 1),
                      child: Container(color: color),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(width: 9),
          SizedBox(
            width: 30,
            child: Text(
              '$count',
              textAlign: TextAlign.right,
              style: const TextStyle(
                color: LowEpisodeReportSheet._ink,
                fontFamily: 'JetBrainsMono',
                fontSize: 9,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Privacy extends StatelessWidget {
  final String text;

  const _Privacy({required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 18),
      padding: const EdgeInsets.only(top: 8),
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: LowEpisodeReportSheet._line)),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Color(0xFF8A9992),
          fontFamily: 'JetBrainsMono',
          fontSize: 8,
          height: 1.45,
        ),
      ),
    );
  }
}

class _LowCurvePainter extends CustomPainter {
  final LowEpisodeCurvePayload payload;

  const _LowCurvePainter(this.payload);

  @override
  void paint(Canvas canvas, Size size) {
    final chart = Rect.fromLTWH(54, 18, size.width - 108, 192);
    final values = payload.readings.map((e) => e.value).toList();
    final minValue = values.isEmpty
        ? payload.veryLowThresholdMmol * .7
        : values.reduce((a, b) => a < b ? a : b) - .5;
    final maxValue = values.isEmpty
        ? payload.lowThresholdMmol * 1.8
        : values.reduce((a, b) => a > b ? a : b) + .5;
    double x(DateTime time) {
      final total = payload.timeRangeEnd
          .difference(payload.timeRangeStart)
          .inMilliseconds;
      if (total <= 0) return chart.left;
      return chart.left +
          chart.width *
              (time.difference(payload.timeRangeStart).inMilliseconds / total)
                  .clamp(0, 1);
    }

    double y(double value) =>
        chart.bottom -
        chart.height *
            ((value - minValue) / (maxValue - minValue).clamp(.1, 100))
                .clamp(0, 1);

    final lowY = y(payload.lowThresholdMmol);
    final veryLowY = y(payload.veryLowThresholdMmol);
    canvas.drawRect(
      Rect.fromLTRB(chart.left, lowY, chart.right, chart.bottom),
      Paint()..color = const Color(0xFFE9F3FA),
    );
    canvas.drawRect(
      Rect.fromLTRB(chart.left, veryLowY, chart.right, chart.bottom),
      Paint()..color = const Color(0xFFDDEFFA),
    );
    _dash(
      canvas,
      Offset(chart.left, lowY),
      Offset(chart.right, lowY),
      Paint()
        ..color = const Color(0xFFA7CDE6)
        ..strokeWidth = 1,
    );
    _dash(
      canvas,
      Offset(chart.left, veryLowY),
      Offset(chart.right, veryLowY),
      Paint()
        ..color = const Color(0xFF78AFD2)
        ..strokeWidth = 1,
    );
    canvas.drawLine(
      Offset(chart.left, chart.bottom),
      Offset(chart.right, chart.bottom),
      Paint()..color = LowEpisodeReportSheet._line,
    );

    if (payload.readings.length >= 2) {
      final path = Path();
      for (var i = 0; i < payload.readings.length; i++) {
        final point = Offset(
          x(payload.readings[i].timestamp),
          y(payload.readings[i].value),
        );
        if (i == 0) {
          path.moveTo(point.dx, point.dy);
        } else {
          path.lineTo(point.dx, point.dy);
        }
      }
      canvas.drawPath(
        path,
        Paint()
          ..color = LowEpisodeReportSheet._blue
          ..strokeWidth = 5
          ..strokeCap = StrokeCap.round
          ..strokeJoin = StrokeJoin.round
          ..style = PaintingStyle.stroke,
      );
    }

    final onsetX = x(payload.onsetTime);
    final nadirX = x(payload.nadirTime);
    final recoveryX =
        payload.recoveryTime == null ? null : x(payload.recoveryTime!);
    _dash(
      canvas,
      Offset(onsetX, chart.top + 4),
      Offset(onsetX, chart.bottom),
      Paint()
        ..color = LowEpisodeReportSheet._amber
        ..strokeWidth = 1,
    );
    _dash(
      canvas,
      Offset(nadirX, chart.top + 4),
      Offset(nadirX, chart.bottom),
      Paint()
        ..color = LowEpisodeReportSheet._blue
        ..strokeWidth = 1,
    );
    if (recoveryX != null) {
      _dash(
        canvas,
        Offset(recoveryX, chart.top + 4),
        Offset(recoveryX, chart.bottom),
        Paint()
          ..color = LowEpisodeReportSheet._green
          ..strokeWidth = 1,
      );
    }
    final nadirValue = values.isEmpty
        ? payload.veryLowThresholdMmol
        : values.reduce((a, b) => a < b ? a : b);
    canvas.drawCircle(
      Offset(nadirX, y(nadirValue)),
      8,
      Paint()..color = LowEpisodeReportSheet._blue,
    );
    canvas.drawCircle(
      Offset(nadirX, y(nadirValue)),
      8,
      Paint()
        ..color = Colors.white
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3,
    );
    _label(canvas, Offset(44, lowY - 6),
        _threshold(payload.unit, payload.lowThresholdMmol),
        alignRight: true);
    _label(canvas, Offset(44, veryLowY - 6),
        _threshold(payload.unit, payload.veryLowThresholdMmol),
        alignRight: true);
    _label(canvas, Offset(chart.left, 232),
        EpisodeDetailFormatters.hm(payload.timeRangeStart),
        center: true);
    _label(canvas, Offset(chart.right, 232),
        EpisodeDetailFormatters.hm(payload.timeRangeEnd),
        center: true);
  }

  static String _threshold(GlucoseUnit unit, double mmol) {
    if (unit == GlucoseUnit.mgDl) return (mmol * 18.0182).round().toString();
    return mmol.toStringAsFixed(1);
  }

  @override
  bool shouldRepaint(covariant _LowCurvePainter oldDelegate) =>
      oldDelegate.payload != payload;
}

Color _tone(String tone) {
  return switch (tone) {
    'blue' => LowEpisodeReportSheet._blue,
    'cyan' => LowEpisodeReportSheet._cyan,
    'amber' || 'warning' => LowEpisodeReportSheet._amber,
    'green' => LowEpisodeReportSheet._green,
    _ => LowEpisodeReportSheet._ink,
  };
}

void _dash(Canvas canvas, Offset start, Offset end, Paint paint) {
  final distance = (end - start).distance;
  if (distance <= 0) return;
  final direction = (end - start) / distance;
  var current = 0.0;
  while (current < distance) {
    final dashEnd = (current + 6).clamp(0, distance).toDouble();
    canvas.drawLine(
      start + direction * current,
      start + direction * dashEnd,
      paint,
    );
    current += 11;
  }
}

void _label(
  Canvas canvas,
  Offset offset,
  String text, {
  Color color = LowEpisodeReportSheet._muted,
  bool center = false,
  bool alignRight = false,
}) {
  final painter = TextPainter(
    text: TextSpan(
      text: text,
      style: TextStyle(
        color: color,
        fontFamily: 'JetBrainsMono',
        fontSize: 11,
      ),
    ),
    textDirection: TextDirection.ltr,
  )..layout();
  final dx = center
      ? offset.dx - painter.width / 2
      : alignRight
          ? offset.dx - painter.width
          : offset.dx;
  painter.paint(canvas, Offset(dx, offset.dy));
}
