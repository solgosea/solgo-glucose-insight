// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'home_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class HomeLocalizationsZh extends HomeLocalizations {
  HomeLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get homeHeaderSubtitle => '首页标题和同步状态';

  @override
  String get homeHeroTitle => '当前血糖';

  @override
  String get homeTirSubtitle => '当前范围摘要';

  @override
  String get homeHeroSubtitle => '最新血糖值';

  @override
  String get homeTirDescription => '当前视图的目标范围时间摘要。';

  @override
  String get homeRangeChartDescription => '近期血糖范围曲线。';

  @override
  String get homeHeroDescription => '最新血糖值和趋势摘要。';

  @override
  String get homeStatsDescription => '紧凑展示平均值、CV 和事件统计。';

  @override
  String get homeInsightDescription => '紧凑的生成式洞察入口。';

  @override
  String get homeStatsTitle => '首页统计';

  @override
  String get homeHeaderDescription => '首页标题和当前同步状态。';

  @override
  String get homeRangeChartTitle => '范围曲线';

  @override
  String get homeHeaderTitle => '首页标题';

  @override
  String get homeTirTitle => '目标范围时间';

  @override
  String get homeStatsSubtitle => '平均值、CV 和事件统计';

  @override
  String get homeInsightTitle => '首页洞察';

  @override
  String get homeRangeChartSubtitle => '近期血糖趋势';

  @override
  String get homeInsightSubtitle => '生成式洞察入口';

  @override
  String get pluginUnavailable => '不可用';

  @override
  String get pluginReportTitle => '首页报告';

  @override
  String get pluginSubtitle => '首页组件和血糖概览。';

  @override
  String get pluginTitle => '首页';

  @override
  String get pluginDescription => '首页组件和血糖概览。';

  @override
  String get pluginNoData => '暂无可用数据。';

  @override
  String get pluginLoading => '加载中';

  @override
  String homeStatAverage(Object window) {
    return '平均 $window';
  }

  @override
  String homeStatTir(Object window) {
    return 'TIR $window';
  }

  @override
  String homeStatCv(Object window) {
    return 'CV $window';
  }

  @override
  String get homeInRange => '目标范围内';

  @override
  String get homeStable => '稳定';

  @override
  String homeHighWithThreshold(Object threshold) {
    return '高于 $threshold';
  }

  @override
  String homeLowWithThreshold(Object threshold) {
    return '低于 $threshold';
  }

  @override
  String get homeLast24h => '过去 24 小时';

  @override
  String get homeNotEnoughData => 'CGM 数据暂时不足。';

  @override
  String get homeCheckingSync => '正在检查同步';

  @override
  String get homeCompanionEyebrow => 'CGM 伴侣';

  @override
  String get homeTodaysInsight => '今日洞察';

  @override
  String get homeSeeFullAnalysis => '查看完整分析  >';

  @override
  String get homeMyDevice => '我的设备';

  @override
  String get homeInspectingPast => '正在查看历史 - 松开后恢复';

  @override
  String get homeRangeOneHour => '1小时';

  @override
  String get homeRangeFourHours => '4小时';

  @override
  String get homeRangeEightHours => '8小时';

  @override
  String get homeRangeTwentyFourHours => '24小时';

  @override
  String get homeRangeTitleOneHour => '过去 1 小时';

  @override
  String get homeRangeTitleFourHours => '过去 4 小时';

  @override
  String get homeRangeTitleEightHours => '过去 8 小时';

  @override
  String get homeRangeTitleTwentyFourHours => '过去 24 小时';
}

/// The translations for Chinese, using the Han script (`zh_Hant`).
class HomeLocalizationsZhHant extends HomeLocalizationsZh {
  HomeLocalizationsZhHant() : super('zh_Hant');

  @override
  String get homeHeaderSubtitle => '首頁標題和同步狀態';

  @override
  String get homeHeroTitle => '目前血糖';

  @override
  String get homeTirSubtitle => '目前範圍摘要';

  @override
  String get homeHeroSubtitle => '最新血糖值';

  @override
  String get homeTirDescription => '目前檢視的目標範圍時間摘要。';

  @override
  String get homeRangeChartDescription => '近期血糖範圍曲線。';

  @override
  String get homeHeroDescription => '最新血糖值和趨勢摘要。';

  @override
  String get homeStatsDescription => '緊湊顯示平均值、CV 和事件統計。';

  @override
  String get homeInsightDescription => '緊湊的生成式洞察入口。';

  @override
  String get homeStatsTitle => '首頁統計';

  @override
  String get homeHeaderDescription => '首頁標題和目前同步狀態。';

  @override
  String get homeRangeChartTitle => '範圍曲線';

  @override
  String get homeHeaderTitle => '首頁標題';

  @override
  String get homeTirTitle => '目標範圍時間';

  @override
  String get homeStatsSubtitle => '平均值、CV 和事件統計';

  @override
  String get homeInsightTitle => '首頁洞察';

  @override
  String get homeRangeChartSubtitle => '近期血糖趨勢';

  @override
  String get homeInsightSubtitle => '生成式洞察入口';

  @override
  String get pluginUnavailable => '不可用';

  @override
  String get pluginReportTitle => '首頁報告';

  @override
  String get pluginSubtitle => '首頁元件和血糖概覽。';

  @override
  String get pluginTitle => '首頁';

  @override
  String get pluginDescription => '首頁元件和血糖概覽。';

  @override
  String get pluginNoData => '暫無可用資料。';

  @override
  String get pluginLoading => '載入中';

  @override
  String homeStatAverage(Object window) {
    return '平均 $window';
  }

  @override
  String homeStatTir(Object window) {
    return 'TIR $window';
  }

  @override
  String homeStatCv(Object window) {
    return 'CV $window';
  }

  @override
  String get homeInRange => '目標範圍內';

  @override
  String get homeStable => '穩定';

  @override
  String homeHighWithThreshold(Object threshold) {
    return '高於 $threshold';
  }

  @override
  String homeLowWithThreshold(Object threshold) {
    return '低於 $threshold';
  }

  @override
  String get homeLast24h => '過去 24 小時';

  @override
  String get homeNotEnoughData => 'CGM 資料暫時不足。';

  @override
  String get homeCheckingSync => '正在檢查同步';

  @override
  String get homeCompanionEyebrow => 'CGM 伴侣';

  @override
  String get homeTodaysInsight => '今日洞察';

  @override
  String get homeSeeFullAnalysis => '查看完整分析  >';

  @override
  String get homeMyDevice => '我的设备';

  @override
  String get homeInspectingPast => '正在查看歷史 - 鬆開後恢復';

  @override
  String get homeRangeOneHour => '1小時';

  @override
  String get homeRangeFourHours => '4小時';

  @override
  String get homeRangeEightHours => '8小時';

  @override
  String get homeRangeTwentyFourHours => '24小時';

  @override
  String get homeRangeTitleOneHour => '過去 1 小時';

  @override
  String get homeRangeTitleFourHours => '過去 4 小時';

  @override
  String get homeRangeTitleEightHours => '過去 8 小時';

  @override
  String get homeRangeTitleTwentyFourHours => '過去 24 小時';
}
