import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

import '../../../styles/status_monitor_theme.dart';
import '../../theme/status_probe_ui_theme.dart';

class StatusProbeGuideShell extends StatelessWidget {
  final String eyebrow;
  final String title;
  final String subtitle;
  final String heroTitle;
  final String heroBody;
  final IconData icon;
  final List<Widget> children;

  const StatusProbeGuideShell({
    super.key,
    required this.eyebrow,
    required this.title,
    required this.subtitle,
    required this.heroTitle,
    required this.heroBody,
    required this.icon,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    final isTablet = StatusMonitorTheme.isTablet(context);
    final contentWidth = isTablet
        ? StatusMonitorTheme.tabletContentWidth
        : StatusMonitorTheme.phoneContentWidth;

    return Scaffold(
      backgroundColor: StatusMonitorTheme.bg,
      appBar: AppBar(
        title: Text(title),
        backgroundColor: StatusMonitorTheme.bg,
        foregroundColor: StatusMonitorTheme.text,
        elevation: 0,
        actions: [
          IconButton(
            tooltip: 'Open Hub',
            onPressed: () => context.push('/explore/status/hub'),
            icon: const Icon(Icons.hub_rounded),
          ),
        ],
      ),
      body: DecoratedBox(
        decoration: StatusMonitorTheme.pageBackground(),
        child: SafeArea(
          top: false,
          child: SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(
              StatusMonitorTheme.horizontalGutter(context),
              8,
              StatusMonitorTheme.horizontalGutter(context),
              28,
            ),
            child: Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: contentWidth),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    StatusProbeGuideHero(
                      eyebrow: eyebrow,
                      title: title,
                      subtitle: subtitle,
                      heroTitle: heroTitle,
                      heroBody: heroBody,
                      icon: icon,
                    ),
                    const SizedBox(height: 16),
                    ...children,
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class StatusProbeGuideHero extends StatelessWidget {
  final String eyebrow;
  final String title;
  final String subtitle;
  final String heroTitle;
  final String heroBody;
  final IconData icon;

  const StatusProbeGuideHero({
    super.key,
    required this.eyebrow,
    required this.title,
    required this.subtitle,
    required this.heroTitle,
    required this.heroBody,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return StatusProbeGuideCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: StatusMonitorTheme.green.withOpacity(.10),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: StatusMonitorTheme.green.withOpacity(.34),
                  ),
                ),
                child: Icon(icon, color: StatusMonitorTheme.green, size: 24),
              ),
              const SizedBox(width: 13),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      eyebrow.toUpperCase(),
                      style: StatusProbeUiTheme.mono(
                        context,
                        size: 9,
                        weight: FontWeight.w900,
                        color: StatusMonitorTheme.green,
                      ).copyWith(letterSpacing: 1.2),
                    ),
                    const SizedBox(height: 7),
                    Text(
                      title,
                      style:
                          Theme.of(context).textTheme.headlineSmall?.copyWith(
                                color: StatusMonitorTheme.text,
                                fontSize: 22,
                                fontWeight: FontWeight.w900,
                                height: 1.05,
                              ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      subtitle,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: StatusMonitorTheme.soft,
                            fontSize: 12,
                            height: 1.35,
                          ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            heroTitle,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: StatusMonitorTheme.text,
                  fontSize: 16,
                  fontWeight: FontWeight.w900,
                ),
          ),
          const SizedBox(height: 7),
          Text(
            heroBody,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: StatusMonitorTheme.soft,
                  fontSize: 12,
                  height: 1.45,
                ),
          ),
        ],
      ),
    );
  }
}

class StatusProbeGuideSectionLabel extends StatelessWidget {
  final String left;
  final String right;

  const StatusProbeGuideSectionLabel({
    super.key,
    required this.left,
    required this.right,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(2, 16, 2, 8),
      child: Row(
        children: [
          Expanded(
            child: Text(
              left.toUpperCase(),
              style: StatusProbeUiTheme.mono(
                context,
                size: 9.5,
                weight: FontWeight.w900,
                color: StatusMonitorTheme.green,
              ).copyWith(letterSpacing: 1.1),
            ),
          ),
          Text(
            right,
            style: StatusProbeUiTheme.mono(
              context,
              size: 9,
              weight: FontWeight.w800,
              color: StatusMonitorTheme.dim,
            ),
          ),
        ],
      ),
    );
  }
}

class StatusProbeGuideCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;

  const StatusProbeGuideCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(14),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: padding,
      decoration: StatusProbeUiTheme.probeCard(),
      child: child,
    );
  }
}

class StatusProbeSetupStepCard extends StatelessWidget {
  final int number;
  final String title;
  final String body;
  final String? pathLabel;
  final String? pathValue;
  final String? code;

  const StatusProbeSetupStepCard({
    super.key,
    required this.number,
    required this.title,
    required this.body,
    this.pathLabel,
    this.pathValue,
    this.code,
  });

  @override
  Widget build(BuildContext context) {
    return StatusProbeGuideCard(
      padding: const EdgeInsets.all(12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 28,
            height: 28,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: StatusMonitorTheme.green.withOpacity(.10),
              borderRadius: BorderRadius.circular(10),
              border:
                  Border.all(color: StatusMonitorTheme.green.withOpacity(.32)),
            ),
            child: Text(
              '$number',
              style: StatusProbeUiTheme.mono(
                context,
                size: 12,
                weight: FontWeight.w900,
                color: StatusMonitorTheme.green,
              ),
            ),
          ),
          const SizedBox(width: 11),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: StatusMonitorTheme.text,
                        fontSize: 13,
                        fontWeight: FontWeight.w900,
                      ),
                ),
                const SizedBox(height: 5),
                Text(
                  body,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: StatusMonitorTheme.soft,
                        fontSize: 11,
                        height: 1.38,
                      ),
                ),
                if (pathLabel != null && pathValue != null) ...[
                  const SizedBox(height: 9),
                  StatusProbeSettingPath(
                    label: pathLabel!,
                    value: pathValue!,
                    code: code,
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class StatusProbeSettingPath extends StatelessWidget {
  final String label;
  final String value;
  final String? code;

  const StatusProbeSettingPath({
    super.key,
    required this.label,
    required this.value,
    this.code,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: StatusMonitorTheme.bg.withOpacity(.36),
        borderRadius: BorderRadius.circular(11),
        border: Border.all(color: StatusMonitorTheme.line.withOpacity(.65)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: StatusProbeUiTheme.mono(
              context,
              size: 8.5,
              weight: FontWeight.w900,
              color: StatusMonitorTheme.green,
            ).copyWith(letterSpacing: .8),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: StatusMonitorTheme.text,
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  height: 1.25,
                ),
          ),
          if (code != null) ...[
            const SizedBox(height: 8),
            StatusProbePackageCopyCard(packageName: code!),
          ],
        ],
      ),
    );
  }
}

class StatusProbePackageCopyCard extends StatelessWidget {
  final String packageName;
  final String label;

  const StatusProbePackageCopyCard({
    super.key,
    this.packageName = 'com.metaguru.smartxdrip',
    this.label = 'Receiver package',
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 9),
      decoration: BoxDecoration(
        color: StatusMonitorTheme.green.withOpacity(.08),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: StatusMonitorTheme.green.withOpacity(.30)),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.content_copy_rounded,
            color: StatusMonitorTheme.green,
            size: 16,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: StatusProbeUiTheme.mono(
                    context,
                    size: 8.5,
                    weight: FontWeight.w900,
                    color: StatusMonitorTheme.green,
                  ).copyWith(letterSpacing: .7),
                ),
                const SizedBox(height: 3),
                Text(
                  packageName,
                  style: StatusProbeUiTheme.mono(
                    context,
                    size: 10.5,
                    weight: FontWeight.w900,
                    color: StatusMonitorTheme.text,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () {
              Clipboard.setData(ClipboardData(text: packageName));
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Package copied')),
              );
            },
            tooltip: 'Copy package',
            icon: const Icon(Icons.copy_rounded, size: 17),
            style: IconButton.styleFrom(
              foregroundColor: StatusMonitorTheme.green,
              backgroundColor: StatusMonitorTheme.green.withOpacity(.10),
              minimumSize: const Size(34, 34),
              fixedSize: const Size(34, 34),
              padding: EdgeInsets.zero,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(11),
                side: BorderSide(
                  color: StatusMonitorTheme.green.withOpacity(.24),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class StatusProbeCheckListCard extends StatelessWidget {
  final List<StatusProbeCheckItem> items;

  const StatusProbeCheckListCard({
    super.key,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return StatusProbeGuideCard(
      padding: EdgeInsets.zero,
      child: Column(
        children: [
          for (var i = 0; i < items.length; i++) ...[
            items[i],
            if (i != items.length - 1)
              Divider(
                  height: 1, color: StatusMonitorTheme.line.withOpacity(.55)),
          ],
        ],
      ),
    );
  }
}

class StatusProbeCheckItem extends StatelessWidget {
  final String title;
  final String body;
  final String stateLabel;
  final String tone;
  final String code;

  const StatusProbeCheckItem({
    super.key,
    required this.title,
    required this.body,
    required this.stateLabel,
    required this.tone,
    required this.code,
  });

  @override
  Widget build(BuildContext context) {
    final color = StatusProbeUiTheme.toneColor(tone);
    return Padding(
      padding: const EdgeInsets.all(11),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 34,
            height: 34,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: color.withOpacity(.08),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: color.withOpacity(.30)),
            ),
            child: Text(
              code,
              style: StatusProbeUiTheme.mono(
                context,
                size: 9,
                weight: FontWeight.w900,
                color: color,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: StatusMonitorTheme.text,
                        fontSize: 12.5,
                        fontWeight: FontWeight.w900,
                      ),
                ),
                const SizedBox(height: 4),
                Text(
                  body,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: StatusMonitorTheme.soft,
                        fontSize: 10.5,
                        height: 1.35,
                      ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Text(
            stateLabel,
            style: StatusProbeUiTheme.mono(
              context,
              size: 9,
              weight: FontWeight.w900,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

class StatusProbeGuideNote extends StatelessWidget {
  final String title;
  final String body;
  final IconData icon;

  const StatusProbeGuideNote({
    super.key,
    required this.title,
    required this.body,
    this.icon = Icons.info_outline_rounded,
  });

  @override
  Widget build(BuildContext context) {
    return StatusProbeGuideCard(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: StatusMonitorTheme.green, size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: StatusMonitorTheme.text,
                        fontSize: 13,
                        fontWeight: FontWeight.w900,
                      ),
                ),
                const SizedBox(height: 5),
                Text(
                  body,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: StatusMonitorTheme.soft,
                        fontSize: 11,
                        height: 1.42,
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
