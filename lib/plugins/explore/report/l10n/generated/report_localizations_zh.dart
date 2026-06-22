// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'report_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class ReportLocalizationsZh extends ReportLocalizations {
  ReportLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get pluginTitle => '血糖报告';

  @override
  String get pluginSubtitle => '适合医生查看的血糖报告，可打印和分享。';

  @override
  String get pluginDescription => '适合医生查看的血糖报告，可打印和分享。';

  @override
  String get pluginReportTitle => '血糖报告报告';

  @override
  String get pluginLoading => '加载中';

  @override
  String get pluginNoData => '暂无可用数据。';

  @override
  String get pluginUnavailable => '不可用';

  @override
  String get pageSubtitle => 'AGP 标准 · 本地生成 · 导出 PDF 或分享';

  @override
  String get sectionKeyMetrics => '关键指标';

  @override
  String get sectionTimeInRanges => '范围时间';

  @override
  String get sectionAgp => '动态葡萄糖概览';

  @override
  String get sectionDailyCurves => '每日曲线';

  @override
  String get sectionIncludeInReport => '包含在报告中';

  @override
  String get sectionExport => '导出';

  @override
  String get reportDocumentTitle => '血糖报告文档';

  @override
  String reportWearLabel(String wear) {
    return '$wear% 佩戴';
  }

  @override
  String get headerPeriod => '周期';

  @override
  String get headerReadings => '读数';

  @override
  String get headerCoverage => '覆盖率';

  @override
  String get headerDataSource => '数据源';

  @override
  String get headerTargetRange => '目标范围';

  @override
  String get headerGenerated => '生成时间';

  @override
  String get exportPrivacyNote => '报告由本设备上存储的 CGM 读数本地生成，不包含胰岛素、碳水、用药或餐食数据。';

  @override
  String get exportDescription =>
      '适合医生查看的 PDF 会打包当前报告，便于保存或分享；交互式报告仍保留在 App 内。';

  @override
  String get exportSavePdf => '保存为 PDF';

  @override
  String get exportShareSend => '分享 / 发送';

  @override
  String get exportGenerating => '正在生成...';

  @override
  String get metricTir => 'TIR';

  @override
  String get metricAverage => '平均';

  @override
  String get metricWear => '佩戴';

  @override
  String get metricCv => 'CV';

  @override
  String get metricGmi => 'GMI';

  @override
  String get metricSd => 'SD';

  @override
  String get metricTargetUnit => '目标 >=70%';

  @override
  String get metricOnTarget => '达标';

  @override
  String get metricBelowTarget => '低于目标';

  @override
  String get metricSensorActive => '传感器活跃';

  @override
  String get metricCvTargetUnit => '目标 <36%';

  @override
  String get metricGmiUnit => '估算 A1C';

  @override
  String get rangeVeryHigh => '极高';

  @override
  String get rangeHigh => '偏高';

  @override
  String get rangeInRange => '范围内';

  @override
  String get rangeLow => '偏低';

  @override
  String get rangeVeryLow => '极低';

  @override
  String get emptyNoReportData =>
      '暂无报告数据。请连接 xDrip+ Local 或 Nightscout API 并同步读数。';

  @override
  String get periodAnalysisInsufficient => '周期分析数据不足。';

  @override
  String get episodeSummaryInsufficient => '片段摘要数据不足。';

  @override
  String periodAnalysisSummary(
      String bestPeriod, String bestTir, String variablePeriod, String cv) {
    return '$bestPeriod 的 TIR 最高（$bestTir%）。$variablePeriod 波动最大（CV $cv%）。';
  }

  @override
  String episodeSummary(int highCount, int lowCount) {
    return '本报告周期内检测到 $highCount 个高血糖片段和 $lowCount 个低血糖片段。';
  }

  @override
  String unitDays(int days) {
    return '$days 天';
  }

  @override
  String unitReadings(String count) {
    return '$count 条读数';
  }

  @override
  String unitWearActive(String wear, int minutes) {
    return '$wear% 佩戴 - $minutes 活跃分钟';
  }

  @override
  String get toggleKeyMetricsTitle => '关键指标';

  @override
  String get toggleKeyMetricsSubtitle => 'TIR、平均值、佩戴、CV 和 GMI';

  @override
  String get toggleAgpChartTitle => 'AGP 图表';

  @override
  String get toggleAgpChartSubtitle => '24 小时百分位叠加图';

  @override
  String get toggleDailyCurvesTitle => '每日曲线';

  @override
  String get toggleDailyCurvesSubtitle => '最近 14 天，并标记数据稀疏日';

  @override
  String get togglePeriodAnalysisTitle => '周期分析';

  @override
  String get togglePeriodAnalysisSubtitle => '加入分时段模式摘要';

  @override
  String get toggleEpisodesSummaryTitle => '片段摘要';

  @override
  String get toggleEpisodesSummarySubtitle => '加入高/低血糖片段数量';

  @override
  String get sourceNightscoutXdrip => 'Nightscout API + xDrip+ Local';

  @override
  String get sourceXdrip => 'xDrip+ Local HTTP';

  @override
  String get sourceNightscout => 'Nightscout API';

  @override
  String get sourceLocalCache => '本地标准缓存';

  @override
  String get sourceNoData => '无数据源';

  @override
  String get agpOverlayLabel => '24 小时叠加 - 所有日期合并';

  @override
  String get agpLegendMedian => '中位数';

  @override
  String get agpLegendIqr => 'IQR';
}

/// The translations for Chinese, using the Han script (`zh_Hant`).
class ReportLocalizationsZhHant extends ReportLocalizationsZh {
  ReportLocalizationsZhHant() : super('zh_Hant');

  @override
  String get pluginTitle => '血糖報告';

  @override
  String get pluginSubtitle => '適合醫師查看的血糖報告，可列印和分享。';

  @override
  String get pluginDescription => '適合醫師查看的血糖報告，可列印和分享。';

  @override
  String get pluginReportTitle => '血糖報告報告';

  @override
  String get pluginLoading => '載入中';

  @override
  String get pluginNoData => '暫無可用資料。';

  @override
  String get pluginUnavailable => '不可用';

  @override
  String get pageSubtitle => 'AGP 標準 · 本地產生 · 匯出 PDF 或分享';

  @override
  String get sectionKeyMetrics => '關鍵指標';

  @override
  String get sectionTimeInRanges => '範圍時間';

  @override
  String get sectionAgp => '動態葡萄糖概覽';

  @override
  String get sectionDailyCurves => '每日曲線';

  @override
  String get sectionIncludeInReport => '包含在報告中';

  @override
  String get sectionExport => '匯出';

  @override
  String get reportDocumentTitle => '血糖报告文档';

  @override
  String reportWearLabel(String wear) {
    return '$wear% 佩戴';
  }

  @override
  String get headerPeriod => '週期';

  @override
  String get headerReadings => '讀數';

  @override
  String get headerCoverage => '覆蓋率';

  @override
  String get headerDataSource => '資料來源';

  @override
  String get headerTargetRange => '目標範圍';

  @override
  String get headerGenerated => '產生時間';

  @override
  String get exportPrivacyNote => '報告由本裝置上儲存的 CGM 讀數本地產生，不包含胰島素、碳水、用藥或餐食資料。';

  @override
  String get exportDescription =>
      '適合醫師查看的 PDF 會打包目前報告，便於儲存或分享；互動式報告仍保留在 App 內。';

  @override
  String get exportSavePdf => '儲存為 PDF';

  @override
  String get exportShareSend => '分享 / 傳送';

  @override
  String get exportGenerating => '正在產生...';

  @override
  String get metricTir => 'TIR';

  @override
  String get metricAverage => '平均';

  @override
  String get metricWear => '配戴';

  @override
  String get metricCv => 'CV';

  @override
  String get metricGmi => 'GMI';

  @override
  String get metricSd => 'SD';

  @override
  String get metricTargetUnit => '目標 >=70%';

  @override
  String get metricOnTarget => '達標';

  @override
  String get metricBelowTarget => '低於目標';

  @override
  String get metricSensorActive => '感測器活躍';

  @override
  String get metricCvTargetUnit => '目標 <36%';

  @override
  String get metricGmiUnit => '估算 A1C';

  @override
  String get rangeVeryHigh => '極高';

  @override
  String get rangeHigh => '偏高';

  @override
  String get rangeInRange => '範圍內';

  @override
  String get rangeLow => '偏低';

  @override
  String get rangeVeryLow => '極低';

  @override
  String get emptyNoReportData =>
      '暫無報告資料。請連接 xDrip+ Local 或 Nightscout API 並同步讀數。';

  @override
  String get periodAnalysisInsufficient => '週期分析資料不足。';

  @override
  String get episodeSummaryInsufficient => '片段摘要資料不足。';

  @override
  String periodAnalysisSummary(
      String bestPeriod, String bestTir, String variablePeriod, String cv) {
    return '$bestPeriod 的 TIR 最高（$bestTir%）。$variablePeriod 波動最大（CV $cv%）。';
  }

  @override
  String episodeSummary(int highCount, int lowCount) {
    return '本報告週期內偵測到 $highCount 個高血糖片段和 $lowCount 個低血糖片段。';
  }

  @override
  String unitDays(int days) {
    return '$days 天';
  }

  @override
  String unitReadings(String count) {
    return '$count 筆讀數';
  }

  @override
  String unitWearActive(String wear, int minutes) {
    return '$wear% 配戴 - $minutes 活躍分鐘';
  }

  @override
  String get toggleKeyMetricsTitle => '關鍵指標';

  @override
  String get toggleKeyMetricsSubtitle => 'TIR、平均值、配戴、CV 和 GMI';

  @override
  String get toggleAgpChartTitle => 'AGP 圖表';

  @override
  String get toggleAgpChartSubtitle => '24 小時百分位疊加圖';

  @override
  String get toggleDailyCurvesTitle => '每日曲線';

  @override
  String get toggleDailyCurvesSubtitle => '最近 14 天，並標記資料稀疏日';

  @override
  String get togglePeriodAnalysisTitle => '週期分析';

  @override
  String get togglePeriodAnalysisSubtitle => '加入分時段模式摘要';

  @override
  String get toggleEpisodesSummaryTitle => '片段摘要';

  @override
  String get toggleEpisodesSummarySubtitle => '加入高/低血糖片段數量';

  @override
  String get sourceNightscoutXdrip => 'Nightscout API + xDrip+ Local';

  @override
  String get sourceXdrip => 'xDrip+ Local HTTP';

  @override
  String get sourceNightscout => 'Nightscout API';

  @override
  String get sourceLocalCache => '本地標準快取';

  @override
  String get sourceNoData => '無資料來源';

  @override
  String get agpOverlayLabel => '24 小時疊加 - 所有日期合併';

  @override
  String get agpLegendMedian => '中位數';

  @override
  String get agpLegendIqr => 'IQR';
}
