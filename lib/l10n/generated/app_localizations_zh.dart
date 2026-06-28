// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get appName => 'SolgoInsight';

  @override
  String get commonCancel => '取消';

  @override
  String get commonDone => '完成';

  @override
  String get commonBack => '返回';

  @override
  String get commonLoading => '加载中';

  @override
  String get commonRetry => '重试';

  @override
  String get commonSave => '保存';

  @override
  String get commonShare => '分享';

  @override
  String get commonPrint => '打印';

  @override
  String get commonExportPdf => '导出 PDF';

  @override
  String get commonNoData => '暂无数据';

  @override
  String get commonUnavailable => '不可用';

  @override
  String get settingsTitle => '设置';

  @override
  String get settingsSubtitle => '显示、同步窗口、存储与导出偏好。';

  @override
  String get settingsLanguageTitle => '语言';

  @override
  String get settingsLanguageDescription => 'App 显示语言';

  @override
  String get settingsLanguageSystem => '跟随系统';

  @override
  String get settingsLanguageEnglish => 'English';

  @override
  String get settingsLanguageSimplifiedChinese => '简体中文';

  @override
  String get settingsLanguageTraditionalChinese => '繁體中文';

  @override
  String get settingsLanguageChanged => '语言已更新。';

  @override
  String get settingsBloodGlucoseUnit => '血糖单位';

  @override
  String get settingsInitialSyncWindow => '初始同步窗口';

  @override
  String get settingsRecommendedBalance => '推荐平衡';

  @override
  String get settingsExportData => '导出数据';

  @override
  String get settingsClearAllData => '清除所有数据';

  @override
  String get timeJustNow => '刚刚';

  @override
  String get timeNever => '从未';

  @override
  String timeMinutesAgo(int minutes) {
    return '$minutes 分钟前';
  }

  @override
  String timeHoursAgo(int hours) {
    return '$hours 小时前';
  }

  @override
  String timeDaysAgo(int days) {
    return '$days 天前';
  }

  @override
  String durationSecondsShort(int seconds) {
    return '$seconds秒';
  }

  @override
  String durationMinutesShort(int minutes) {
    return '$minutes分';
  }

  @override
  String durationHoursShort(int hours) {
    return '$hours小时';
  }

  @override
  String durationHoursMinutesShort(int hours, int minutes) {
    return '$hours小时 $minutes分';
  }

  @override
  String get dateToday => '今天';

  @override
  String get dateYesterday => '昨天';

  @override
  String get dateTomorrow => '明天';

  @override
  String get dayPeriodDawn => '清晨';

  @override
  String get dayPeriodMorning => '上午';

  @override
  String get dayPeriodAfternoon => '下午';

  @override
  String get dayPeriodEvening => '傍晚';

  @override
  String get dayPeriodNight => '夜间';

  @override
  String relativeDayPeriodToday(Object period) {
    return '今天$period';
  }

  @override
  String relativeDayPeriodYesterday(Object period) {
    return '昨天$period';
  }

  @override
  String relativeDayPeriodTomorrow(Object period) {
    return '明天$period';
  }

  @override
  String get syncNotSyncing => '未同步';

  @override
  String get syncWaiting => '等待中';

  @override
  String get syncNotConfigured => '未配置';

  @override
  String get syncConfiguredNotSyncing => '已配置，未同步';

  @override
  String get syncWaitingFirstSync => '等待首次同步';

  @override
  String syncSynced(Object relative) {
    return '已同步 $relative';
  }

  @override
  String syncLastSynced(Object relative) {
    return '上次同步 $relative';
  }

  @override
  String get syncFailed => '失败';

  @override
  String get syncStatusWaiting => '等待同步';

  @override
  String get syncStatusSynced => '已同步';

  @override
  String get syncStatusNeedsSync => '需要同步';

  @override
  String get syncStatusFailed => '同步失败';

  @override
  String get syncLastFailed => '上次同步失败';

  @override
  String syncLastAttempt(Object relative) {
    return '上次尝试 $relative';
  }

  @override
  String get syncSchedulePending => '同步计划待定';

  @override
  String get syncPaused => '同步已暂停';

  @override
  String get syncWaitingSchedule => '等待同步计划';

  @override
  String get syncDue => '需要同步';

  @override
  String syncNext(Object duration) {
    return '$duration 后同步';
  }

  @override
  String syncEstimatedNext(Object duration) {
    return '预计 $duration 后同步';
  }

  @override
  String syncForegroundRefresh(Object relative) {
    return '前台刷新 $relative';
  }

  @override
  String syncNewCount(int count) {
    return '$count 条新增';
  }

  @override
  String get syncTitleLive => '实时同步已启用';

  @override
  String get syncTitleWarming => '同步正在准备';

  @override
  String get syncTitleNeedsAttention => '同步需要关注';

  @override
  String get syncTitleInterrupted => '同步已中断';

  @override
  String get syncTitleDisabled => '同步已关闭';

  @override
  String get syncDetailCollectingFirstSamples => '正在为此来源收集首批血糖样本。';
}

/// The translations for Chinese, using the Han script (`zh_Hant`).
class AppLocalizationsZhHant extends AppLocalizationsZh {
  AppLocalizationsZhHant() : super('zh_Hant');

  @override
  String get appName => 'SolgoInsight';

  @override
  String get commonCancel => '取消';

  @override
  String get commonDone => '完成';

  @override
  String get commonBack => '返回';

  @override
  String get commonLoading => '載入中';

  @override
  String get commonRetry => '重試';

  @override
  String get commonSave => '儲存';

  @override
  String get commonShare => '分享';

  @override
  String get commonPrint => '列印';

  @override
  String get commonExportPdf => '匯出 PDF';

  @override
  String get commonNoData => '暫無資料';

  @override
  String get commonUnavailable => '不可用';

  @override
  String get settingsTitle => '設定';

  @override
  String get settingsSubtitle => '顯示、同步視窗、儲存與匯出偏好。';

  @override
  String get settingsLanguageTitle => '語言';

  @override
  String get settingsLanguageDescription => 'App 顯示語言';

  @override
  String get settingsLanguageSystem => '跟隨系統';

  @override
  String get settingsLanguageEnglish => 'English';

  @override
  String get settingsLanguageSimplifiedChinese => '简体中文';

  @override
  String get settingsLanguageTraditionalChinese => '繁體中文';

  @override
  String get settingsLanguageChanged => '語言已更新。';

  @override
  String get settingsBloodGlucoseUnit => '血糖單位';

  @override
  String get settingsInitialSyncWindow => '初始同步視窗';

  @override
  String get settingsRecommendedBalance => '建議平衡';

  @override
  String get settingsExportData => '匯出資料';

  @override
  String get settingsClearAllData => '清除所有資料';

  @override
  String get timeJustNow => '剛剛';

  @override
  String get timeNever => '從未';

  @override
  String timeMinutesAgo(int minutes) {
    return '$minutes 分鐘前';
  }

  @override
  String timeHoursAgo(int hours) {
    return '$hours 小時前';
  }

  @override
  String timeDaysAgo(int days) {
    return '$days 天前';
  }

  @override
  String durationSecondsShort(int seconds) {
    return '$seconds秒';
  }

  @override
  String durationMinutesShort(int minutes) {
    return '$minutes分';
  }

  @override
  String durationHoursShort(int hours) {
    return '$hours小時';
  }

  @override
  String durationHoursMinutesShort(int hours, int minutes) {
    return '$hours小時 $minutes分';
  }

  @override
  String get dateToday => '今天';

  @override
  String get dateYesterday => '昨天';

  @override
  String get dateTomorrow => '明天';

  @override
  String get dayPeriodDawn => '清晨';

  @override
  String get dayPeriodMorning => '上午';

  @override
  String get dayPeriodAfternoon => '下午';

  @override
  String get dayPeriodEvening => '傍晚';

  @override
  String get dayPeriodNight => '夜間';

  @override
  String relativeDayPeriodToday(Object period) {
    return '今天$period';
  }

  @override
  String relativeDayPeriodYesterday(Object period) {
    return '昨天$period';
  }

  @override
  String relativeDayPeriodTomorrow(Object period) {
    return '明天$period';
  }

  @override
  String get syncNotSyncing => '未同步';

  @override
  String get syncWaiting => '等待中';

  @override
  String get syncNotConfigured => '未設定';

  @override
  String get syncConfiguredNotSyncing => '已設定，未同步';

  @override
  String get syncWaitingFirstSync => '等待首次同步';

  @override
  String syncSynced(Object relative) {
    return '已同步 $relative';
  }

  @override
  String syncLastSynced(Object relative) {
    return '上次同步 $relative';
  }

  @override
  String get syncFailed => '失敗';

  @override
  String get syncStatusWaiting => '等待同步';

  @override
  String get syncStatusSynced => '已同步';

  @override
  String get syncStatusNeedsSync => '需要同步';

  @override
  String get syncStatusFailed => '同步失敗';

  @override
  String get syncLastFailed => '上次同步失敗';

  @override
  String syncLastAttempt(Object relative) {
    return '上次嘗試 $relative';
  }

  @override
  String get syncSchedulePending => '同步排程待定';

  @override
  String get syncPaused => '同步已暫停';

  @override
  String get syncWaitingSchedule => '等待同步排程';

  @override
  String get syncDue => '需要同步';

  @override
  String syncNext(Object duration) {
    return '$duration 後同步';
  }

  @override
  String syncEstimatedNext(Object duration) {
    return '預計 $duration 後同步';
  }

  @override
  String syncForegroundRefresh(Object relative) {
    return '前台重新整理 $relative';
  }

  @override
  String syncNewCount(int count) {
    return '$count 筆新增';
  }

  @override
  String get syncTitleLive => '即時同步已啟用';

  @override
  String get syncTitleWarming => '同步正在準備';

  @override
  String get syncTitleNeedsAttention => '同步需要注意';

  @override
  String get syncTitleInterrupted => '同步已中斷';

  @override
  String get syncTitleDisabled => '同步已關閉';

  @override
  String get syncDetailCollectingFirstSamples => '正在為此來源收集首批血糖樣本。';
}
