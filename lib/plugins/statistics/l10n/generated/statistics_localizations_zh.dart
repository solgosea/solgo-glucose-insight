// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'statistics_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class StatisticsLocalizationsZh extends StatisticsLocalizations {
  StatisticsLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get pluginTitle => '统计';

  @override
  String get pluginSubtitle => '血糖指标、TIR、AGP 与热力图。';

  @override
  String get pluginDescription => '血糖指标、TIR、AGP 与热力图。';

  @override
  String get pluginReportTitle => '统计报告';

  @override
  String get pluginLoading => '加载中';

  @override
  String get pluginNoData => '暂无可用数据。';

  @override
  String get pluginUnavailable => '不可用';

  @override
  String get pageTitle => '统计';

  @override
  String get exportAction => '导出 ->';

  @override
  String get dateFilterTooltip => '选择日期';

  @override
  String get dateFilterTitle => '分析时段';

  @override
  String get dateFilterSubtitle => '选择常用时段，或拖动日期来分析连续范围。';

  @override
  String get dateFilterApply => '应用筛选';

  @override
  String get dateFilterReset => '今天';

  @override
  String get dateFilterCancel => '取消';

  @override
  String get dateFilterSelectedDates => '已选择时段';

  @override
  String get dateFilterDay => '天';

  @override
  String get dateFilterDays => '天';

  @override
  String get dateFilterReadings => '条读数';

  @override
  String get dateFilterDragHint => '可使用常用时段，也可以按住拖动日期，选择自定义分析范围。';

  @override
  String get tirBreakdownTitle => '目标范围时间分布';

  @override
  String agpTitle(String window) {
    return 'AGP - 动态葡萄糖概览 - $window 模式';
  }

  @override
  String get agpAnnotationDawn => '黎明';

  @override
  String get agpAnnotationPhenomenon => '现象';

  @override
  String get periodNight => '夜间';

  @override
  String get periodMorning => '上午';

  @override
  String get periodAfternoon => '下午';

  @override
  String get periodEvening => '晚间';

  @override
  String minutesPerDay(Object minutes) {
    return '约 $minutes 分钟/天';
  }

  @override
  String get windowShortLast24Hours => '24小时';

  @override
  String get windowShortLast3Days => '3天';

  @override
  String get windowShortLast7Days => '7天';

  @override
  String get windowShortLast14Days => '14天';

  @override
  String get windowShortLast30Days => '30天';

  @override
  String get windowShortLast90Days => '90天';

  @override
  String get windowHeaderLast24Hours => '过去 24 小时';

  @override
  String get windowHeaderLast3Days => '过去 3 天';

  @override
  String get windowHeaderLast7Days => '过去 7 天';

  @override
  String get windowHeaderLast14Days => '过去 14 天';

  @override
  String get windowHeaderLast30Days => '过去 30 天';

  @override
  String get windowHeaderLast90Days => '过去 90 天';

  @override
  String get deltaSame => '持平';

  @override
  String deltaVsPrevious(String delta, String window) {
    return '较上一 $window $delta';
  }
}

/// The translations for Chinese, using the Han script (`zh_Hant`).
class StatisticsLocalizationsZhHant extends StatisticsLocalizationsZh {
  StatisticsLocalizationsZhHant() : super('zh_Hant');

  @override
  String get pluginTitle => '統計';

  @override
  String get pluginSubtitle => '血糖指標、TIR、AGP 與熱力圖。';

  @override
  String get pluginDescription => '血糖指標、TIR、AGP 與熱力圖。';

  @override
  String get pluginReportTitle => '統計報告';

  @override
  String get pluginLoading => '載入中';

  @override
  String get pluginNoData => '暫無可用資料。';

  @override
  String get pluginUnavailable => '不可用';

  @override
  String get pageTitle => '統計';

  @override
  String get exportAction => '匯出 ->';

  @override
  String get dateFilterTooltip => '選擇日期';

  @override
  String get dateFilterTitle => '分析時段';

  @override
  String get dateFilterSubtitle => '選擇常用時段，或拖動日期來分析連續範圍。';

  @override
  String get dateFilterApply => '套用篩選';

  @override
  String get dateFilterReset => '今天';

  @override
  String get dateFilterCancel => '取消';

  @override
  String get dateFilterSelectedDates => '已選擇時段';

  @override
  String get dateFilterDay => '天';

  @override
  String get dateFilterDays => '天';

  @override
  String get dateFilterReadings => '筆讀數';

  @override
  String get dateFilterDragHint => '可使用常用時段，也可以按住拖動日期，選擇自訂分析範圍。';

  @override
  String get tirBreakdownTitle => '目標範圍時間分布';

  @override
  String agpTitle(String window) {
    return 'AGP - 動態葡萄糖概覽 - $window 模式';
  }

  @override
  String get agpAnnotationDawn => '黎明';

  @override
  String get agpAnnotationPhenomenon => '現象';

  @override
  String get periodNight => '夜间';

  @override
  String get periodMorning => '上午';

  @override
  String get periodAfternoon => '下午';

  @override
  String get periodEvening => '晚间';

  @override
  String minutesPerDay(Object minutes) {
    return '约 $minutes 分钟/天';
  }

  @override
  String get windowShortLast24Hours => '24小時';

  @override
  String get windowShortLast3Days => '3天';

  @override
  String get windowShortLast7Days => '7天';

  @override
  String get windowShortLast14Days => '14天';

  @override
  String get windowShortLast30Days => '30天';

  @override
  String get windowShortLast90Days => '90天';

  @override
  String get windowHeaderLast24Hours => '過去 24 小時';

  @override
  String get windowHeaderLast3Days => '過去 3 天';

  @override
  String get windowHeaderLast7Days => '過去 7 天';

  @override
  String get windowHeaderLast14Days => '過去 14 天';

  @override
  String get windowHeaderLast30Days => '過去 30 天';

  @override
  String get windowHeaderLast90Days => '過去 90 天';

  @override
  String get deltaSame => '持平';

  @override
  String deltaVsPrevious(String delta, String window) {
    return '較上一 $window $delta';
  }
}
