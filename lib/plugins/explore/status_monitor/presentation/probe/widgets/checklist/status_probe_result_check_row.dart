import 'package:flutter/material.dart';

import '../../../styles/status_monitor_theme.dart';
import '../../models/status_probe_result_row_vm.dart';
import '../../theme/status_probe_ui_theme.dart';
import '../shared/status_probe_icon_badge.dart';
import 'status_probe_result_guide_link.dart';
import 'status_probe_result_status_icon.dart';
import 'status_probe_result_yes_no_chip.dart';

class StatusProbeResultCheckRow extends StatelessWidget {
  final StatusProbeResultRowVm result;
  final ValueChanged<String> onOpenGuide;

  const StatusProbeResultCheckRow({
    super.key,
    required this.result,
    required this.onOpenGuide,
  });

  @override
  Widget build(BuildContext context) {
    final action = result.guideAction;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final narrow = constraints.maxWidth < 360;
          final trailing = result.running
              ? const _RunningChip()
              : result.pending
                  ? const _PendingChip()
                  : result.yes
                      ? const StatusProbeResultYesNoChip(yes: true)
                      : action == null
                          ? const StatusProbeResultYesNoChip(yes: false)
                          : StatusProbeResultGuideLink(
                              label: action.label,
                              onTap: () => onOpenGuide(action.route),
                            );
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              StatusProbeIconBadge(
                tone: result.state,
                icon: StatusProbeResultStatusIcon.forCode(result.code),
              ),
              const SizedBox(width: 11),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Wrap(
                      spacing: 7,
                      runSpacing: 5,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        Text(
                          result.title,
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: StatusMonitorTheme.text,
                                    fontWeight: FontWeight.w900,
                                    height: 1.2,
                                  ),
                        ),
                        _CodeTag(code: result.code),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      result.body,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: StatusMonitorTheme.soft,
                            fontSize: 10.5,
                            height: 1.34,
                          ),
                    ),
                    if (narrow) ...[
                      const SizedBox(height: 8),
                      Align(alignment: Alignment.centerLeft, child: trailing),
                    ],
                  ],
                ),
              ),
              if (!narrow) ...[
                const SizedBox(width: 10),
                Padding(
                  padding: const EdgeInsets.only(top: 3),
                  child: trailing,
                ),
              ],
            ],
          );
        },
      ),
    );
  }
}

class _PendingChip extends StatelessWidget {
  const _PendingChip();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 6),
      decoration: BoxDecoration(
        color: StatusMonitorTheme.bg.withOpacity(.36),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: StatusMonitorTheme.muted.withOpacity(.25)),
      ),
      child: Text(
        'Pending',
        style: StatusProbeUiTheme.mono(
          context,
          size: 9,
          weight: FontWeight.w900,
          color: StatusMonitorTheme.dim,
        ).copyWith(letterSpacing: .4),
      ),
    );
  }
}

class _RunningChip extends StatelessWidget {
  const _RunningChip();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 6),
      decoration: BoxDecoration(
        color: StatusMonitorTheme.green.withOpacity(.10),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: StatusMonitorTheme.green.withOpacity(.30)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(
            width: 10,
            height: 10,
            child: CircularProgressIndicator(
              strokeWidth: 1.8,
              color: StatusMonitorTheme.green,
            ),
          ),
          const SizedBox(width: 6),
          Text(
            'Checking',
            style: StatusProbeUiTheme.mono(
              context,
              size: 9,
              weight: FontWeight.w900,
              color: StatusMonitorTheme.green,
            ).copyWith(letterSpacing: .4),
          ),
        ],
      ),
    );
  }
}

class _CodeTag extends StatelessWidget {
  final String code;

  const _CodeTag({required this.code});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
      decoration: BoxDecoration(
        color: StatusMonitorTheme.bg.withOpacity(.45),
        borderRadius: BorderRadius.circular(5),
        border: Border.all(color: StatusMonitorTheme.muted.withOpacity(.32)),
      ),
      child: Text(
        code,
        style: StatusProbeUiTheme.mono(
          context,
          size: 8.5,
          color: StatusMonitorTheme.dim,
        ).copyWith(letterSpacing: .3),
      ),
    );
  }
}
