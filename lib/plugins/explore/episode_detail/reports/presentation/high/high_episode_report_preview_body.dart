import 'package:flutter/material.dart';
import 'package:smart_xdrip/foundation/theme/app_colors.dart';
import 'package:smart_xdrip/reporting/application/report_export_action.dart';
import 'package:smart_xdrip/reporting/domain/report_snapshot.dart';

import '../../high/high_episode_report_preview_controller.dart';
import '../../../application/i18n/episode_detail_l10n.dart';
import 'high_episode_report_preview_error.dart';
import 'high_episode_report_preview_top_bar.dart';
import 'high_episode_report_sheet.dart';

class HighEpisodeReportPreviewBody extends StatelessWidget {
  final HighEpisodeReportPreviewController controller;
  final ReportSnapshot? snapshot;
  final bool loading;
  final bool exporting;
  final Object? error;
  final VoidCallback onBack;

  const HighEpisodeReportPreviewBody({
    super.key,
    required this.controller,
    required this.snapshot,
    required this.loading,
    required this.exporting,
    required this.error,
    required this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE7EBE8),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 10, 14, 8),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 794),
                child: HighEpisodeReportPreviewTopBar(
                  exporting: exporting,
                  onBack: onBack,
                  onPrint: () => _export(context, ReportExportAction.save),
                  onShare: () => _export(context, ReportExportAction.share),
                ),
              ),
            ),
            Expanded(child: _content(context)),
          ],
        ),
      ),
    );
  }

  Widget _content(BuildContext context) {
    if (loading && snapshot == null) {
      return const Center(
        child: CircularProgressIndicator(color: AppColors.green),
      );
    }
    if (snapshot == null || error != null) {
      return HighEpisodeReportPreviewError(
        onRetry: () => controller.load(locale: Localizations.localeOf(context)),
      );
    }
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(14, 4, 14, 36),
      child: Center(child: HighEpisodeReportSheet(snapshot: snapshot!)),
    );
  }

  Future<void> _export(BuildContext context, ReportExportAction action) async {
    final ok = await controller.export(action);
    if (!context.mounted || ok) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(context.episodeDetailL10n.couldNotExportReport)),
    );
  }
}
