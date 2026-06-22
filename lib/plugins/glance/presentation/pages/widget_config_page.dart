// ignore_for_file: prefer_const_constructors

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../domain/entities/app_settings.dart';
import '../../../../plugin_platform/services/plugin_service_registry.dart';
import '../../application/glance_snapshot_service.dart';
import '../../application/glance_widget_config_service.dart';
import '../../application/i18n/glance_l10n.dart';
import '../../data/sqlite/sqlite_glance_widget_config_repository.dart';
import '../../domain/glance_snapshot.dart';
import '../../domain/widget_background_style.dart';
import '../../domain/widget_font_size.dart';
import '../../domain/widget_graph_range.dart';
import '../../domain/widget_tap_action.dart';
import '../../domain/widget_template.dart';
import '../controllers/widget_config_controller.dart';
import '../styles/glance_theme.dart';
import '../widgets/glance_segmented_option.dart';
import '../widgets/glance_widget_preview.dart';
import '../widgets/glance_widget_template_chip.dart';

class WidgetConfigPage extends StatefulWidget {
  const WidgetConfigPage({super.key});

  @override
  State<WidgetConfigPage> createState() => _WidgetConfigPageState();
}

class _WidgetConfigPageState extends State<WidgetConfigPage> {
  late final WidgetConfigController controller;

  @override
  void initState() {
    super.initState();
    final services = context.read<PluginServiceRegistry>();
    controller = WidgetConfigController(
      configService: services.get<GlanceWidgetConfigService>(),
      snapshotService: services.get<GlanceSnapshotService>(),
      settingsProvider: services.get<AppSettings Function()>(),
    );
    unawaited(controller.load());
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.glanceL10n;
    return Scaffold(
      backgroundColor: GlanceTheme.bg,
      appBar: AppBar(
        backgroundColor: GlanceTheme.bg,
        foregroundColor: GlanceTheme.text,
        elevation: 0,
        title: Text(
          'Configure widget',
          style: GlanceTheme.mono.copyWith(
            fontSize: 16,
            fontWeight: FontWeight.w900,
          ),
        ),
      ),
      body: AnimatedBuilder(
        animation: controller,
        builder: (context, _) {
          final config = controller.config;
          final snapshot = controller.snapshot;
          if (controller.loading || config == null || snapshot == null) {
            return const Center(
              child: CircularProgressIndicator(color: GlanceTheme.green),
            );
          }
          return ListView(
            padding: const EdgeInsets.fromLTRB(18, 8, 18, 28),
            children: [
              _WidgetPreviewStage(
                snapshot: snapshot,
                config: config,
              ),
              const SizedBox(height: 18),
              _Label('Template'),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    for (final template in GlanceWidgetTemplate.values) ...[
                      GlanceWidgetTemplateChip(
                        template: template,
                        selected: config.template == template,
                        onTap: () => controller.update(
                          config.copyWith(template: template),
                        ),
                      ),
                      const SizedBox(width: 8),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 20),
              _Label('Background'),
              GlanceSegmentedOption(
                values: GlanceWidgetBackgroundStyle.values,
                selected: config.backgroundStyle,
                labelBuilder: (value) => value.label,
                onChanged: (value) =>
                    controller.update(config.copyWith(backgroundStyle: value)),
              ),
              const SizedBox(height: 20),
              _Label('Font size'),
              GlanceSegmentedOption(
                values: GlanceWidgetFontSize.values,
                selected: config.fontSize,
                labelBuilder: (value) => value.label,
                onChanged: (value) =>
                    controller.update(config.copyWith(fontSize: value)),
              ),
              const SizedBox(height: 20),
              _Label(l10n.glanceWidgetGraphRange),
              GlanceSegmentedOption(
                values: GlanceWidgetGraphRange.values,
                selected: config.graphRange,
                labelBuilder: (value) => value.label,
                onChanged: (value) =>
                    controller.update(config.copyWith(graphRange: value)),
              ),
              const SizedBox(height: 20),
              _Label(l10n.glanceWidgetShowOnWidget),
              _SwitchRow(
                label: l10n.glanceWidgetTrendArrow,
                value: config.showTrendArrow,
                onChanged: (value) => controller.update(
                  config.copyWith(showTrendArrow: value),
                ),
              ),
              _SwitchRow(
                label: l10n.glanceWidgetDelta,
                value: config.showDelta,
                onChanged: (value) => controller.update(
                  config.copyWith(showDelta: value),
                ),
              ),
              _SwitchRow(
                label: l10n.glanceWidgetLastUpdated,
                value: config.showLastUpdated,
                onChanged: (value) => controller.update(
                  config.copyWith(showLastUpdated: value),
                ),
              ),
              _SwitchRow(
                label: l10n.glanceWidgetMiniGraph,
                value: config.showMiniGraph,
                onChanged: (value) => controller.update(
                  config.copyWith(showMiniGraph: value),
                ),
              ),
              const SizedBox(height: 20),
              _Label(l10n.glanceWidgetTapAction),
              GlanceSegmentedOption(
                values: GlanceWidgetTapAction.values,
                selected: config.tapAction,
                labelBuilder: (value) => value.label,
                onChanged: (value) =>
                    controller.update(config.copyWith(tapAction: value)),
              ),
              const SizedBox(height: 24),
              FilledButton(
                style: FilledButton.styleFrom(
                  backgroundColor: GlanceTheme.green,
                  foregroundColor: const Color(0xFF082016),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                onPressed: () async {
                  await controller.save();
                  if (!context.mounted) return;
                  _showWidgetSavedToast(context);
                },
                child: Text(l10n.glanceWidgetAddWidget),
              ),
            ],
          );
        },
      ),
    );
  }
}

void _showWidgetSavedToast(BuildContext context) {
  final messenger = ScaffoldMessenger.of(context);
  messenger
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        elevation: 0,
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.transparent,
        margin: const EdgeInsets.fromLTRB(18, 0, 18, 18),
        duration: const Duration(seconds: 2),
        content: Container(
          padding: const EdgeInsets.fromLTRB(13, 12, 14, 12),
          decoration: BoxDecoration(
            color: const Color(0xF214221D),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: GlanceTheme.green.withOpacity(.28)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(.34),
                blurRadius: 22,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 31,
                height: 31,
                decoration: BoxDecoration(
                  color: GlanceTheme.green.withOpacity(.16),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: GlanceTheme.green.withOpacity(.42),
                  ),
                ),
                child: const Icon(
                  Icons.check_rounded,
                  color: GlanceTheme.green,
                  size: 18,
                ),
              ),
              const SizedBox(width: 11),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Widget updated',
                      style: GlanceTheme.label.copyWith(
                        color: GlanceTheme.text,
                        fontSize: 12.5,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Your home screen preview will refresh shortly.',
                      style: GlanceTheme.label.copyWith(
                        color: GlanceTheme.soft,
                        fontSize: 10.5,
                        height: 1.25,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
}

class _WidgetPreviewStage extends StatelessWidget {
  final GlanceSnapshot snapshot;
  final GlanceWidgetConfig config;

  const _WidgetPreviewStage({
    required this.snapshot,
    required this.config,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF15233F),
            Color(0xFF122A2C),
            Color(0xFF1A1730),
          ],
        ),
        border: Border.all(color: Colors.white.withOpacity(.08)),
      ),
      child: Center(
        child: FractionallySizedBox(
          widthFactor: _widthFactor(config.template),
          child: AspectRatio(
            aspectRatio: _aspectRatio(config.template),
            child: GlanceWidgetPreview(
              snapshot: snapshot,
              config: config,
            ),
          ),
        ),
      ),
    );
  }

  double _aspectRatio(GlanceWidgetTemplate template) {
    return switch (template) {
      GlanceWidgetTemplate.compact => 2.25,
      GlanceWidgetTemplate.trend => 2.25,
      GlanceWidgetTemplate.dashboard => 1.56,
      GlanceWidgetTemplate.dualUnit => 1.0,
    };
  }

  double _widthFactor(GlanceWidgetTemplate template) {
    return switch (template) {
      GlanceWidgetTemplate.compact => .62,
      GlanceWidgetTemplate.trend => 1.0,
      GlanceWidgetTemplate.dashboard => 1.0,
      GlanceWidgetTemplate.dualUnit => .58,
    };
  }
}

class _Label extends StatelessWidget {
  final String text;

  const _Label(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 9),
      child: Text(
        text.toUpperCase(),
        style: GlanceTheme.mono.copyWith(
          color: GlanceTheme.dim,
          fontSize: 10,
          fontWeight: FontWeight.w900,
          letterSpacing: 0,
        ),
      ),
    );
  }
}

class _SwitchRow extends StatelessWidget {
  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _SwitchRow({
    required this.label,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 10),
      decoration: BoxDecoration(
        color: GlanceTheme.card,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: GlanceTheme.border),
      ),
      child: Row(
        children: [
          Text(
            label,
            style: GlanceTheme.mono.copyWith(
              color: GlanceTheme.soft,
              fontSize: 12,
              fontWeight: FontWeight.w700,
            ),
          ),
          const Spacer(),
          Switch(
            value: value,
            activeColor: GlanceTheme.green,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}
