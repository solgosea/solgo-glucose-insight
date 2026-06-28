// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'episode_detail_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class EpisodeDetailLocalizationsZh extends EpisodeDetailLocalizations {
  EpisodeDetailLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get pluginTitle => '事件详情';

  @override
  String get pluginSubtitle => '高/低血糖事件解读与报告。';

  @override
  String get pluginDescription => '高/低血糖事件解读与报告。';

  @override
  String get pluginReportTitle => '事件详情报告';

  @override
  String get reportBrandName => 'Solgo Insight';

  @override
  String get pluginLoading => '加载中';

  @override
  String get pluginNoData => '暂无可用数据。';

  @override
  String get pluginUnavailable => '不可用';

  @override
  String get retry => '重试';

  @override
  String get dataQuality => '数据质量';

  @override
  String get highEpisodeTitle => '高血糖事件';

  @override
  String get lowEpisodeTitle => '低血糖事件';

  @override
  String get noMatchingHighEpisode => '没有匹配的高血糖事件';

  @override
  String get noMatchingLowEpisode => '没有匹配的低血糖事件';

  @override
  String get noRecentHighEpisode => '近期没有高血糖事件';

  @override
  String get noRecentLowEpisode => '近期没有低血糖事件';

  @override
  String get monthJan => '1月';

  @override
  String get monthFeb => '2月';

  @override
  String get monthMar => '3月';

  @override
  String get monthApr => '4月';

  @override
  String get monthMay => '5月';

  @override
  String get monthJun => '6月';

  @override
  String get monthJul => '7月';

  @override
  String get monthAug => '8月';

  @override
  String get monthSep => '9月';

  @override
  String get monthOct => '10月';

  @override
  String get monthNov => '11月';

  @override
  String get monthDec => '12月';

  @override
  String get episodeTimeline => '事件时间线';

  @override
  String get cgmContextBeforeEpisode => 'CGM 背景 · 事件前 2 小时';

  @override
  String get patternAnalysis => '模式分析';

  @override
  String get repeatByTimeOfDay => '按时段查看重复';

  @override
  String get episodeCount => '事件次数';

  @override
  String get highDriverDuration => '持续时间是主要负担驱动。';

  @override
  String get timeBelowRange => '低于范围时间';

  @override
  String get visibleInWindow => '可见窗口内';

  @override
  String get lowDriverMixed => '该事件呈现混合低血糖负担特征。';

  @override
  String get toAboveLowThreshold => '到高于低血糖阈值';

  @override
  String get highEpisodeReportTitle => '高血糖事件报告';

  @override
  String get returnLabel => '回落';

  @override
  String get lowReportContextBody =>
      '除非有记录，本报告无法判断压迫性低血糖、饮食、胰岛素、活动、校准或传感器特定背景。';

  @override
  String get printSave => '打印 / 保存';

  @override
  String get highDriverRepeat => '重复时段是主要复查信号。';

  @override
  String get lowTime => '低血糖时间';

  @override
  String get highDriverMixed => '该事件呈现混合负担特征。';

  @override
  String get lowDriverNadir => '最低点是主要低血糖负担驱动。';

  @override
  String get largestGap => '最大间隔';

  @override
  String get representativeEpisodeCurve => '代表性事件曲线';

  @override
  String get highDriverSlowRecovery => '缓慢恢复是主要负担驱动。';

  @override
  String get highExposureSummary => '高血糖暴露摘要';

  @override
  String get lowestValue => '最低值';

  @override
  String get lowExposureSummary => '低血糖暴露摘要';

  @override
  String get highReportNoCauseBody =>
      '如有相关信息，请结合饮食、胰岛素、活动、输注部位变化、压力和传感器状态一起查看。';

  @override
  String get episodeLifecycle => '事件生命周期';

  @override
  String get toBelowHighThreshold => '到低于高血糖阈值';

  @override
  String get medianRecovery => '中位恢复时间';

  @override
  String get repeatPattern => '重复模式';

  @override
  String get belowLowThreshold => '低于低血糖阈值';

  @override
  String get timeAboveRange => '高于范围时间';

  @override
  String get nadir => '最低点';

  @override
  String get detectedEvents => '检测到的事件';

  @override
  String get highReportDisclaimer =>
      '本地报告。在设备上生成，仅在你选择时分享。本报告只观察高血糖事件，不是医疗建议，也不能替代 CGM 警报、xDrip+、Nightscout 或医疗团队指导。';

  @override
  String get betweenReadings => '读数之间';

  @override
  String get coverage => '覆盖率';

  @override
  String get lowDriverRepeat => '重复时段是主要复查信号。';

  @override
  String get lowEpisodeReportTitle => '低血糖事件报告';

  @override
  String get backToEpisode => '返回事件';

  @override
  String get confidence => '可信度';

  @override
  String get share => '分享';

  @override
  String get lowDriverNocturnal => '夜间时段是主要复查信号。';

  @override
  String get highestPeak => '最高峰值';

  @override
  String get lowReportDisclaimer =>
      '本地报告。在设备上生成，仅在你选择时分享。本报告只观察低血糖事件，不是医疗建议，也不能替代 CGM 警报、xDrip+、Nightscout 或医疗团队指导。';

  @override
  String get highDriverFastRise => '快速上升是主要负担驱动。';

  @override
  String get repeatTimingVisible => '可看到重复时段。';

  @override
  String highReportAboveRangeDuration(String duration) {
    return '代表性事件高于范围持续了 $duration。';
  }

  @override
  String lowReportBelowRangeDuration(String duration) {
    return '代表性事件低于范围持续了 $duration。';
  }

  @override
  String lowReportBelowRangeDurationNadir(String duration, String nadir) {
    return '代表性事件低于范围持续了 $duration，最低到 $nadir。';
  }

  @override
  String highReportRepeatCount(String count, int days) {
    return '过去 $days 天出现了 $count 次高血糖事件。';
  }

  @override
  String lowReportRepeatCount(String count, int days) {
    return '过去 $days 天出现了 $count 次低血糖事件。';
  }

  @override
  String get repeatTimingInsufficientData => '重复模式数据不足，暂时无法形成明确的时段提示。';

  @override
  String get readings => '读数';

  @override
  String get descent => '下降';

  @override
  String get duration => '持续时间';

  @override
  String get lowDriverSlowRecovery => '缓慢恢复是主要复查信号。';

  @override
  String get exporting => '导出中...';

  @override
  String get recovery => '恢复';

  @override
  String get lowReportContextTitle => '需要结合背景理解。';

  @override
  String get repeatTimingLimited => '重复时段证据有限。';

  @override
  String get highEpisodes => '高血糖事件';

  @override
  String get lowDriverFastDescent => '快速下降是主要低血糖负担驱动。';

  @override
  String get medianReturn => '中位回落时间';

  @override
  String get couldNotExportReport => '无法导出报告';

  @override
  String get rise => '上升';

  @override
  String get highDriverPeak => '峰值是主要负担驱动。';

  @override
  String get episodeWindow => '事件窗口';

  @override
  String get baseline => '基线';

  @override
  String get peak => '峰值';

  @override
  String get insufficientData => '数据不足';

  @override
  String get lowEpisodes => '低血糖事件';

  @override
  String get highReportNoCauseTitle => '本报告不推断原因。';

  @override
  String get lowDriverDuration => '持续时间是主要低血糖负担驱动。';

  @override
  String get reviewNotes => '复查要点';

  @override
  String get episodeReview => '事件复查';

  @override
  String get selectedLowUnavailable => '所选低血糖事件可能已不可用。';

  @override
  String get selectedHighUnavailable => '所选高血糖事件可能已不可用。';

  @override
  String get couldNotBuildReport => '无法生成此报告';

  @override
  String get areaAboveTarget => '高于目标面积';

  @override
  String get descentRate => '下降速率';

  @override
  String get preOnsetBaseline => '发生前基线';

  @override
  String get nadirValue => '最低值';

  @override
  String get exposure => '暴露';

  @override
  String get nadirVsUsualDailyNadir => '最低点 vs 日常最低点';

  @override
  String get dropPerMinute => '下降/分钟';

  @override
  String get similarEpisodes => '相似事件';

  @override
  String get peakVsUsualDailyPeak => '峰值 vs 日常峰值';

  @override
  String get preEpisodeBaseline => '事件前基线';

  @override
  String get peakValue => '峰值';

  @override
  String get areaBelowTarget => '低于目标面积';

  @override
  String get area => '面积';

  @override
  String get onsetRate => '起始速率';

  @override
  String get recovered => '已恢复';

  @override
  String get nadirGap => '最低点差值';

  @override
  String get episodeSummary => '事件摘要';

  @override
  String get episodeChart => '事件图表';

  @override
  String get previewReport => '预览报告';

  @override
  String get noReportAvailable => '暂无可用报告';

  @override
  String get backToLatestEpisode => '返回最新事件';

  @override
  String get reviewPriority => '复查优先级';

  @override
  String get notVisible => '不可见';

  @override
  String get value => '数值';

  @override
  String get thirtyDayOccurrenceStrip => '30 天出现条带';

  @override
  String get olderToToday => '较早 -> 今天';

  @override
  String get noEpisode => '无事件';

  @override
  String get episode => '事件';

  @override
  String get current => '当前';

  @override
  String get personalContext => '个人背景';

  @override
  String get burdenBreakdown => '负担拆解';

  @override
  String get mainDriver => '主要驱动';

  @override
  String get recoveryQuality => '恢复质量';

  @override
  String get belowTarget => '低于目标';

  @override
  String get whyReview => '为什么复查';

  @override
  String get night => '夜间';

  @override
  String get returnedInRange => '已回到范围';

  @override
  String get recoveryNotVisible => '未看到恢复';

  @override
  String recoveredAt(Object time) {
    return '恢复于 $time';
  }

  @override
  String get note => '备注';

  @override
  String get veryHigh => '非常高';

  @override
  String get veryLow => '非常低';

  @override
  String get none => '无';

  @override
  String get high => '高';

  @override
  String get low => '低';

  @override
  String get strongHigh => '明显高';

  @override
  String get similarVerySimilar => '非常相似';

  @override
  String get similarSimilar => '相似';

  @override
  String get similarLooseMatch => '弱匹配';

  @override
  String get clusterNight => '夜间聚集';

  @override
  String get clusterAm => '上午聚集';

  @override
  String get clusterPm => '下午聚集';

  @override
  String get clusterEvening => '晚间聚集';

  @override
  String focusedMissingEpisode(Object kind, Object time) {
    return '未找到匹配的$kind事件$time。';
  }

  @override
  String focusedMissingTime(Object time) {
    return '，时间 $time';
  }

  @override
  String get unknown => '未知';

  @override
  String get priorityInfo => '信息';

  @override
  String get priorityNotable => '值得关注';

  @override
  String get priorityImportant => '重要';

  @override
  String get driverPeak => '峰值';

  @override
  String get driverDuration => '持续时间';

  @override
  String get driverFastRise => '快速上升';

  @override
  String get driverSlowRecovery => '恢复较慢';

  @override
  String get driverRepeatTiming => '重复时段';

  @override
  String get driverMixedSignals => '混合信号';

  @override
  String get confidenceHigh => '高置信度';

  @override
  String get confidenceMedium => '中等置信度';

  @override
  String get confidenceLow => '低置信度';

  @override
  String get driverNadir => '最低值';

  @override
  String get driverFastDescent => '快速下降';

  @override
  String get driverNocturnalTiming => '夜间时段';

  @override
  String get recoveryQuick => '快速';

  @override
  String get recoveryGradual => '逐步';

  @override
  String get recoverySlow => '缓慢';

  @override
  String usualRate(Object rate) {
    return '通常 $rate';
  }

  @override
  String similarEpisodesPastDays(Object days) {
    return '相似事件（过去 $days 天）';
  }

  @override
  String get similarEmptyPast30 => '过去 30 天未找到相似事件。';

  @override
  String similarChartNote(Object metric) {
    return '在图表上滑动可吸附到最近事件。X 轴是一天中的时间，Y 轴是$metric血糖，气泡大小表示持续时间。';
  }

  @override
  String get reportRepresentative => '具有代表性';

  @override
  String get reportLimited => '有限';

  @override
  String get reportInsufficient => '数据不足';

  @override
  String get episodeTimeUnavailable => '事件时间不可用';

  @override
  String get similarHighs => '相似高血糖';

  @override
  String pastDays(Object days) {
    return '过去 $days 天';
  }

  @override
  String get medianPeak => '峰值中位数';

  @override
  String get glucosePeak => '血糖峰值';

  @override
  String get medianDuration => '持续时间中位数';

  @override
  String get aboveRange => '高于范围';

  @override
  String get belowRange => '低于范围';

  @override
  String get pdfPreviewSuffix => 'PDF 预览';

  @override
  String get reportPeriod => '报告周期';

  @override
  String get episodeAnalyzed => '分析事件';

  @override
  String get reportGenerated => '生成时间';

  @override
  String get reportDataSource => '数据源';

  @override
  String get thresholds => '阈值';

  @override
  String get episodeView => '事件视图';

  @override
  String get sequence => '顺序';

  @override
  String get past30Days => '过去 30 天';

  @override
  String get timeVsPeak => '时间 vs 峰值';

  @override
  String get highReportHeroSummary =>
      '聚焦高血糖暴露的报告，包含事件曲线、峰值、持续时间、回到范围、重复时段、相似事件和数据质量。';

  @override
  String get lowReportHeroSummary =>
      '聚焦低血糖暴露的报告，包含事件曲线、最低值、持续时间、下降、恢复、重复时段和数据质量。';

  @override
  String highThresholds(Object high, Object veryHigh) {
    return '高 >$high / 极高 >$veryHigh';
  }

  @override
  String lowThresholds(Object low, Object veryLow) {
    return '低 <$low / 极低 <$veryLow';
  }

  @override
  String get repeatLimitedPast30 => '过去 30 天内重复模式有限。';

  @override
  String get start => '开始';

  @override
  String get recover => '恢复';

  @override
  String overTarget(Object amount) {
    return '高于目标 $amount';
  }

  @override
  String get returnTowardRange => '回到目标范围';

  @override
  String get baselineUnavailable => '基线不可用';

  @override
  String baselineValue(Object range) {
    return '基线 $range';
  }

  @override
  String get above => '偏高';

  @override
  String get within => '范围内';

  @override
  String get stable => '稳定';

  @override
  String get rising => '上升';

  @override
  String get variable => '波动';

  @override
  String get dropping => '下降';

  @override
  String get fast => '较快';

  @override
  String get typical => '通常';

  @override
  String get lower => '更低';

  @override
  String get timeWindowVariability => '该时段波动性';

  @override
  String variabilityLabel(Object label) {
    return '$label 波动性';
  }

  @override
  String get notEnoughHistory => '历史数据不足';

  @override
  String cvRank(Object cv, Object rank, Object total) {
    return 'CV $cv% · 排名 $rank/$total';
  }

  @override
  String get samePartOfDay => '一天中的相似时段';

  @override
  String get dayWithRepeatedHighs => '天出现重复高血糖';

  @override
  String get daysWithRepeatedHighs => '天出现重复高血糖';

  @override
  String get dayWithRepeatedLows => '天出现重复低血糖';

  @override
  String get daysWithRepeatedLows => '天出现重复低血糖';

  @override
  String get noClearRepeat => '没有明显重复';

  @override
  String get patternTakeaway => '模式提示';

  @override
  String get timeBlockNight => '夜间';

  @override
  String get timeBlockDawn => '黎明';

  @override
  String get timeBlockMorning => '上午';

  @override
  String get timeBlockAfternoon => '下午';

  @override
  String get timeBlockEvening => '晚间';

  @override
  String clusterTitle(Object label) {
    return '$label 聚集';
  }

  @override
  String repeatedHighsAround(Object label, Object range) {
    return '重复高血糖主要出现在 $label$range。';
  }

  @override
  String repeatedLowsAround(Object label, Object range) {
    return '重复低血糖主要出现在 $label$range。';
  }

  @override
  String get peakRecovery => '峰值 + 恢复';

  @override
  String get peakOnly => '仅峰值';

  @override
  String get nadirRecovery => '最低值 + 恢复';

  @override
  String get nadirOnly => '仅最低值';

  @override
  String get partial => '部分';

  @override
  String get dataConfidence => '数据置信度';

  @override
  String get leadUpDescent => '前段下降';

  @override
  String get overnightSlope => '夜间斜率';

  @override
  String get daytimeSlope => '日间斜率';

  @override
  String get usualUnavailable => '通常水平不可用';

  @override
  String get noCluster => '没有聚集';

  @override
  String get peakGlucose => '峰值血糖';

  @override
  String get nadirGlucose => '最低血糖';

  @override
  String similarCount(Object count) {
    return '$count 个相似';
  }

  @override
  String get noMedian => '无中位数';

  @override
  String minutesMedian(Object minutes) {
    return '$minutes 分钟中位数';
  }

  @override
  String get noMedianValue => '无中位数值';

  @override
  String valueMedian(Object value) {
    return '$value 中位数';
  }

  @override
  String selectedDate(Object date) {
    return '已选择 · $date';
  }

  @override
  String selectedEpisode(Object range, Object kind) {
    return '$range · $kind事件';
  }
}

/// The translations for Chinese, using the Han script (`zh_Hant`).
class EpisodeDetailLocalizationsZhHant extends EpisodeDetailLocalizationsZh {
  EpisodeDetailLocalizationsZhHant() : super('zh_Hant');

  @override
  String get pluginTitle => '事件詳情';

  @override
  String get pluginSubtitle => '高/低血糖事件解讀與報告。';

  @override
  String get pluginDescription => '高/低血糖事件解讀與報告。';

  @override
  String get pluginReportTitle => '事件詳情報告';

  @override
  String get reportBrandName => 'Solgo Insight';

  @override
  String get pluginLoading => '載入中';

  @override
  String get pluginNoData => '暫無可用資料。';

  @override
  String get pluginUnavailable => '不可用';

  @override
  String get retry => '重試';

  @override
  String get dataQuality => '資料品質';

  @override
  String get highEpisodeTitle => '高血糖事件';

  @override
  String get lowEpisodeTitle => '低血糖事件';

  @override
  String get noMatchingHighEpisode => '沒有匹配的高血糖事件';

  @override
  String get noMatchingLowEpisode => '沒有匹配的低血糖事件';

  @override
  String get noRecentHighEpisode => '近期沒有高血糖事件';

  @override
  String get noRecentLowEpisode => '近期沒有低血糖事件';

  @override
  String get monthJan => '1月';

  @override
  String get monthFeb => '2月';

  @override
  String get monthMar => '3月';

  @override
  String get monthApr => '4月';

  @override
  String get monthMay => '5月';

  @override
  String get monthJun => '6月';

  @override
  String get monthJul => '7月';

  @override
  String get monthAug => '8月';

  @override
  String get monthSep => '9月';

  @override
  String get monthOct => '10月';

  @override
  String get monthNov => '11月';

  @override
  String get monthDec => '12月';

  @override
  String get episodeTimeline => '事件時間線';

  @override
  String get cgmContextBeforeEpisode => 'CGM 背景 · 事件前 2 小時';

  @override
  String get patternAnalysis => '模式分析';

  @override
  String get repeatByTimeOfDay => '按時段查看重複';

  @override
  String get episodeCount => '事件次數';

  @override
  String get highDriverDuration => '持續時間是主要負擔驅動。';

  @override
  String get timeBelowRange => '低於範圍時間';

  @override
  String get visibleInWindow => '可见窗口内';

  @override
  String get lowDriverMixed => '該事件呈現混合低血糖負擔特徵。';

  @override
  String get toAboveLowThreshold => '到高於低血糖閾值';

  @override
  String get highEpisodeReportTitle => '高血糖事件報告';

  @override
  String get returnLabel => '回落';

  @override
  String get lowReportContextBody =>
      '除非有記錄，本報告無法判斷壓迫性低血糖、飲食、胰島素、活動、校準或感測器特定背景。';

  @override
  String get printSave => '列印 / 儲存';

  @override
  String get highDriverRepeat => '重複時段是主要複查訊號。';

  @override
  String get lowTime => '低血糖時間';

  @override
  String get highDriverMixed => '該事件呈現混合負擔特徵。';

  @override
  String get lowDriverNadir => '最低點是主要低血糖負擔驅動。';

  @override
  String get largestGap => '最大間隔';

  @override
  String get representativeEpisodeCurve => '代表性事件曲線';

  @override
  String get highDriverSlowRecovery => '緩慢恢復是主要負擔驅動。';

  @override
  String get highExposureSummary => '高血糖暴露摘要';

  @override
  String get lowestValue => '最低值';

  @override
  String get lowExposureSummary => '低血糖暴露摘要';

  @override
  String get highReportNoCauseBody =>
      '如有相關資訊，請結合飲食、胰島素、活動、輸注部位變化、壓力和感測器狀態一起查看。';

  @override
  String get episodeLifecycle => '事件生命週期';

  @override
  String get toBelowHighThreshold => '到低於高血糖閾值';

  @override
  String get medianRecovery => '中位恢復時間';

  @override
  String get repeatPattern => '重複模式';

  @override
  String get belowLowThreshold => '低於低血糖閾值';

  @override
  String get timeAboveRange => '高於範圍時間';

  @override
  String get nadir => '最低點';

  @override
  String get detectedEvents => '偵測到的事件';

  @override
  String get highReportDisclaimer =>
      '本機報告。在裝置上產生，僅在你選擇時分享。本報告只觀察高血糖事件，不是醫療建議，也不能取代 CGM 警報、xDrip+、Nightscout 或醫療團隊指導。';

  @override
  String get betweenReadings => '讀數之間';

  @override
  String get coverage => '覆蓋率';

  @override
  String get lowDriverRepeat => '重複時段是主要複查訊號。';

  @override
  String get lowEpisodeReportTitle => '低血糖事件報告';

  @override
  String get backToEpisode => '返回事件';

  @override
  String get confidence => '可信度';

  @override
  String get share => '分享';

  @override
  String get lowDriverNocturnal => '夜間時段是主要複查訊號。';

  @override
  String get highestPeak => '最高峰值';

  @override
  String get lowReportDisclaimer =>
      '本機報告。在裝置上產生，僅在你選擇時分享。本報告只觀察低血糖事件，不是醫療建議，也不能取代 CGM 警報、xDrip+、Nightscout 或醫療團隊指導。';

  @override
  String get highDriverFastRise => '快速上升是主要負擔驅動。';

  @override
  String get repeatTimingVisible => '可看到重複時段。';

  @override
  String highReportAboveRangeDuration(String duration) {
    return '代表性事件高於範圍持續了 $duration。';
  }

  @override
  String lowReportBelowRangeDuration(String duration) {
    return '代表性事件低於範圍持續了 $duration。';
  }

  @override
  String lowReportBelowRangeDurationNadir(String duration, String nadir) {
    return '代表性事件低於範圍持續了 $duration，最低到 $nadir。';
  }

  @override
  String highReportRepeatCount(String count, int days) {
    return '過去 $days 天出現了 $count 次高血糖事件。';
  }

  @override
  String lowReportRepeatCount(String count, int days) {
    return '過去 $days 天出現了 $count 次低血糖事件。';
  }

  @override
  String get repeatTimingInsufficientData => '重複模式資料不足，暫時無法形成明確的時段提示。';

  @override
  String get readings => '讀數';

  @override
  String get descent => '下降';

  @override
  String get duration => '持續時間';

  @override
  String get lowDriverSlowRecovery => '緩慢恢復是主要複查訊號。';

  @override
  String get exporting => '匯出中...';

  @override
  String get recovery => '恢復';

  @override
  String get lowReportContextTitle => '需要結合背景理解。';

  @override
  String get repeatTimingLimited => '重複時段證據有限。';

  @override
  String get highEpisodes => '高血糖事件';

  @override
  String get lowDriverFastDescent => '快速下降是主要低血糖負擔驅動。';

  @override
  String get medianReturn => '中位回落時間';

  @override
  String get couldNotExportReport => '無法匯出報告';

  @override
  String get rise => '上升';

  @override
  String get highDriverPeak => '峰值是主要負擔驅動。';

  @override
  String get episodeWindow => '事件視窗';

  @override
  String get baseline => '基線';

  @override
  String get peak => '峰值';

  @override
  String get insufficientData => '資料不足';

  @override
  String get lowEpisodes => '低血糖事件';

  @override
  String get highReportNoCauseTitle => '本報告不推斷原因。';

  @override
  String get lowDriverDuration => '持續時間是主要低血糖負擔驅動。';

  @override
  String get reviewNotes => '複查要點';

  @override
  String get episodeReview => '事件複查';

  @override
  String get selectedLowUnavailable => '所選低血糖事件可能已不可用。';

  @override
  String get selectedHighUnavailable => '所選高血糖事件可能已不可用。';

  @override
  String get couldNotBuildReport => '無法產生此報告';

  @override
  String get areaAboveTarget => '高于目标面积';

  @override
  String get descentRate => '下降速率';

  @override
  String get preOnsetBaseline => '发生前基线';

  @override
  String get nadirValue => '最低值';

  @override
  String get exposure => '暴露';

  @override
  String get nadirVsUsualDailyNadir => '最低点 vs 日常最低点';

  @override
  String get dropPerMinute => '下降/分钟';

  @override
  String get similarEpisodes => '相似事件';

  @override
  String get peakVsUsualDailyPeak => '峰值 vs 日常峰值';

  @override
  String get preEpisodeBaseline => '事件前基线';

  @override
  String get peakValue => '峰值';

  @override
  String get areaBelowTarget => '低于目标面积';

  @override
  String get area => '面积';

  @override
  String get onsetRate => '起始速率';

  @override
  String get recovered => '已恢复';

  @override
  String get nadirGap => '最低点差值';

  @override
  String get episodeSummary => '事件摘要';

  @override
  String get episodeChart => '事件图表';

  @override
  String get previewReport => '预览报告';

  @override
  String get noReportAvailable => '暂无可用报告';

  @override
  String get backToLatestEpisode => '返回最新事件';

  @override
  String get reviewPriority => '复查优先级';

  @override
  String get notVisible => '不可见';

  @override
  String get value => '数值';

  @override
  String get thirtyDayOccurrenceStrip => '30 天出现条带';

  @override
  String get olderToToday => '较早 -> 今天';

  @override
  String get noEpisode => '无事件';

  @override
  String get episode => '事件';

  @override
  String get current => '当前';

  @override
  String get personalContext => '个人背景';

  @override
  String get burdenBreakdown => '负担拆解';

  @override
  String get mainDriver => '主要驱动';

  @override
  String get recoveryQuality => '恢复质量';

  @override
  String get belowTarget => '低于目标';

  @override
  String get whyReview => '为什么复查';

  @override
  String get night => '夜间';

  @override
  String get returnedInRange => '已回到范围';

  @override
  String get recoveryNotVisible => '未看到恢复';

  @override
  String recoveredAt(Object time) {
    return '恢复于 $time';
  }

  @override
  String get note => '备注';

  @override
  String get veryHigh => '非常高';

  @override
  String get veryLow => '非常低';

  @override
  String get none => '无';

  @override
  String get high => '高';

  @override
  String get low => '低';

  @override
  String get strongHigh => '明显高';

  @override
  String get similarVerySimilar => '非常相似';

  @override
  String get similarSimilar => '相似';

  @override
  String get similarLooseMatch => '弱匹配';

  @override
  String get clusterNight => '夜间聚集';

  @override
  String get clusterAm => '上午聚集';

  @override
  String get clusterPm => '下午聚集';

  @override
  String get clusterEvening => '晚间聚集';

  @override
  String focusedMissingEpisode(Object kind, Object time) {
    return '未找到匹配的$kind事件$time。';
  }

  @override
  String focusedMissingTime(Object time) {
    return '，时间 $time';
  }

  @override
  String get unknown => '未知';

  @override
  String get priorityInfo => '信息';

  @override
  String get priorityNotable => '值得关注';

  @override
  String get priorityImportant => '重要';

  @override
  String get driverPeak => '峰值';

  @override
  String get driverDuration => '持续时间';

  @override
  String get driverFastRise => '快速上升';

  @override
  String get driverSlowRecovery => '恢复较慢';

  @override
  String get driverRepeatTiming => '重复时段';

  @override
  String get driverMixedSignals => '混合信号';

  @override
  String get confidenceHigh => '高置信度';

  @override
  String get confidenceMedium => '中等置信度';

  @override
  String get confidenceLow => '低置信度';

  @override
  String get driverNadir => '最低值';

  @override
  String get driverFastDescent => '快速下降';

  @override
  String get driverNocturnalTiming => '夜间时段';

  @override
  String get recoveryQuick => '快速';

  @override
  String get recoveryGradual => '逐步';

  @override
  String get recoverySlow => '缓慢';

  @override
  String usualRate(Object rate) {
    return '通常 $rate';
  }

  @override
  String similarEpisodesPastDays(Object days) {
    return '相似事件（过去 $days 天）';
  }

  @override
  String get similarEmptyPast30 => '过去 30 天未找到相似事件。';

  @override
  String similarChartNote(Object metric) {
    return '在图表上滑动可吸附到最近事件。X 轴是一天中的时间，Y 轴是$metric血糖，气泡大小表示持续时间。';
  }

  @override
  String get reportRepresentative => '具有代表性';

  @override
  String get reportLimited => '有限';

  @override
  String get reportInsufficient => '数据不足';

  @override
  String get episodeTimeUnavailable => '事件时间不可用';

  @override
  String get similarHighs => '相似高血糖';

  @override
  String pastDays(Object days) {
    return '过去 $days 天';
  }

  @override
  String get medianPeak => '峰值中位数';

  @override
  String get glucosePeak => '血糖峰值';

  @override
  String get medianDuration => '持续时间中位数';

  @override
  String get aboveRange => '高于范围';

  @override
  String get belowRange => '低于范围';

  @override
  String get pdfPreviewSuffix => 'PDF 预览';

  @override
  String get reportPeriod => '报告周期';

  @override
  String get episodeAnalyzed => '分析事件';

  @override
  String get reportGenerated => '生成时间';

  @override
  String get reportDataSource => '数据源';

  @override
  String get thresholds => '阈值';

  @override
  String get episodeView => '事件视图';

  @override
  String get sequence => '顺序';

  @override
  String get past30Days => '过去 30 天';

  @override
  String get timeVsPeak => '时间 vs 峰值';

  @override
  String get highReportHeroSummary =>
      '聚焦高血糖暴露的报告，包含事件曲线、峰值、持续时间、回到范围、重复时段、相似事件和数据质量。';

  @override
  String get lowReportHeroSummary =>
      '聚焦低血糖暴露的报告，包含事件曲线、最低值、持续时间、下降、恢复、重复时段和数据质量。';

  @override
  String highThresholds(Object high, Object veryHigh) {
    return '高 >$high / 极高 >$veryHigh';
  }

  @override
  String lowThresholds(Object low, Object veryLow) {
    return '低 <$low / 极低 <$veryLow';
  }

  @override
  String get repeatLimitedPast30 => '过去 30 天内重复模式有限。';

  @override
  String get start => '开始';

  @override
  String get recover => '恢复';

  @override
  String overTarget(Object amount) {
    return '高于目标 $amount';
  }

  @override
  String get returnTowardRange => '回到目标范围';

  @override
  String get baselineUnavailable => '基线不可用';

  @override
  String baselineValue(Object range) {
    return '基线 $range';
  }

  @override
  String get above => '偏高';

  @override
  String get within => '范围内';

  @override
  String get stable => '稳定';

  @override
  String get rising => '上升';

  @override
  String get variable => '波动';

  @override
  String get dropping => '下降';

  @override
  String get fast => '较快';

  @override
  String get typical => '通常';

  @override
  String get lower => '更低';

  @override
  String get timeWindowVariability => '该时段波动性';

  @override
  String variabilityLabel(Object label) {
    return '$label 波动性';
  }

  @override
  String get notEnoughHistory => '历史数据不足';

  @override
  String cvRank(Object cv, Object rank, Object total) {
    return 'CV $cv% · 排名 $rank/$total';
  }

  @override
  String get samePartOfDay => '一天中的相似时段';

  @override
  String get dayWithRepeatedHighs => '天出现重复高血糖';

  @override
  String get daysWithRepeatedHighs => '天出现重复高血糖';

  @override
  String get dayWithRepeatedLows => '天出现重复低血糖';

  @override
  String get daysWithRepeatedLows => '天出现重复低血糖';

  @override
  String get noClearRepeat => '没有明显重复';

  @override
  String get patternTakeaway => '模式提示';

  @override
  String get timeBlockNight => '夜间';

  @override
  String get timeBlockDawn => '黎明';

  @override
  String get timeBlockMorning => '上午';

  @override
  String get timeBlockAfternoon => '下午';

  @override
  String get timeBlockEvening => '晚间';

  @override
  String clusterTitle(Object label) {
    return '$label 聚集';
  }

  @override
  String repeatedHighsAround(Object label, Object range) {
    return '重复高血糖主要出现在 $label$range。';
  }

  @override
  String repeatedLowsAround(Object label, Object range) {
    return '重复低血糖主要出现在 $label$range。';
  }

  @override
  String get peakRecovery => '峰值 + 恢复';

  @override
  String get peakOnly => '仅峰值';

  @override
  String get nadirRecovery => '最低值 + 恢复';

  @override
  String get nadirOnly => '仅最低值';

  @override
  String get partial => '部分';

  @override
  String get dataConfidence => '数据置信度';

  @override
  String get leadUpDescent => '前段下降';

  @override
  String get overnightSlope => '夜间斜率';

  @override
  String get daytimeSlope => '日间斜率';

  @override
  String get usualUnavailable => '通常水平不可用';

  @override
  String get noCluster => '没有聚集';

  @override
  String get peakGlucose => '峰值血糖';

  @override
  String get nadirGlucose => '最低血糖';

  @override
  String similarCount(Object count) {
    return '$count 个相似';
  }

  @override
  String get noMedian => '无中位数';

  @override
  String minutesMedian(Object minutes) {
    return '$minutes 分钟中位数';
  }

  @override
  String get noMedianValue => '无中位数值';

  @override
  String valueMedian(Object value) {
    return '$value 中位数';
  }

  @override
  String selectedDate(Object date) {
    return '已选择 · $date';
  }

  @override
  String selectedEpisode(Object range, Object kind) {
    return '$range · $kind事件';
  }
}
