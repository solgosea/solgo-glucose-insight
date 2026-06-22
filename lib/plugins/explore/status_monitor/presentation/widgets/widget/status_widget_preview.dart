import 'package:flutter/material.dart';

import '../../../domain/status_level.dart';
import '../../../domain/widget/status_widget_connection_state.dart';
import '../../../domain/widget/status_widget_snapshot.dart';
import '../../../domain/widget/status_widget_template.dart';
import '../../styles/status_monitor_theme.dart';

class StatusWidgetPreview extends StatelessWidget {
  final StatusWidgetSnapshot snapshot;

  const StatusWidgetPreview({
    super.key,
    required this.snapshot,
  });

  @override
  Widget build(BuildContext context) {
    return switch (snapshot.template) {
      StatusWidgetTemplate.compact => _CompactStatusWidget(snapshot: snapshot),
      StatusWidgetTemplate.flow => _FlowStatusWidget(snapshot: snapshot),
      StatusWidgetTemplate.issue => _FlowStatusWidget(
          snapshot: snapshot,
          issueFocus: true,
        ),
      StatusWidgetTemplate.detailed => _DetailedStatusWidget(
          snapshot: snapshot,
        ),
    };
  }
}

class StatusWidgetTemplateGallery extends StatelessWidget {
  final StatusWidgetSnapshot snapshot;

  const StatusWidgetTemplateGallery({
    super.key,
    required this.snapshot,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final columns = switch (width) {
          >= 720 => 4,
          >= 520 => 3,
          _ => 1,
        };
        return GridView.count(
          crossAxisCount: columns,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: switch (columns) {
            1 => 1.48,
            3 => .72,
            _ => .76,
          },
          children: [
            for (final template in StatusWidgetTemplate.values)
              _TemplatePreviewCard(
                template: template,
                snapshot: _copyWithTemplate(snapshot, template),
              ),
          ],
        );
      },
    );
  }

  StatusWidgetSnapshot _copyWithTemplate(
    StatusWidgetSnapshot source,
    StatusWidgetTemplate template,
  ) {
    return StatusWidgetSnapshot(
      subjectId: source.subjectId,
      template: template,
      headline: source.headline,
      summary: source.summary,
      sourceLabel: source.sourceLabel,
      updatedLabel: source.updatedLabel,
      freshnessLabel: source.freshnessLabel,
      notificationText: source.notificationText,
      lockScreenText: source.lockScreenText,
      primaryIssueLabel: source.primaryIssueLabel,
      level: source.level,
      score: source.score,
      scoreLabel: source.scoreLabel,
      hasConfiguredSource: source.hasConfiguredSource,
      isStale: source.isStale,
      privateMode: source.privateMode,
      components: source.components,
      sensorToUploader: source.sensorToUploader,
      uploaderToServer: source.uploaderToServer,
    );
  }
}

class _TemplatePreviewCard extends StatelessWidget {
  final StatusWidgetTemplate template;
  final StatusWidgetSnapshot snapshot;

  const _TemplatePreviewCard({
    required this.template,
    required this.snapshot,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: StatusMonitorTheme.card,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: StatusMonitorTheme.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: _TemplateStage(snapshot: snapshot),
          ),
          const SizedBox(height: 10),
          Text(
            template.label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: StatusMonitorTheme.inter.copyWith(
              color: StatusMonitorTheme.text,
              fontSize: 13.5,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            _templateMeta(template),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: StatusMonitorTheme.mono.copyWith(
              color: StatusMonitorTheme.soft,
              fontSize: 9.5,
            ),
          ),
        ],
      ),
    );
  }
}

class _TemplateStage extends StatelessWidget {
  final StatusWidgetSnapshot snapshot;

  const _TemplateStage({required this.snapshot});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final stageHeight = constraints.maxHeight.clamp(0.0, 132.0);
        return SizedBox(
          height: stageHeight,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 13),
            decoration: BoxDecoration(
              color: const Color(0xFF0B1210),
              borderRadius: BorderRadius.circular(13),
              border: Border.all(
                color: StatusMonitorTheme.green.withOpacity(.07),
              ),
            ),
            child: Center(child: _MiniStatusWidget(snapshot: snapshot)),
          ),
        );
      },
    );
  }
}

class _MiniStatusWidget extends StatelessWidget {
  final StatusWidgetSnapshot snapshot;

  const _MiniStatusWidget({required this.snapshot});

  @override
  Widget build(BuildContext context) {
    final preferredHeight = switch (snapshot.template) {
      StatusWidgetTemplate.compact => 170.0,
      StatusWidgetTemplate.flow => 170.0,
      StatusWidgetTemplate.issue => 190.0,
      StatusWidgetTemplate.detailed => 270.0,
    };
    final preferredWidth =
        snapshot.template == StatusWidgetTemplate.compact ? 172.0 : 306.0;
    return LayoutBuilder(
      builder: (context, constraints) {
        final height = preferredHeight.clamp(0.0, constraints.maxHeight);
        return SizedBox(
          width: double.infinity,
          height: height,
          child: FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.center,
            child: SizedBox(
              width: preferredWidth,
              height: preferredHeight,
              child: StatusWidgetPreview(snapshot: snapshot),
            ),
          ),
        );
      },
    );
  }
}

class _FlowStatusWidget extends StatelessWidget {
  final StatusWidgetSnapshot snapshot;
  final bool issueFocus;

  const _FlowStatusWidget({
    required this.snapshot,
    this.issueFocus = false,
  });

  @override
  Widget build(BuildContext context) {
    final accent = _levelColor(snapshot.level);
    final components = snapshot.components;
    return _WidgetShell(
      accent: accent,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _WidgetHeader(snapshot: snapshot),
          const SizedBox(height: 14),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _Node(component: components.elementAtOrNull(0)),
              Expanded(child: _Connector(state: snapshot.sensorToUploader)),
              _Node(component: components.elementAtOrNull(1)),
              Expanded(child: _Connector(state: snapshot.uploaderToServer)),
              _Node(component: components.elementAtOrNull(2)),
            ],
          ),
          if (issueFocus) ...[
            const SizedBox(height: 10),
            Text(
              snapshot.summary,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: StatusMonitorTheme.inter.copyWith(
                color: accent,
                fontSize: 11,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _CompactStatusWidget extends StatelessWidget {
  final StatusWidgetSnapshot snapshot;

  const _CompactStatusWidget({required this.snapshot});

  @override
  Widget build(BuildContext context) {
    final color = _levelColor(snapshot.level);
    return _WidgetShell(
      accent: color,
      width: 172,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              _LevelMark(level: snapshot.level, size: 18),
              const SizedBox(width: 7),
              Text(
                snapshot.scoreLabel,
                style: StatusMonitorTheme.mono.copyWith(
                  color: color,
                  fontSize: 24,
                  fontWeight: FontWeight.w900,
                  height: .95,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            snapshot.headline,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: StatusMonitorTheme.inter.copyWith(
              color: StatusMonitorTheme.soft,
              fontSize: 10,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 12),
          for (final component in snapshot.components.take(3))
            Padding(
              padding: const EdgeInsets.only(bottom: 7),
              child: Row(
                children: [
                  _LevelMark(level: component.level, size: 10),
                  const SizedBox(width: 7),
                  Expanded(
                    child: Text(
                      _shortName(component.title),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: StatusMonitorTheme.inter.copyWith(
                        color: StatusMonitorTheme.text,
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  Text(
                    component.scoreLabel,
                    style: StatusMonitorTheme.mono.copyWith(
                      color: _levelColor(component.level),
                      fontSize: 10,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class _DetailedStatusWidget extends StatelessWidget {
  final StatusWidgetSnapshot snapshot;

  const _DetailedStatusWidget({required this.snapshot});

  @override
  Widget build(BuildContext context) {
    final color = _levelColor(snapshot.level);
    return _WidgetShell(
      accent: color,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _WidgetHeader(snapshot: snapshot),
          const SizedBox(height: 8),
          for (final component in snapshot.components.take(3))
            _DetailedRow(component: component),
        ],
      ),
    );
  }
}

class _WidgetShell extends StatelessWidget {
  final Color accent;
  final Widget child;
  final double? width;

  const _WidgetShell({
    required this.accent,
    required this.child,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      padding: const EdgeInsets.fromLTRB(16, 13, 16, 15),
      decoration: BoxDecoration(
        color: const Color(0xFF111C17),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: StatusMonitorTheme.green.withOpacity(.18)),
      ),
      child: Stack(
        children: [
          Positioned.fill(
            left: -16,
            child: Align(
              alignment: Alignment.centerLeft,
              child: Container(
                width: 3,
                margin: const EdgeInsets.symmetric(vertical: 6),
                decoration: BoxDecoration(
                  color: accent,
                  borderRadius: BorderRadius.circular(99),
                ),
              ),
            ),
          ),
          child,
        ],
      ),
    );
  }
}

class _WidgetHeader extends StatelessWidget {
  final StatusWidgetSnapshot snapshot;

  const _WidgetHeader({required this.snapshot});

  @override
  Widget build(BuildContext context) {
    final color = _levelColor(snapshot.level);
    return Row(
      children: [
        _LevelMark(level: snapshot.level, size: 11),
        const SizedBox(width: 8),
        Text(
          'SYSTEM',
          style: StatusMonitorTheme.mono.copyWith(
            color: StatusMonitorTheme.dim,
            fontSize: 10,
            fontWeight: FontWeight.w900,
            letterSpacing: 1.2,
          ),
        ),
        const SizedBox(width: 8),
        Text(
          snapshot.scoreLabel,
          style: StatusMonitorTheme.mono.copyWith(
            color: color,
            fontSize: 13,
            fontWeight: FontWeight.w900,
          ),
        ),
        const Spacer(),
        Flexible(
          child: Text(
            snapshot.updatedLabel.replaceFirst('Updated ', ''),
            textAlign: TextAlign.right,
            overflow: TextOverflow.ellipsis,
            style: StatusMonitorTheme.mono.copyWith(
              color: StatusMonitorTheme.dim,
              fontSize: 9,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }
}

class _Node extends StatelessWidget {
  final StatusWidgetComponentSnapshot? component;

  const _Node({required this.component});

  @override
  Widget build(BuildContext context) {
    final current = component;
    final level = current?.level ?? StatusLevel.unknown;
    final color = _levelColor(level);
    return SizedBox(
      width: 78,
      child: Column(
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: StatusMonitorTheme.card2,
              borderRadius: BorderRadius.circular(14),
              border:
                  Border.all(color: StatusMonitorTheme.dim.withOpacity(.30)),
            ),
            alignment: Alignment.center,
            child: Text(
              _levelGlyph(level),
              style: StatusMonitorTheme.mono.copyWith(
                color: color,
                fontSize: 18,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            _shortName(current?.title ?? '--'),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: StatusMonitorTheme.inter.copyWith(
              color: StatusMonitorTheme.text,
              fontSize: 11,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            current?.scoreLabel ?? '--',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: StatusMonitorTheme.mono.copyWith(
              color: color,
              fontSize: 8.5,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

class _Connector extends StatelessWidget {
  final StatusWidgetConnectionState state;

  const _Connector({required this.state});

  @override
  Widget build(BuildContext context) {
    final color = switch (state) {
      StatusWidgetConnectionState.healthy => StatusMonitorTheme.green,
      StatusWidgetConnectionState.watch => StatusMonitorTheme.amber,
      StatusWidgetConnectionState.broken => StatusMonitorTheme.dim,
      StatusWidgetConnectionState.unknown => StatusMonitorTheme.dim,
    };
    return SizedBox(
      height: 46,
      child: Center(
        child: Container(
          height: state == StatusWidgetConnectionState.broken ? 2 : 3,
          decoration: BoxDecoration(
            color: color.withOpacity(
              state == StatusWidgetConnectionState.unknown ? .35 : .86,
            ),
            borderRadius: BorderRadius.circular(999),
          ),
        ),
      ),
    );
  }
}

class _DetailedRow extends StatelessWidget {
  final StatusWidgetComponentSnapshot component;

  const _DetailedRow({required this.component});

  @override
  Widget build(BuildContext context) {
    final color = _levelColor(component.level);
    return Container(
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: component.level == StatusLevel.healthy
            ? Colors.transparent
            : color.withOpacity(.07),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(.18)),
      ),
      child: Row(
        children: [
          Container(
            width: 34,
            height: 34,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: StatusMonitorTheme.card2,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: color.withOpacity(.30)),
            ),
            child: Text(
              _levelGlyph(component.level),
              style: StatusMonitorTheme.mono.copyWith(
                color: color,
                fontSize: 15,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
          const SizedBox(width: 11),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  component.title,
                  style: StatusMonitorTheme.inter.copyWith(
                    color: StatusMonitorTheme.text,
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  component.detail,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: StatusMonitorTheme.mono.copyWith(
                    color: StatusMonitorTheme.dim,
                    fontSize: 9,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
          _LevelMark(level: component.level, size: 10),
        ],
      ),
    );
  }
}

class _LevelMark extends StatelessWidget {
  final StatusLevel level;
  final double size;

  const _LevelMark({
    required this.level,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    final color = _levelColor(level);
    return SizedBox(
      width: size,
      height: size,
      child: Center(
        child: Text(
          _levelGlyph(level),
          style: StatusMonitorTheme.mono.copyWith(
            color: color,
            fontSize: size,
            height: 1,
            fontWeight: FontWeight.w900,
          ),
        ),
      ),
    );
  }
}

String _shortName(String title) {
  if (title.toLowerCase().contains('sensor')) return 'Sensor';
  if (title.toLowerCase().contains('xdrip')) return 'Uploader';
  if (title.toLowerCase().contains('nightscout')) return 'Server';
  return title;
}

String _templateMeta(StatusWidgetTemplate template) {
  return switch (template) {
    StatusWidgetTemplate.compact => '${template.sizeLabel} - score + status',
    StatusWidgetTemplate.flow => '${template.sizeLabel} - link flow',
    StatusWidgetTemplate.issue => '${template.sizeLabel} - weakest signal',
    StatusWidgetTemplate.detailed => '${template.sizeLabel} - component rows',
  };
}

Color _levelColor(StatusLevel level) {
  return StatusMonitorTheme.colorFor(level);
}

String _levelGlyph(StatusLevel level) {
  return switch (level) {
    StatusLevel.healthy => '●',
    StatusLevel.watch => '▲',
    StatusLevel.issue => '■',
    StatusLevel.unknown => '○',
  };
}
