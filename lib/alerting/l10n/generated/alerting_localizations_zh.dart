// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'alerting_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AlertingLocalizationsZh extends AlertingLocalizations {
  AlertingLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get alertingTitle => '告警设置';

  @override
  String get alertingSubtitle => '配置通知、声音、振动和应用内告警行为。';

  @override
  String get pluginTitle => '告警';

  @override
  String get pluginDescription => '可配置的告警发送策略。';

  @override
  String get settingsEntrySubtitle => '声音、振动和通知策略';

  @override
  String get alertSystemSection => '告警系统';

  @override
  String get deliveryStrategiesSection => '发送方式';

  @override
  String get enableAlertsTitle => '启用告警';

  @override
  String get enableAlertsSubtitle => '血糖安全告警和后续告警来源的总开关。';

  @override
  String get criticalOnlyTitle => '仅关键告警';

  @override
  String get criticalOnlySubtitle => '只有紧急事件可以触发发送策略。';

  @override
  String get detailCriticalOnly => '仅关键';

  @override
  String get detailAllSeverities => '全部级别';

  @override
  String get inAppAlertTitle => '应用内告警';

  @override
  String get inAppAlertSubtitle => 'App 打开时显示可见的告警卡片。';

  @override
  String get detailCriticalFullScreenReady => '关键告警可全屏';

  @override
  String get detailCompactMode => '紧凑模式';

  @override
  String get systemNotificationTitle => '系统通知';

  @override
  String get systemNotificationSubtitle => '使用操作系统通知通道。';

  @override
  String get detailHighPriorityChannel => '高优先级通道';

  @override
  String get soundAlertTitle => '声音告警';

  @override
  String get soundAlertSubtitle => '选择系统、内置、自定义或静音的声音行为。';

  @override
  String soundMaxDuration(int seconds) {
    return '最长 $seconds 秒';
  }

  @override
  String get detailRepeatCritical => '关键告警重复播放';

  @override
  String get detailSingle => '单次';

  @override
  String get vibrationAlertTitle => '振动告警';

  @override
  String get vibrationAlertSubtitle => '使用振动模式提示警告和关键事件。';

  @override
  String vibrationCritical(String label) {
    return '关键：$label';
  }

  @override
  String vibrationWarning(String label) {
    return '警告：$label';
  }

  @override
  String get configureTooltip => '配置';

  @override
  String get alertSettingsEntryTitle => '告警设置';

  @override
  String get alertSettingsEntrySubtitle => '声音、振动、通知和应用内告警行为';

  @override
  String get alertRuntimeTitle => '告警运行状态';

  @override
  String get runtimeAndroidHelperAlerts =>
      'Android 告警可以通过前台服务运行，但 SolgoInsight 仍会把它们作为辅助提醒处理。';

  @override
  String get runtimeIosBestEffort => 'iOS 可在系统允许时通过尽力而为的后台刷新评估辅助告警，但不是实时告警。';

  @override
  String get runtimePlatformLimited => '此平台不提供可靠的后台告警能力。';

  @override
  String get runtimeForegroundAlerts => '前台告警';

  @override
  String get runtimeForegroundOff => '前台关闭';

  @override
  String get runtimeBackgroundEvaluation => '后台评估';

  @override
  String get runtimeBackgroundLimited => '后台受限';

  @override
  String get runtimeRealtimeGuaranteed => '实时保证';

  @override
  String get runtimeNoRealtimeGuarantee => '不保证实时';

  @override
  String get chooseSoundSourceTitle => '选择声音来源';

  @override
  String get chooseSoundSourceSubtitle => '所选声音会全局保存，并在告警规则请求声音时使用。';

  @override
  String get builtInSoundsSection => '内置声音';

  @override
  String get quietSection => '静音';

  @override
  String get customSection => '自定义';

  @override
  String get importing => '正在导入...';

  @override
  String get chooseAudioFile => '选择音频文件';

  @override
  String previewingSound(String name) {
    return '正在试听 $name';
  }

  @override
  String get couldNotPreviewSound => '无法试听此声音';

  @override
  String get couldNotImportAudioTrySmaller => '无法导入此音频文件。请尝试更小的本地文件。';

  @override
  String get couldNotImportAudio => '无法导入此音频文件';

  @override
  String get soundSubtitleAsset => 'SolgoInsight 内置';

  @override
  String get soundSubtitleFile => '已导入到 App 私有存储';

  @override
  String get soundSubtitleSilent => '声音通道保持静音';

  @override
  String get playing => '播放中';

  @override
  String get preview => '试听';

  @override
  String get select => '选择';

  @override
  String get soundSteadyPing => '稳定提示音';

  @override
  String get soundUrgentPulse => '紧急脉冲音';

  @override
  String get soundGentleChime => '轻柔铃声';

  @override
  String get soundSoftBell => '柔和铃声';

  @override
  String get soundSilent => '静音';

  @override
  String get soundBuiltInFallback => '内置告警声音';

  @override
  String get vibrationCriticalRepeat => '关键重复';

  @override
  String get vibrationShortWarning => '短促警告';

  @override
  String get alertActionSnooze5m => '稍后提醒 5 分钟';

  @override
  String get alertActionDismiss => '忽略';

  @override
  String get alertActionStop => '停止';

  @override
  String get alertSubjectCurrentGlucose => '当前血糖';

  @override
  String get alertSubjectGlucose => '血糖';

  @override
  String get alertSubjectGlucoseData => '血糖数据';

  @override
  String get alertTitleUrgentLowGlucose => '紧急低血糖';

  @override
  String get alertTitleLowGlucose => '低血糖';

  @override
  String get alertTitleHighGlucose => '高血糖';

  @override
  String get alertTitleGlucoseAlert => '血糖告警';

  @override
  String alertBodyGlucoseValue(String subject, String value) {
    return '$subject为 $value。';
  }

  @override
  String get alertTitleRapidFall => '快速下降';

  @override
  String alertBodyRapidFall(String subject) {
    return '$subject正在快速下降。';
  }

  @override
  String alertBodyRapidFallWithRate(String subject, String rate) {
    return '$subject正在快速下降（$rate）。';
  }

  @override
  String get alertTitleNoRecentGlucoseData => '近期无血糖数据';

  @override
  String alertBodyNoRecentGlucoseData(String subject) {
    return '$subject近期没有更新。';
  }

  @override
  String get alertFallbackTitle => '告警';

  @override
  String get alertFallbackBody => '收到一条新的告警。';
}
