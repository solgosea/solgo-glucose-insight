import 'package:flutter/material.dart';
import 'package:smart_xdrip/domain/data_source/data_source_sync_strategy_action.dart';
import 'package:smart_xdrip/domain/data_source/data_source_kind.dart';
import 'package:smart_xdrip/foundation/theme/app_colors.dart';
import 'package:smart_xdrip/presentation/common/sync_status/sync_status_inline_row.dart';

import '../models/profile_view_model.dart';

class ProfileDataSourceCard extends StatelessWidget {
  final List<ProfileDataSourceViewModel> sources;
  final ValueChanged<ProfileDataSourceViewModel> onSourceAction;
  final ValueChanged<ProfileDataSourceViewModel> onSourceStrategyAction;
  final ValueChanged<ProfileDataSourceViewModel> onSourceSecondaryAction;

  const ProfileDataSourceCard({
    super.key,
    required this.sources,
    required this.onSourceAction,
    required this.onSourceStrategyAction,
    required this.onSourceSecondaryAction,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 0, 20, 4),
      decoration: BoxDecoration(
        color: AppColors.bgCard,
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(16),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          for (var i = 0; i < sources.length; i++) ...[
            _SourceRow(
              source: sources[i],
              onAction:
                  sources[i].actionEnabled
                      ? () => onSourceAction(sources[i])
                      : null,
              onStrategyAction:
                  sources[i].strategyActionEnabled
                      ? () => onSourceStrategyAction(sources[i])
                      : null,
              onEditUrl: () => onSourceSecondaryAction(sources[i]),
            ),
            if (i != sources.length - 1) const _DashedDivider(),
          ],
        ],
      ),
    );
  }
}

class _SourceRow extends StatelessWidget {
  final ProfileDataSourceViewModel source;
  final VoidCallback? onAction;
  final VoidCallback? onStrategyAction;
  final VoidCallback onEditUrl;

  const _SourceRow({
    required this.source,
    required this.onAction,
    required this.onStrategyAction,
    required this.onEditUrl,
  });

  bool get _showEditUrl =>
      source.kind == DataSourceKind.nightscout &&
      source.secondaryAction != null;

  bool get _canToggleStrategy =>
      source.strategyAction == DataSourceSyncStrategyAction.enable ||
      source.strategyAction == DataSourceSyncStrategyAction.disable;

  bool get _showConnectionAction =>
      source.actionEnabled && source.trailing.trim().isNotEmpty;

  Color get _dotColor {
    if (!source.active && source.muted) return AppColors.border;
    if (source.active && source.statusColor == AppColors.rose) {
      return AppColors.amber;
    }
    if (source.active) return AppColors.green;
    return source.statusColor;
  }

  bool get _dotFilled => source.active || !source.muted;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      decoration: BoxDecoration(
        color:
            source.active
                ? AppColors.green.withOpacity(0.04)
                : Colors.transparent,
      ),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Left accent bar, only when active.
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 3,
              color: source.active ? AppColors.green : Colors.transparent,
            ),
            // Content
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(14, 14, 14, 14),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 1),
                      child: _SourceStatusDot(
                        filled: _dotFilled,
                        color: _dotColor,
                        muted: source.muted,
                        pulsing: source.pulsing,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Text(
                                  source.name,
                                  style: TextStyle(
                                    fontFamily: 'Inter',
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color:
                                        source.muted
                                            ? AppColors.textDim
                                            : AppColors.text,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              // Action area: connection actions and strategy switch stay separate.
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  if (_showConnectionAction) ...[
                                    _ActionPill(
                                      key: Key(
                                        'source-action-${source.kind.name}',
                                      ),
                                      label: source.trailing,
                                      style: source.actionStyle,
                                      enabled: source.actionEnabled,
                                      onTap: onAction,
                                    ),
                                    const SizedBox(width: 8),
                                  ],
                                  _SourceSwitch(
                                    key: Key(
                                      'source-switch-${source.kind.name}',
                                    ),
                                    value: source.active,
                                    enabled: _canToggleStrategy,
                                    onChanged:
                                        _canToggleStrategy
                                            ? onStrategyAction
                                            : null,
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            source.subtitle,
                            style: TextStyle(
                              fontFamily:
                                  source.subtitle.contains('://')
                                      ? 'JetBrainsMono'
                                      : 'Inter',
                              fontSize: 11,
                              color: AppColors.textSoft,
                            ),
                          ),
                          if (source.syncStatus != null) ...[
                            const SizedBox(height: 5),
                            SyncStatusInlineRow(
                              viewModel: source.syncStatus!,
                              muted: source.muted,
                            ),
                          ] else if (source.meta != null &&
                              source.meta!.isNotEmpty) ...[
                            const SizedBox(height: 3),
                            Row(
                              children: [
                                if (source.pulsing) ...[
                                  // ignore: prefer_const_constructors
                                  _PulsingDot(color: AppColors.green),
                                  const SizedBox(width: 5),
                                ],
                                Expanded(
                                  child: Text(
                                    source.meta!,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontFamily: 'Inter',
                                      fontSize: 11,
                                      color:
                                          source.active
                                              ? AppColors.green
                                              : AppColors.textDim,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                          if (_showEditUrl) ...[
                            const SizedBox(height: 8),
                            GestureDetector(
                              onTap: onEditUrl,
                              behavior: HitTestBehavior.opaque,
                              child: const Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    'Edit URL',
                                    style: TextStyle(
                                      fontFamily: 'Inter',
                                      fontSize: 11,
                                      fontWeight: FontWeight.w500,
                                      color: AppColors.textSoft,
                                    ),
                                  ),
                                  SizedBox(width: 2),
                                  Icon(
                                    Icons.arrow_forward_ios_rounded,
                                    size: 9,
                                    color: AppColors.textDim,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SourceStatusDot extends StatelessWidget {
  final bool filled;
  final Color color;
  final bool muted;
  final bool pulsing;

  const _SourceStatusDot({
    required this.filled,
    required this.color,
    required this.muted,
    required this.pulsing,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      width: 18,
      height: 18,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: filled ? color.withOpacity(0.12) : Colors.transparent,
        border: Border.all(
          color: muted ? AppColors.border : color,
          width: filled ? 1.6 : 1.2,
        ),
        boxShadow:
            filled && !muted
                ? [BoxShadow(color: color.withOpacity(0.30), blurRadius: 8)]
                : null,
      ),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: filled ? color : Colors.transparent,
        ),
      ),
    );
  }
}

class _PulsingDot extends StatefulWidget {
  final Color color;
  const _PulsingDot({required this.color});

  @override
  State<_PulsingDot> createState() => _PulsingDotState();
}

class _PulsingDotState extends State<_PulsingDot>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _ctrl,
      builder:
          (_, __) => Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: widget.color.withOpacity(0.5 + _ctrl.value * 0.5),
              boxShadow: [
                BoxShadow(
                  color: widget.color.withOpacity(0.4 * _ctrl.value),
                  blurRadius: 6,
                ),
              ],
            ),
          ),
    );
  }
}

class _ActionPill extends StatelessWidget {
  final String label;
  final ProfileDataSourceActionStyle style;
  final bool enabled;
  final VoidCallback? onTap;

  const _ActionPill({
    super.key,
    required this.label,
    required this.style,
    required this.enabled,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final p = _palette();
    final pill = AnimatedContainer(
      duration: const Duration(milliseconds: 160),
      constraints: const BoxConstraints(minWidth: 72),
      padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 7),
      decoration: BoxDecoration(
        color: enabled ? p.bg : AppColors.bgCard2,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: enabled ? p.border : AppColors.border),
        boxShadow:
            enabled && style == ProfileDataSourceActionStyle.primary
                ? [
                  BoxShadow(
                    color: AppColors.green.withOpacity(0.18),
                    blurRadius: 12,
                    offset: const Offset(0, 3),
                  ),
                ]
                : null,
      ),
      child: Text(
        label,
        textAlign: TextAlign.center,
        maxLines: 1,
        style: TextStyle(
          fontFamily: 'Inter',
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: enabled ? p.text : AppColors.textDim,
        ),
      ),
    );

    if (!enabled || onTap == null) return pill;
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: pill,
    );
  }

  _Palette _palette() => switch (style) {
    ProfileDataSourceActionStyle.primary => _Palette(
      bg: AppColors.green.withOpacity(0.13),
      border: AppColors.green.withOpacity(0.70),
      text: AppColors.green,
    ),
    ProfileDataSourceActionStyle.secondary => _Palette(
      bg: AppColors.amber.withOpacity(0.11),
      border: AppColors.amber.withOpacity(0.55),
      text: AppColors.amber,
    ),
    ProfileDataSourceActionStyle.warning => const _Palette(
      bg: AppColors.bg,
      border: AppColors.borderMid,
      text: AppColors.textSoft,
    ),
    ProfileDataSourceActionStyle.destructive => _Palette(
      bg: AppColors.rose.withOpacity(0.11),
      border: AppColors.rose.withOpacity(0.60),
      text: AppColors.rose,
    ),
    ProfileDataSourceActionStyle.disabled => const _Palette(
      bg: AppColors.bgCard2,
      border: AppColors.border,
      text: AppColors.textDim,
    ),
  };
}

class _Palette {
  final Color bg, border, text;
  const _Palette({required this.bg, required this.border, required this.text});
}

class _SourceSwitch extends StatelessWidget {
  final bool value;
  final bool enabled;
  final VoidCallback? onChanged;

  const _SourceSwitch({
    super.key,
    required this.value,
    required this.enabled,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final active = value && enabled;
    final trackColor = active ? AppColors.green : AppColors.border;
    final thumbColor = enabled ? Colors.white : AppColors.textDim;

    return GestureDetector(
      onTap: enabled ? onChanged : null,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 51,
        height: 31,
        padding: const EdgeInsets.all(2),
        decoration: BoxDecoration(
          color: active ? AppColors.green.withOpacity(0.3) : AppColors.bgCard2,
          borderRadius: BorderRadius.circular(999),
          border: Border.all(color: trackColor, width: 1.5),
        ),
        child: Stack(
          children: [
            AnimatedPositioned(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeInOut,
              left: active ? 22 : 0,
              top: 0,
              bottom: 0,
              child: Container(
                width: 25,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: thumbColor,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.15),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DashedDivider extends StatelessWidget {
  const _DashedDivider();

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: const Size(double.infinity, 1),
      painter: _DashPainter(),
    );
  }
}

class _DashPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    const dashW = 4.0;
    const gapW = 4.0;
    final paint =
        Paint()
          ..color = AppColors.border
          ..strokeWidth = 1;
    double x = 0;
    while (x < size.width) {
      canvas.drawLine(Offset(x, 0), Offset(x + dashW, 0), paint);
      x += dashW + gapW;
    }
  }

  @override
  bool shouldRepaint(_DashPainter _) => false;
}
