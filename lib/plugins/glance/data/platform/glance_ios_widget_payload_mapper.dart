import '../../domain/render/glance_render_payload.dart';
import '../sqlite/sqlite_glance_settings_repository.dart';
import 'glance_ios_widget_payload_keys.dart';

class GlanceIosWidgetPayloadMapper {
  const GlanceIosWidgetPayloadMapper();

  Map<String, Object?> sharedPayload(
    GlanceRenderPayload payload, {
    GlanceNotificationSettings settings = const GlanceNotificationSettings(),
  }) {
    final hasReading = _hasReading(payload);
    final isStale = payload.rangeStateCode == 'stale' ||
        (!hasReading && payload.freshnessLabel == 'No recent data');
    final rangeLabel = _rangeLabel(payload.rangeStateCode);
    return {
      GlanceIosWidgetPayloadKeys.widgetId: payload.widgetId,
      GlanceIosWidgetPayloadKeys.template: payload.template.code,
      GlanceIosWidgetPayloadKeys.backgroundStyle: payload.backgroundStyle.code,
      GlanceIosWidgetPayloadKeys.fontSize: payload.fontSize.code,
      GlanceIosWidgetPayloadKeys.graphRange: payload.graphRangeLabel,
      GlanceIosWidgetPayloadKeys.valueLabel: payload.valueLabel,
      GlanceIosWidgetPayloadKeys.unitLabel: payload.unitLabel,
      GlanceIosWidgetPayloadKeys.alternateValueLabel:
          payload.alternateValueLabel,
      GlanceIosWidgetPayloadKeys.deltaLabel: payload.deltaLabel,
      GlanceIosWidgetPayloadKeys.trendArrow: payload.trendArrow,
      GlanceIosWidgetPayloadKeys.freshnessLabel: payload.freshnessLabel,
      GlanceIosWidgetPayloadKeys.latestReadingAtMs: payload.latestReadingAtMs,
      GlanceIosWidgetPayloadKeys.sourceLabel: payload.sourceLabel,
      GlanceIosWidgetPayloadKeys.rangeState: payload.rangeStateCode,
      GlanceIosWidgetPayloadKeys.targetLowMmol: payload.chart.targetLowMmol,
      GlanceIosWidgetPayloadKeys.targetHighMmol: payload.chart.targetHighMmol,
      GlanceIosWidgetPayloadKeys.trendValues: payload.chart.trendValues,
      GlanceIosWidgetPayloadKeys.showTrendArrow: payload.showTrendArrow,
      GlanceIosWidgetPayloadKeys.showDelta: payload.showDelta,
      GlanceIosWidgetPayloadKeys.showLastUpdated: payload.showLastUpdated,
      GlanceIosWidgetPayloadKeys.showMiniGraph: payload.showMiniGraph,
      GlanceIosWidgetPayloadKeys.showAlternateUnit: payload.showAlternateUnit,
      GlanceIosWidgetPayloadKeys.tapAction: payload.tapAction.code,
      GlanceIosWidgetPayloadKeys.displayMode:
          settings.notificationDisplayMode.code,
      GlanceIosWidgetPayloadKeys.lockScreenMode: settings.lockScreenMode.code,
      GlanceIosWidgetPayloadKeys.aodFriendlyEnabled:
          settings.aodFriendlyEnabled,
      GlanceIosWidgetPayloadKeys.isStale: isStale,
      GlanceIosWidgetPayloadKeys.hasReading: hasReading,
      GlanceIosWidgetPayloadKeys.privacyText: 'Glucose data available',
      GlanceIosWidgetPayloadKeys.rangeLabel: rangeLabel,
    };
  }

  bool _hasReading(GlanceRenderPayload payload) {
    final label = payload.valueLabel.trim();
    return payload.latestReadingAtMs != null &&
        label.isNotEmpty &&
        label != '--' &&
        label.toLowerCase() != 'no data';
  }

  String _rangeLabel(String code) {
    return switch (code) {
      'high' => 'High',
      'low' => 'Low',
      'in_range' => 'In range',
      'stale' => 'Glucose stale',
      _ => 'Glucose status available',
    };
  }
}
