import 'package:flutter/material.dart';
import 'package:smart_xdrip/domain/data_source/data_source_kind.dart';
import 'package:smart_xdrip/domain/data_source/data_source_sync_strategy_action.dart';
import 'package:smart_xdrip/foundation/theme/app_colors.dart';
import 'package:smart_xdrip/presentation/common/sync_status/sync_runtime_limitation_notice.dart';
import 'package:smart_xdrip/presentation/common/sync_status/sync_status_inline_row.dart';

import 'datasource_profile_view_model.dart';

class DatasourceProfileCard extends StatelessWidget {
  final DatasourceProfileViewModel viewModel;
  final ValueChanged<DatasourceProfileSourceViewModel> onSourceAction;
  final ValueChanged<DatasourceProfileSourceViewModel> onSourceStrategyAction;
  final ValueChanged<DatasourceProfileSourceViewModel> onSourceSecondaryAction;
  final VoidCallback? onSyncCountdownDue;

  const DatasourceProfileCard({
    super.key,
    required this.viewModel,
    required this.onSourceAction,
    required this.onSourceStrategyAction,
    required this.onSourceSecondaryAction,
    this.onSyncCountdownDue,
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
          if (viewModel.refreshing)
            LinearProgressIndicator(
              minHeight: 2,
              backgroundColor: AppColors.bgCard2,
              color: AppColors.green.withOpacity(0.72),
            ),
          if (viewModel.recoverableErrorText != null)
            _RecoverableErrorBanner(message: viewModel.recoverableErrorText!),
          for (var i = 0; i < viewModel.sources.length; i++) ...[
            _SourceRow(
              source: viewModel.sources[i],
              onAction: viewModel.sources[i].actionEnabled
                  ? () => onSourceAction(viewModel.sources[i])
                  : null,
              onStrategyAction: viewModel.sources[i].strategyActionEnabled
                  ? () => onSourceStrategyAction(viewModel.sources[i])
                  : null,
              onEditUrl: () => onSourceSecondaryAction(viewModel.sources[i]),
              onSyncCountdownDue: onSyncCountdownDue,
            ),
            if (i != viewModel.sources.length - 1) const Divider(height: 1),
          ],
          if (viewModel.runtimeLimitationText.trim().isNotEmpty)
            SyncRuntimeLimitationNotice(
              message: viewModel.runtimeLimitationText,
              foregroundLabel: viewModel.foregroundReconcileLabel,
              margin: const EdgeInsets.fromLTRB(14, 0, 14, 14),
            ),
        ],
      ),
    );
  }
}

class _RecoverableErrorBanner extends StatelessWidget {
  final String message;

  const _RecoverableErrorBanner({required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(14, 9, 14, 9),
      color: AppColors.amber.withOpacity(0.08),
      child: Row(
        children: [
          Icon(
            Icons.info_outline_rounded,
            size: 14,
            color: AppColors.amber.withOpacity(0.95),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              message,
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 11,
                color: AppColors.amber.withOpacity(0.95),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SourceRow extends StatelessWidget {
  final DatasourceProfileSourceViewModel source;
  final VoidCallback? onAction;
  final VoidCallback? onStrategyAction;
  final VoidCallback onEditUrl;
  final VoidCallback? onSyncCountdownDue;

  const _SourceRow({
    required this.source,
    required this.onAction,
    required this.onStrategyAction,
    required this.onEditUrl,
    this.onSyncCountdownDue,
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
        color: source.active
            ? AppColors.green.withOpacity(0.04)
            : Colors.transparent,
      ),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 3,
              color: source.active ? AppColors.green : Colors.transparent,
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(14, 14, 14, 14),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 1),
                      child: _StatusDot(
                        filled: _dotFilled,
                        color: _dotColor,
                        muted: source.muted,
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
                                    color: source.muted
                                        ? AppColors.textDim
                                        : AppColors.text,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  if (_showConnectionAction) ...[
                                    _ActionPill(
                                      label: source.trailing,
                                      style: source.actionStyle,
                                      enabled: source.actionEnabled,
                                      onTap: onAction,
                                    ),
                                    const SizedBox(width: 8),
                                  ],
                                  _SourceSwitch(
                                    value: source.active,
                                    enabled: _canToggleStrategy,
                                    onChanged: _canToggleStrategy
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
                              fontFamily: source.subtitle.contains('://')
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
                              onCountdownDue: onSyncCountdownDue,
                            ),
                          ] else if (source.meta != null &&
                              source.meta!.isNotEmpty) ...[
                            const SizedBox(height: 3),
                            Text(
                              source.meta!,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 11,
                                color: source.active
                                    ? AppColors.green
                                    : AppColors.textDim,
                              ),
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

class _StatusDot extends StatelessWidget {
  final bool filled;
  final Color color;
  final bool muted;

  const _StatusDot({
    required this.filled,
    required this.color,
    required this.muted,
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
        boxShadow: filled && !muted
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

class _ActionPill extends StatelessWidget {
  final String label;
  final DatasourceProfileActionStyle style;
  final bool enabled;
  final VoidCallback? onTap;

  const _ActionPill({
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
    return GestureDetector(onTap: onTap, child: pill);
  }

  _Palette _palette() => switch (style) {
        DatasourceProfileActionStyle.primary => _Palette(
            bg: AppColors.green.withOpacity(0.13),
            border: AppColors.green.withOpacity(0.70),
            text: AppColors.green,
          ),
        DatasourceProfileActionStyle.secondary => _Palette(
            bg: AppColors.amber.withOpacity(0.11),
            border: AppColors.amber.withOpacity(0.55),
            text: AppColors.amber,
          ),
        DatasourceProfileActionStyle.warning => const _Palette(
            bg: AppColors.bg,
            border: AppColors.borderMid,
            text: AppColors.textSoft,
          ),
        DatasourceProfileActionStyle.destructive => _Palette(
            bg: AppColors.rose.withOpacity(0.11),
            border: AppColors.rose.withOpacity(0.60),
            text: AppColors.rose,
          ),
        DatasourceProfileActionStyle.disabled => const _Palette(
            bg: AppColors.bgCard2,
            border: AppColors.border,
            text: AppColors.textDim,
          ),
      };
}

class _Palette {
  final Color bg;
  final Color border;
  final Color text;

  const _Palette({
    required this.bg,
    required this.border,
    required this.text,
  });
}

class _SourceSwitch extends StatelessWidget {
  final bool value;
  final bool enabled;
  final VoidCallback? onChanged;

  const _SourceSwitch({
    required this.value,
    required this.enabled,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final active = value && enabled;
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
          border: Border.all(
            color: active ? AppColors.green : AppColors.border,
            width: 1.5,
          ),
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
                  color: enabled ? Colors.white : AppColors.textDim,
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
