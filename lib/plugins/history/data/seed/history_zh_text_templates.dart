import 'package:smart_xdrip/application/plugin_text/plugin_text_template.dart';

import '../../domain/text/history_text_slot.dart';

class HistoryZhTextTemplates {
  static const all = <PluginTextTemplate>[
    PluginTextTemplate(
      key: 'history.episodeCallout.zh.v1',
      slot: HistoryTextSlot.episode,
      type: 'episode_callout',
      locale: 'zh',
      bodyTemplate: '{time} - {value}，持续 {durationMinutes} 分钟。{extraText}',
    ),
    PluginTextTemplate(
      key: 'history.episodeCalloutNoExtra.zh.v1',
      slot: HistoryTextSlot.episode,
      type: 'episode_callout',
      locale: 'zh',
      bodyTemplate: '{time} - {value}，持续 {durationMinutes} 分钟',
      priority: 110,
    ),
    PluginTextTemplate(
      key: 'history.highEventDetail.zh.v1',
      slot: HistoryTextSlot.eventDetail,
      type: 'high_event_detail',
      locale: 'zh',
      bodyTemplate: '{rate} - 高于 {highThreshold} 持续 {durationMinutes} 分钟',
    ),
    PluginTextTemplate(
      key: 'history.highEventDetailDurationOnly.zh.v1',
      slot: HistoryTextSlot.eventDetail,
      type: 'high_event_detail',
      locale: 'zh',
      bodyTemplate: '高于 {highThreshold} 持续 {durationMinutes} 分钟',
      priority: 110,
    ),
    PluginTextTemplate(
      key: 'history.highEventDetailRateOnly.zh.v1',
      slot: HistoryTextSlot.eventDetail,
      type: 'high_event_detail',
      locale: 'zh',
      bodyTemplate: '{rate}',
      priority: 120,
    ),
    PluginTextTemplate(
      key: 'history.highEventDetailEmpty.zh.v1',
      slot: HistoryTextSlot.eventDetail,
      type: 'high_event_detail',
      locale: 'zh',
      bodyTemplate: '',
      priority: 130,
    ),
    PluginTextTemplate(
      key: 'history.lowEventDetail.zh.v1',
      slot: HistoryTextSlot.eventDetail,
      type: 'low_event_detail',
      locale: 'zh',
      bodyTemplate: '夜间 - 低于 {lowThreshold} 持续 {durationMinutes} 分钟',
    ),
    PluginTextTemplate(
      key: 'history.lowEventDetailDurationOnly.zh.v1',
      slot: HistoryTextSlot.eventDetail,
      type: 'low_event_detail',
      locale: 'zh',
      bodyTemplate: '低于 {lowThreshold} 持续 {durationMinutes} 分钟',
      priority: 110,
    ),
    PluginTextTemplate(
      key: 'history.lowEventDetailNocturnalOnly.zh.v1',
      slot: HistoryTextSlot.eventDetail,
      type: 'low_event_detail',
      locale: 'zh',
      bodyTemplate: '夜间',
      priority: 120,
    ),
    PluginTextTemplate(
      key: 'history.lowEventDetailEmpty.zh.v1',
      slot: HistoryTextSlot.eventDetail,
      type: 'low_event_detail',
      locale: 'zh',
      bodyTemplate: '',
      priority: 130,
    ),
    PluginTextTemplate(
      key: 'history.recoveryDetail.zh.v1',
      slot: HistoryTextSlot.eventDetail,
      type: 'recovery_detail',
      locale: 'zh',
      bodyTemplate: '回到目标范围 - {rate}',
    ),
    PluginTextTemplate(
      key: 'history.stableWindowDetail.zh.v1',
      slot: HistoryTextSlot.eventDetail,
      type: 'stable_window_detail',
      locale: 'zh',
      bodyTemplate: '低波动时段',
    ),
    PluginTextTemplate(
      key: 'history.firstReadingDetail.zh.v1',
      slot: HistoryTextSlot.eventDetail,
      type: 'first_reading_detail',
      locale: 'zh',
      bodyTemplate: '空腹血糖',
    ),
    PluginTextTemplate(
      key: 'history.highValueSuffix.zh.v1',
      slot: HistoryTextSlot.value,
      type: 'value_suffix',
      locale: 'zh',
      bodyTemplate: '{value} - 峰值',
    ),
    PluginTextTemplate(
      key: 'history.riseValueSuffix.zh.v1',
      slot: HistoryTextSlot.value,
      type: 'value_suffix',
      locale: 'zh',
      bodyTemplate: '{value} - 局部峰值',
      priority: 110,
    ),
    PluginTextTemplate(
      key: 'history.plainValueSuffix.zh.v1',
      slot: HistoryTextSlot.value,
      type: 'value_suffix',
      locale: 'zh',
      bodyTemplate: '{value}',
      priority: 120,
    ),
  ];

  const HistoryZhTextTemplates._();
}
