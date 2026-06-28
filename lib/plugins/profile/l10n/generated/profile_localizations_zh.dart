// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'profile_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class ProfileLocalizationsZh extends ProfileLocalizations {
  ProfileLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get targetRangeTitle => '目标范围';

  @override
  String get targetRangeDescription => '个人血糖目标范围阈值。';

  @override
  String get targetRangeSubtitle => '个人血糖目标';

  @override
  String get pluginUnavailable => '不可用';

  @override
  String get pluginReportTitle => '个人资料报告';

  @override
  String get pluginSubtitle => '个人资料、数据源、目标范围和设置。';

  @override
  String get pluginTitle => '个人资料';

  @override
  String get pluginDescription => '个人资料、数据源、目标范围和设置。';

  @override
  String get pluginNoData => '暂无可用数据。';

  @override
  String get pluginLoading => '加载中';

  @override
  String get targetRangeVeryHighThresholdSubtitle => '标记为需要关注的高血糖区间';

  @override
  String get targetRangePrimaryBandLabel => '目标范围';

  @override
  String get targetRangeHighThresholdSubtitle => '高于此值进入高血糖范围';

  @override
  String get targetRangeUpdated => '目标范围已更新';

  @override
  String get targetRangeInRangeTarget => '目标范围';

  @override
  String get targetRangeHighThresholdLabel => '高血糖阈值';

  @override
  String get targetRangePrimaryBandSubtitle => '主要血糖范围';

  @override
  String get targetRangeHighLabel => '高';

  @override
  String get targetRangeDragHint => '拖动手柄，或在下方输入';

  @override
  String get targetRangeVeryHighLabel => '极高';

  @override
  String get targetRangeExactValues => '精确数值';

  @override
  String get targetRangeSheetTitle => '目标范围';

  @override
  String get targetRangeVeryHighThresholdLabel => '极高阈值';

  @override
  String get targetRangeLowThresholdLabel => '低血糖阈值';

  @override
  String get targetRangeLowThresholdSubtitle => '低于此值进入低血糖范围';

  @override
  String get targetRangeCancel => '取消';

  @override
  String get targetRangeLowLabel => '低';

  @override
  String get targetRangeSaveRange => '保存范围';

  @override
  String get targetRangeSpread => '跨度';

  @override
  String get targetRangeReset => '重置';

  @override
  String get targetRangeSheetSubtitle => '拖动标记或输入精确数值，两者会保持同步。';

  @override
  String get profileHeaderTitle => '我的档案';

  @override
  String profileDaysRecorded(int days) {
    return '已记录 $days 天';
  }

  @override
  String get profileStatTir14d => 'TIR 14天';

  @override
  String get profileStatAvg14d => '平均 14天';

  @override
  String get profileStatCv14d => 'CV 14天';

  @override
  String get profileSettingsSummary => '设置';

  @override
  String get profileSectionAppSettings => 'App 设置';

  @override
  String targetRangeLowHighGapMessage(String gap, String unit) {
    return '低血糖阈值至少要比高血糖阈值低 $gap $unit。';
  }

  @override
  String targetRangeHighVeryHighGapMessage(String gap, String unit) {
    return '高血糖阈值至少要比极高阈值低 $gap $unit。';
  }
}

/// The translations for Chinese, using the Han script (`zh_Hant`).
class ProfileLocalizationsZhHant extends ProfileLocalizationsZh {
  ProfileLocalizationsZhHant() : super('zh_Hant');

  @override
  String get targetRangeTitle => '目標範圍';

  @override
  String get targetRangeDescription => '個人血糖目標範圍閾值。';

  @override
  String get targetRangeSubtitle => '個人血糖目標';

  @override
  String get pluginUnavailable => '不可用';

  @override
  String get pluginReportTitle => '個人資料報告';

  @override
  String get pluginSubtitle => '個人資料、資料來源、目標範圍和設定。';

  @override
  String get pluginTitle => '個人資料';

  @override
  String get pluginDescription => '個人資料、資料來源、目標範圍和設定。';

  @override
  String get pluginNoData => '暫無可用資料。';

  @override
  String get pluginLoading => '載入中';

  @override
  String get targetRangeVeryHighThresholdSubtitle => '標記為需要關注的高血糖區間';

  @override
  String get targetRangePrimaryBandLabel => '目標範圍';

  @override
  String get targetRangeHighThresholdSubtitle => '高於此值進入高血糖範圍';

  @override
  String get targetRangeUpdated => '目標範圍已更新';

  @override
  String get targetRangeInRangeTarget => '目標範圍';

  @override
  String get targetRangeHighThresholdLabel => '高血糖閾值';

  @override
  String get targetRangePrimaryBandSubtitle => '主要血糖範圍';

  @override
  String get targetRangeHighLabel => '高';

  @override
  String get targetRangeDragHint => '拖動控制點，或在下方輸入';

  @override
  String get targetRangeVeryHighLabel => '極高';

  @override
  String get targetRangeExactValues => '精確數值';

  @override
  String get targetRangeSheetTitle => '目標範圍';

  @override
  String get targetRangeVeryHighThresholdLabel => '極高閾值';

  @override
  String get targetRangeLowThresholdLabel => '低血糖閾值';

  @override
  String get targetRangeLowThresholdSubtitle => '低於此值進入低血糖範圍';

  @override
  String get targetRangeCancel => '取消';

  @override
  String get targetRangeLowLabel => '低';

  @override
  String get targetRangeSaveRange => '儲存範圍';

  @override
  String get targetRangeSpread => '跨度';

  @override
  String get targetRangeReset => '重設';

  @override
  String get targetRangeSheetSubtitle => '拖動標記或輸入精確數值，兩者會保持同步。';

  @override
  String get profileHeaderTitle => '我的個人資料';

  @override
  String profileDaysRecorded(int days) {
    return '已記錄 $days 天';
  }

  @override
  String get profileStatTir14d => 'TIR 14天';

  @override
  String get profileStatAvg14d => '平均 14天';

  @override
  String get profileStatCv14d => 'CV 14天';

  @override
  String get profileSettingsSummary => '設定';

  @override
  String get profileSectionAppSettings => 'App 設定';

  @override
  String targetRangeLowHighGapMessage(String gap, String unit) {
    return '低血糖閾值至少要比高血糖閾值低 $gap $unit。';
  }

  @override
  String targetRangeHighVeryHighGapMessage(String gap, String unit) {
    return '高血糖閾值至少要比極高閾值低 $gap $unit。';
  }
}
