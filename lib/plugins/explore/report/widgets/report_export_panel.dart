import 'package:flutter/material.dart';
import 'package:smart_xdrip/reporting/application/report_export_action.dart';

import '../../../../foundation/theme/app_colors.dart';
import '../application/i18n/report_l10n.dart';

class ReportExportPanel extends StatelessWidget {
  final bool exporting;
  final bool enabled;
  final ValueChanged<ReportExportAction> onExport;

  const ReportExportPanel({
    super.key,
    required this.exporting,
    required this.enabled,
    required this.onExport,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = context.reportL10n;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _PrivacyNote(),
          const SizedBox(height: 10),
          Text(
            l10n.exportDescription,
            style: const TextStyle(
              fontFamily: 'JetBrainsMono',
              fontSize: 9,
              height: 1.5,
              color: AppColors.textDim,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _ActionButton(
                  label: l10n.exportSavePdf,
                  icon: Icons.picture_as_pdf_rounded,
                  primary: true,
                  disabled: !enabled || exporting,
                  loading: exporting,
                  onTap: () => onExport(ReportExportAction.save),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _ActionButton(
                  label: l10n.exportShareSend,
                  icon: Icons.ios_share_rounded,
                  disabled: !enabled || exporting,
                  onTap: () => onExport(ReportExportAction.share),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final bool primary;
  final IconData icon;
  final String label;
  final bool disabled;
  final bool loading;
  final VoidCallback onTap;

  const _ActionButton({
    this.primary = false,
    required this.icon,
    required this.label,
    required this.disabled,
    this.loading = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: disabled ? 0.55 : 1,
      child: GestureDetector(
        onTap: disabled ? null : onTap,
        behavior: HitTestBehavior.opaque,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
          decoration: BoxDecoration(
            color: primary ? AppColors.green : AppColors.bgCard2,
            border: Border.all(
              color: primary ? AppColors.green : AppColors.borderMid,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (loading)
                const SizedBox(
                  width: 15,
                  height: 15,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: AppColors.bg,
                  ),
                )
              else
                Icon(
                  icon,
                  size: 15,
                  color: primary ? AppColors.bg : AppColors.textSoft,
                ),
              const SizedBox(width: 7),
              Flexible(
                child: Text(
                  loading ? context.reportL10n.exportGenerating : label,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 12,
                    fontWeight: FontWeight.w900,
                    color: primary ? AppColors.bg : AppColors.text,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PrivacyNote extends StatelessWidget {
  const _PrivacyNote();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.blue.withOpacity(0.06),
        border: Border.all(color: AppColors.blue.withOpacity(0.18)),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.lock_outline_rounded,
              color: AppColors.blue, size: 16),
          const SizedBox(width: 9),
          Expanded(
            child: Text(
              context.reportL10n.exportPrivacyNote,
              style: const TextStyle(
                fontFamily: 'Inter',
                fontSize: 11,
                height: 1.5,
                color: AppColors.textSoft,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
