// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'history_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class HistoryLocalizationsZh extends HistoryLocalizations {
  HistoryLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get pluginTitle => '历史';

  @override
  String get pluginSubtitle => '每日血糖曲线、事件与片段回顾。';

  @override
  String get pluginDescription => '每日血糖曲线、事件与片段回顾。';

  @override
  String get pluginReportTitle => '历史报告';

  @override
  String get pluginLoading => '加载中';

  @override
  String get pluginNoData => '暂无可用数据。';

  @override
  String get pluginUnavailable => '不可用';

  @override
  String get dayView => '日视图';

  @override
  String get today => '今天';

  @override
  String get dateFilterTooltip => '选择日期';

  @override
  String get dateFilterTitle => '选择日期';

  @override
  String get dateFilterSubtitle => '点击某一天，或拖动选择连续日期来筛选历史。';

  @override
  String get dateFilterRangeSubtitle => '日期范围';

  @override
  String get dateFilterApply => '应用';

  @override
  String get dateFilterReset => '今天';

  @override
  String get dateFilterCancel => '取消';

  @override
  String get dateFilterSelectedDates => '已选择日期';

  @override
  String get dateFilterDay => '天';

  @override
  String get dateFilterDays => '天';

  @override
  String get dateFilterReadings => '条读数';

  @override
  String get dateFilterDragHint => '点击日期选择单日，或按住拖动选择连续日期范围。';

  @override
  String get dateFilterToday => '今天';

  @override
  String get dateFilterYesterday => '昨天';

  @override
  String get dateFilterLast7Days => '近 7 天';

  @override
  String get dateFilterLast14Days => '近 14 天';

  @override
  String get dateFilterThisMonth => '本月';

  @override
  String get summaryTir => 'TIR';

  @override
  String get summaryPeak => '峰值';

  @override
  String get summaryCv => 'CV';

  @override
  String get summaryAverage => '平均';

  @override
  String get statTir => 'TIR';

  @override
  String get statAverage => '平均';

  @override
  String get statPeak => '峰值';

  @override
  String get statCv => 'CV';

  @override
  String get curveTitle => '24 小时曲线';

  @override
  String get legendInRange => '范围内';

  @override
  String get legendHigh => '偏高';

  @override
  String get legendLow => '偏低';

  @override
  String filterFocusedAround(String time) {
    return '聚焦 $time 附近';
  }

  @override
  String get filterClear => '清除';

  @override
  String get episodeHigh => '高血糖片段';

  @override
  String get episodeLow => '低血糖片段';

  @override
  String get episodeAction => '查看片段分析 ->';

  @override
  String get episodesPanelTitle => '事件片段';

  @override
  String get episodesFilterAll => '全部';

  @override
  String get episodesFilterHighs => '偏高';

  @override
  String get episodesFilterLows => '偏低';

  @override
  String episodesShowAll(int count) {
    return '显示全部 $count 个片段';
  }

  @override
  String get episodesShowLess => '收起';

  @override
  String get episodeMinutes => '分钟';

  @override
  String episodeAboveThreshold(String threshold) {
    return '高于 $threshold';
  }

  @override
  String episodeBelowThreshold(String threshold) {
    return '低于 $threshold';
  }

  @override
  String get episodeNocturnal => '夜间';

  @override
  String get eventRiseDetected => '检测到上升';

  @override
  String get eventLowEpisode => '低血糖片段';

  @override
  String get eventRecoveryToRange => '回到目标范围';

  @override
  String get eventStableWindow => '稳定时段';

  @override
  String get eventFirstReading => '当天首条读数';

  @override
  String get eventDawnPhenomenon => '黎明现象';

  @override
  String get tagHighEpisode => '高血糖片段';

  @override
  String get tagLowEpisode => '低血糖片段';

  @override
  String get tagInRange => '范围内';

  @override
  String get tagElevated => '偏高';

  @override
  String get eventsSectionTitle => '血糖事件';

  @override
  String get eventsEmpty => '暂无记录事件';

  @override
  String get eventBackInRange => '已回到范围内';

  @override
  String get eventNocturnalLow => '夜间低血糖';

  @override
  String eventRatePrefix(String rate) {
    return '速率 $rate';
  }
}

/// The translations for Chinese, using the Han script (`zh_Hant`).
class HistoryLocalizationsZhHant extends HistoryLocalizationsZh {
  HistoryLocalizationsZhHant() : super('zh_Hant');

  @override
  String get pluginTitle => '歷史';

  @override
  String get pluginSubtitle => '每日血糖曲線、事件與片段回顧。';

  @override
  String get pluginDescription => '每日血糖曲線、事件與片段回顧。';

  @override
  String get pluginReportTitle => '歷史報告';

  @override
  String get pluginLoading => '載入中';

  @override
  String get pluginNoData => '暫無可用資料。';

  @override
  String get pluginUnavailable => '不可用';

  @override
  String get dayView => '日視圖';

  @override
  String get today => '今天';

  @override
  String get dateFilterTooltip => '選擇日期';

  @override
  String get dateFilterTitle => '選擇日期';

  @override
  String get dateFilterSubtitle => '點擊某一天，或拖動選擇連續日期來篩選歷史。';

  @override
  String get dateFilterRangeSubtitle => '日期範圍';

  @override
  String get dateFilterApply => '套用';

  @override
  String get dateFilterReset => '今天';

  @override
  String get dateFilterCancel => '取消';

  @override
  String get dateFilterSelectedDates => '已選擇日期';

  @override
  String get dateFilterDay => '天';

  @override
  String get dateFilterDays => '天';

  @override
  String get dateFilterReadings => '筆讀數';

  @override
  String get dateFilterDragHint => '點擊日期選擇單日，或按住拖動選擇連續日期範圍。';

  @override
  String get dateFilterToday => '今天';

  @override
  String get dateFilterYesterday => '昨天';

  @override
  String get dateFilterLast7Days => '近 7 天';

  @override
  String get dateFilterLast14Days => '近 14 天';

  @override
  String get dateFilterThisMonth => '本月';

  @override
  String get summaryTir => 'TIR';

  @override
  String get summaryPeak => '峰值';

  @override
  String get summaryCv => 'CV';

  @override
  String get summaryAverage => '平均';

  @override
  String get statTir => 'TIR';

  @override
  String get statAverage => '平均';

  @override
  String get statPeak => '峰值';

  @override
  String get statCv => 'CV';

  @override
  String get curveTitle => '24 小時曲線';

  @override
  String get legendInRange => '範圍內';

  @override
  String get legendHigh => '偏高';

  @override
  String get legendLow => '偏低';

  @override
  String filterFocusedAround(String time) {
    return '聚焦 $time 附近';
  }

  @override
  String get filterClear => '清除';

  @override
  String get episodeHigh => '高血糖片段';

  @override
  String get episodeLow => '低血糖片段';

  @override
  String get episodeAction => '查看片段分析 ->';

  @override
  String get episodesPanelTitle => '事件片段';

  @override
  String get episodesFilterAll => '全部';

  @override
  String get episodesFilterHighs => '偏高';

  @override
  String get episodesFilterLows => '偏低';

  @override
  String episodesShowAll(int count) {
    return '顯示全部 $count 個片段';
  }

  @override
  String get episodesShowLess => '收起';

  @override
  String get episodeMinutes => '分鐘';

  @override
  String episodeAboveThreshold(String threshold) {
    return '高於 $threshold';
  }

  @override
  String episodeBelowThreshold(String threshold) {
    return '低於 $threshold';
  }

  @override
  String get episodeNocturnal => '夜間';

  @override
  String get eventRiseDetected => '偵測到上升';

  @override
  String get eventLowEpisode => '低血糖片段';

  @override
  String get eventRecoveryToRange => '回到目標範圍';

  @override
  String get eventStableWindow => '穩定時段';

  @override
  String get eventFirstReading => '當天首筆讀數';

  @override
  String get eventDawnPhenomenon => '黎明現象';

  @override
  String get tagHighEpisode => '高血糖片段';

  @override
  String get tagLowEpisode => '低血糖片段';

  @override
  String get tagInRange => '範圍內';

  @override
  String get tagElevated => '偏高';

  @override
  String get eventsSectionTitle => '血糖事件';

  @override
  String get eventsEmpty => '暫無記錄事件';

  @override
  String get eventBackInRange => '已回到範圍內';

  @override
  String get eventNocturnalLow => '夜間低血糖';

  @override
  String eventRatePrefix(String rate) {
    return '速率 $rate';
  }
}
