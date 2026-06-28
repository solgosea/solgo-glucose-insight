// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'settings_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class SettingsLocalizationsZh extends SettingsLocalizations {
  SettingsLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get settingsDangerDescription => '会破坏本地数据的操作。';

  @override
  String get settingsDisplaySubtitle => '单位和展示偏好';

  @override
  String get settingsDisplayTitle => '显示';

  @override
  String get settingsDangerTitle => '危险操作';

  @override
  String get settingsExportTitle => '数据导出';

  @override
  String get settingsAboutDescription => '应用元数据和支持链接。';

  @override
  String get settingsStorageSubtitle => '本地数据存储摘要';

  @override
  String get settingsDangerSubtitle => '本地数据破坏性操作';

  @override
  String get settingsSyncSubtitle => '同步窗口和数据源偏好';

  @override
  String get settingsExportSubtitle => '导出本地血糖数据';

  @override
  String get settingsExportDescription => '导出本地血糖数据。';

  @override
  String get settingsSyncTitle => '同步设置';

  @override
  String get settingsAboutTitle => '关于';

  @override
  String get settingsDisplayDescription => '血糖单位的显示偏好。';

  @override
  String get settingsStorageTitle => '数据存储';

  @override
  String get settingsAboutSubtitle => '应用信息和支持链接';

  @override
  String get settingsStorageDescription => '本地血糖数据存储摘要。';

  @override
  String get settingsSyncDescription => '同步窗口和数据源同步偏好。';

  @override
  String get pluginUnavailable => '不可用';

  @override
  String get pluginReportTitle => '设置报告';

  @override
  String get pluginSubtitle => '显示、同步、存储、导出和安全设置。';

  @override
  String get pluginTitle => '设置';

  @override
  String get pluginDescription => '显示、同步、存储、导出和安全设置。';

  @override
  String get pluginNoData => '暂无可用数据。';

  @override
  String get pluginLoading => '加载中';

  @override
  String get settingsExportNoReadings => '还没有可导出的读数。';

  @override
  String get settingsAllLocalDataCleared => '所有本地数据已清除。';

  @override
  String get settingsUnitsLabel => '单位';

  @override
  String get settingsDeleteEverything => '删除所有内容';

  @override
  String get settingsClearAllDataTitle => '清除所有数据';

  @override
  String get settingsRetentionPeriodLabel => '保留周期';

  @override
  String get settingsDaysSuffix => '天';

  @override
  String get settingsInitialSyncWindowLabel => '初始同步窗口';

  @override
  String get settingsSyncWindowLabel => '同步窗口';

  @override
  String get settingsSyncWindowSubtitle => '历史范围和同步间隔';

  @override
  String settingsSyncWindowValue(int days, int minutes) {
    return '$days 天 · 每 $minutes 分钟';
  }

  @override
  String get settingsSyncWindowSheetTitle => '同步窗口';

  @override
  String get settingsSyncWindowSheetSubtitle =>
      '选择要加载的历史范围，以及 SolgoInsight 检查新读数的频率。';

  @override
  String get settingsSyncPlanLabel => '同步计划';

  @override
  String get settingsHistoryRangeLabel => '历史范围';

  @override
  String settingsHistoryRangeValue(int days) {
    return '$days 天';
  }

  @override
  String get settingsSyncIntervalLabel => '同步间隔';

  @override
  String settingsSyncIntervalValue(int minutes) {
    return '每 $minutes 分钟';
  }

  @override
  String settingsDaysShort(int days) {
    return '$days天';
  }

  @override
  String settingsMinutesShort(int minutes) {
    return '$minutes分';
  }

  @override
  String get settingsSyncPreviewTitle => '保存后会怎样';

  @override
  String settingsSyncPreviewBody(int days, int minutes) {
    return '初始同步最多加载 $days 天历史数据。之后在同步运行时，大约每 $minutes 分钟检查一次新读数。';
  }

  @override
  String get settingsSaveSyncWindow => '保存';

  @override
  String get settingsRetentionSummarySuffix => '不会有数据离开此设备';

  @override
  String get settingsClearAllDataDialogTitle => '清除所有数据？';

  @override
  String get settingsDaysMax => '天上限';

  @override
  String get settingsCancel => '取消';

  @override
  String get settingsRecommendedBalance => '推荐的平衡设置';

  @override
  String get settingsDaysCovered => '天';

  @override
  String get settingsInitialSyncWindowSubtitle => '连接新数据源时使用';

  @override
  String get settingsOpenSourceLink => '开源';

  @override
  String get settingsStorageUsed => '已使用';

  @override
  String get settingsBloodGlucoseUnitSubtitle => '血糖单位';

  @override
  String get settingsRetentionPeriodSubtitle => '自动清理更早的读数';

  @override
  String get settingsPrivacyLink => '隐私';

  @override
  String get settingsRetentionSummaryPrefix => '数据保留：';

  @override
  String get settingsExportDataLabel => '导出数据';

  @override
  String get settingsClearAllDataSubtitle => '永久删除所有已存储读数';

  @override
  String get settingsExportDataSubtitle => '将读数保存为 CSV';

  @override
  String get settingsExportedTo => '已导出到：';

  @override
  String get settingsLocalStorageTitle => '本地存储';

  @override
  String get settingsClearAllDataDialogBody =>
      '这会永久删除所有已存储的 CGM 读数、事件和分析快照。此操作无法撤销。';
}

/// The translations for Chinese, using the Han script (`zh_Hant`).
class SettingsLocalizationsZhHant extends SettingsLocalizationsZh {
  SettingsLocalizationsZhHant() : super('zh_Hant');

  @override
  String get settingsDangerDescription => '會破壞本機資料的操作。';

  @override
  String get settingsDisplaySubtitle => '單位和呈現偏好';

  @override
  String get settingsDisplayTitle => '顯示';

  @override
  String get settingsDangerTitle => '危險操作';

  @override
  String get settingsExportTitle => '資料匯出';

  @override
  String get settingsAboutDescription => '應用程式中繼資料和支援連結。';

  @override
  String get settingsStorageSubtitle => '本機資料儲存摘要';

  @override
  String get settingsDangerSubtitle => '本機資料破壞性操作';

  @override
  String get settingsSyncSubtitle => '同步視窗和資料來源偏好';

  @override
  String get settingsExportSubtitle => '匯出本機血糖資料';

  @override
  String get settingsExportDescription => '匯出本機血糖資料。';

  @override
  String get settingsSyncTitle => '同步設定';

  @override
  String get settingsAboutTitle => '關於';

  @override
  String get settingsDisplayDescription => '血糖單位的顯示偏好。';

  @override
  String get settingsStorageTitle => '資料儲存';

  @override
  String get settingsAboutSubtitle => '應用程式資訊和支援連結';

  @override
  String get settingsStorageDescription => '本機血糖資料儲存摘要。';

  @override
  String get settingsSyncDescription => '同步視窗和資料來源同步偏好。';

  @override
  String get pluginUnavailable => '不可用';

  @override
  String get pluginReportTitle => '設定報告';

  @override
  String get pluginSubtitle => '顯示、同步、儲存、匯出和安全設定。';

  @override
  String get pluginTitle => '設定';

  @override
  String get pluginDescription => '顯示、同步、儲存、匯出和安全設定。';

  @override
  String get pluginNoData => '暫無可用資料。';

  @override
  String get pluginLoading => '載入中';

  @override
  String get settingsExportNoReadings => '還沒有可匯出的讀數。';

  @override
  String get settingsAllLocalDataCleared => '所有本機資料已清除。';

  @override
  String get settingsUnitsLabel => '單位';

  @override
  String get settingsDeleteEverything => '刪除所有內容';

  @override
  String get settingsClearAllDataTitle => '清除所有資料';

  @override
  String get settingsRetentionPeriodLabel => '保留週期';

  @override
  String get settingsDaysSuffix => '天';

  @override
  String get settingsInitialSyncWindowLabel => '初始同步視窗';

  @override
  String get settingsSyncWindowLabel => '同步視窗';

  @override
  String get settingsSyncWindowSubtitle => '歷史範圍和同步間隔';

  @override
  String settingsSyncWindowValue(int days, int minutes) {
    return '$days 天 · 每 $minutes 分鐘';
  }

  @override
  String get settingsSyncWindowSheetTitle => '同步視窗';

  @override
  String get settingsSyncWindowSheetSubtitle =>
      '選擇要載入的歷史範圍，以及 SolgoInsight 檢查新讀數的頻率。';

  @override
  String get settingsSyncPlanLabel => '同步計畫';

  @override
  String get settingsHistoryRangeLabel => '歷史範圍';

  @override
  String settingsHistoryRangeValue(int days) {
    return '$days 天';
  }

  @override
  String get settingsSyncIntervalLabel => '同步間隔';

  @override
  String settingsSyncIntervalValue(int minutes) {
    return '每 $minutes 分鐘';
  }

  @override
  String settingsDaysShort(int days) {
    return '$days天';
  }

  @override
  String settingsMinutesShort(int minutes) {
    return '$minutes分';
  }

  @override
  String get settingsSyncPreviewTitle => '儲存後會怎樣';

  @override
  String settingsSyncPreviewBody(int days, int minutes) {
    return '初始同步最多載入 $days 天歷史資料。之後在同步執行時，大約每 $minutes 分鐘檢查一次新讀數。';
  }

  @override
  String get settingsSaveSyncWindow => '儲存';

  @override
  String get settingsRetentionSummarySuffix => '不會有資料離開此裝置';

  @override
  String get settingsClearAllDataDialogTitle => '清除所有資料？';

  @override
  String get settingsDaysMax => '天上限';

  @override
  String get settingsCancel => '取消';

  @override
  String get settingsRecommendedBalance => '建議的平衡設定';

  @override
  String get settingsDaysCovered => '天';

  @override
  String get settingsInitialSyncWindowSubtitle => '連接新資料來源時使用';

  @override
  String get settingsOpenSourceLink => '開源';

  @override
  String get settingsStorageUsed => '已使用';

  @override
  String get settingsBloodGlucoseUnitSubtitle => '血糖單位';

  @override
  String get settingsRetentionPeriodSubtitle => '自動清理較早的讀數';

  @override
  String get settingsPrivacyLink => '隱私';

  @override
  String get settingsRetentionSummaryPrefix => '資料保留：';

  @override
  String get settingsExportDataLabel => '匯出資料';

  @override
  String get settingsClearAllDataSubtitle => '永久刪除所有已儲存讀數';

  @override
  String get settingsExportDataSubtitle => '將讀數儲存為 CSV';

  @override
  String get settingsExportedTo => '已匯出到：';

  @override
  String get settingsLocalStorageTitle => '本機儲存';

  @override
  String get settingsClearAllDataDialogBody =>
      '這會永久刪除所有已儲存的 CGM 讀數、事件和分析快照。此操作無法復原。';
}
