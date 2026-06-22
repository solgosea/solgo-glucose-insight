// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'status_monitor_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class StatusMonitorLocalizationsZh extends StatusMonitorLocalizations {
  StatusMonitorLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get pluginTitle => '状态监控';

  @override
  String get pluginSubtitle => '隐私安全的数据源、同步与支持排障。';

  @override
  String get pluginDescription => '隐私安全的数据源、同步与支持排障。';

  @override
  String get pluginExploreSection => '系统状态';

  @override
  String get pluginReportTitle => '状态监控报告';

  @override
  String get pluginLoading => '加载中';

  @override
  String get pluginNoData => '暂无可用数据。';

  @override
  String get pluginUnavailable => '不可用';

  @override
  String get reportSupportTitle => '状态监控支持报告';

  @override
  String get reportTitle => '状态监控';

  @override
  String get reportEyebrow => '隐私安全的社区支持报告';

  @override
  String get reportSummary =>
      '这是一份可分享的 CGM 数据链排障证据报告。它会提示优先检查的位置，对比本地与云端的新鲜度，并隐藏私有 URL、凭证、主体标识和精确服务器地址。';

  @override
  String get reportDetails => '报告详情';

  @override
  String get reportSupportTriage => '支持排障摘要';

  @override
  String get reportLocalCloudFreshness => '本地与云端新鲜度';

  @override
  String get reportDataChainSnapshot => '数据链快照';

  @override
  String get reportComponentEvidence => '组件证据';

  @override
  String get reportFreshnessCompleteness => '新鲜度与完整性';

  @override
  String get reportSourceCapabilities => '数据源能力';

  @override
  String get reportTechnicalEvidence => '技术证据';

  @override
  String get reportSuggestedFirstLook => '建议优先检查的位置';

  @override
  String get reportPrivacyLabel => '已隐藏 URL、凭证、主体 ID';

  @override
  String get reportDisclaimer =>
      '隐私安全报告。报告在本机生成，仅在用户主动选择时分享。URL、凭证、主体标识和精确服务器地址都会被隐藏。本报告只展示可观察检查结果，不是诊断工具、报警系统或医疗建议。';

  @override
  String reportWindowLiveProbe(Object time) {
    return '过去 24 小时，实时探测 $time';
  }

  @override
  String get reportPrint => '打印';

  @override
  String get reportShare => '分享';

  @override
  String get reportCouldNotExport => '无法导出报告';

  @override
  String get reportCouldNotBuildPreview => '无法生成报告预览';

  @override
  String get reportTryAgain => '重试';

  @override
  String get reportHeaderBrand => 'Solgo Insight';

  @override
  String get reportComponentColumn => '组件';

  @override
  String get reportStatusColumn => '状态';

  @override
  String get reportTakeawayColumn => '结论';

  @override
  String get reportChecksColumn => '检查';

  @override
  String get reportUsefulEvidenceColumn => '有用证据';

  @override
  String get reportMatchesComponents => '匹配状态报告组件';

  @override
  String get reportSafeToShare => '可安全分享';

  @override
  String get reportLast24h => '过去 24 小时';

  @override
  String get reportSourceMode => '数据源模式';

  @override
  String get reportGenerated => '生成时间';

  @override
  String get reportPrivacy => '隐私';

  @override
  String get reportWindow => '窗口';

  @override
  String get reportSuggestedFirstLookLabel => '建议优先检查';

  @override
  String get reportLocalReading => '本地读数';

  @override
  String get reportCloudReading => '云端读数';

  @override
  String get reportAapsContext => 'AAPS 上下文';

  @override
  String get reportLocalActiveStream => '本地 / 当前数据流';

  @override
  String get reportNightscoutCloud => 'Nightscout 云端';

  @override
  String get reportLatestVisibleReading => '最新可见读数';

  @override
  String get reportLatestServerReading => '最新服务器读数';

  @override
  String get reportModeLabel => '模式标签';

  @override
  String get reportAvailable => '可用';

  @override
  String get reportNotExposed => '未暴露';

  @override
  String get reportFastTriage => '快速排查';

  @override
  String get reportLatestLocalReading => '最新本地读数';

  @override
  String get reportLatestNightscoutReading => '最新 Nightscout 读数';

  @override
  String get reportXdripLocalResponse => 'xDrip+ 本地响应';

  @override
  String get reportNightscoutResponse => 'Nightscout 响应';

  @override
  String get reportCompleteness24h => '24 小时完整性';

  @override
  String get reportLargestVisibleGap => '最大可见间隔';

  @override
  String get reportAapsEvidence => 'AAPS 证据';

  @override
  String get reportUnknown => '未知';

  @override
  String get reportNoShareableEvidence => '暂无可分享证据。';

  @override
  String get reportNoEvidence => '无证据';

  @override
  String get reportConfigureCgmSource => '先配置 CGM 数据源。';

  @override
  String get reportConfigureCgmSourceBody =>
      '状态监控需要 xDrip+ 本地或 Nightscout 证据，才能生成有用的支持报告。';

  @override
  String get reportConfigureCgmSourceTakeaway =>
      '当前还看不到已配置的数据源，第一步是连接 xDrip+ 本地或 Nightscout。';

  @override
  String reportStartWithPath(Object path) {
    return '先检查 $path。';
  }

  @override
  String get reportLocalFresherThanCloudBody =>
      '本地 xDrip+ 证据看起来比 Nightscout 数据流更新。请检查上传是否排队、被阻止、被限流，或是否受到 Nightscout 服务器/网络延迟影响。';

  @override
  String reportLocalFresherThanCloudTakeaway(Object path) {
    return '本地读数看起来比 Nightscout 更新，所以最有用的第一步是检查 $path。';
  }

  @override
  String reportStartWithComponent(Object component) {
    return '先检查 $component。';
  }

  @override
  String reportComponentStrongestIssueTakeaway(Object component) {
    return '$component 显示了最明显的问题证据，因此应先检查本地采集路径，再检查云端或闭环上下文。';
  }

  @override
  String get reportStartWithNightscout => '先检查 Nightscout。';

  @override
  String get reportNightscoutFirstTakeaway =>
      'Nightscout 是最明显的关注/问题组件，因此应先检查云端服务器或上传路径。';

  @override
  String get reportAapsContextLimited => 'AAPS 上下文有限，不一定表示故障。';

  @override
  String get reportAapsContextLimitedBody => 'CGM 数据链已有足够的健康证据，但当前数据源看不到闭环上下文。';

  @override
  String get reportAapsContextLimitedTakeaway =>
      '血糖数据链看起来可用；当前数据源中的 AAPS 上下文有限。';

  @override
  String reportAffectedComponentsTakeaway(
      Object affected, Object verb, Object component) {
    return '$affected 正在显示关注/问题证据。先检查 $component，再用组件证据表对比可见检查项。';
  }

  @override
  String get reportAndOthers => '以及其他组件';

  @override
  String get reportUploadServerDelayPath => '上传/服务器延迟路径';

  @override
  String get reportCloudApiPath => '云端/API 路径';

  @override
  String reportComponentPair(Object first, Object second) {
    return '$first 和 $second';
  }

  @override
  String reportComponentPairAndOthers(
      Object first, Object second, Object others) {
    return '$first、$second $others';
  }

  @override
  String get reportVerbIs => '正在';

  @override
  String get reportVerbAre => '正在';

  @override
  String get reportNoMajorStatusIssue => '未发现明显状态问题。';

  @override
  String get reportNoMajorStatusIssueBody =>
      '当前可见检查处于健康范围。如果问题是间歇性的，可将这份报告作为辅助上下文。';

  @override
  String reportIssuePhraseIssue(Object component) {
    return '$component 处于问题状态';
  }

  @override
  String reportIssuePhraseWatch(Object component) {
    return '$component 处于关注状态';
  }

  @override
  String get reportNoDataSourceConfigured => '未配置数据源';

  @override
  String get reportCurrentIssue => '当前问题';

  @override
  String get reportSourceModeCommunity => '数据源模式';

  @override
  String get reportPrivacyCommunity => '隐私：已隐藏 URL/凭证/主体 ID';

  @override
  String get reportCommunityQuestion => '问题：我应该先检查 CGM 数据链的哪一部分？';

  @override
  String reportEvidenceScoreBody(
      Object available, Object components, Object passed, Object total) {
    return '$available/$components 个组件有足够证据。$passed/$total 个检查通过。';
  }

  @override
  String get reportEvidenceScoreTitle => '证据评分';

  @override
  String get reportCopyCommunityPost => '复制社区求助内容';

  @override
  String get reportPrivacySafe => '隐私安全';

  @override
  String get reportObservedFacts => '可观察事实';

  @override
  String get reportLimitsOfReport => '本报告的限制';

  @override
  String get reportTimelineCurrent => '当前';

  @override
  String get reportTimelinePartial => '部分';

  @override
  String get reportTimelineGap => '中断';

  @override
  String reportProbeNotVisible(Object label) {
    return '本报告中看不到 $label。';
  }

  @override
  String reportProbeIsValue(Object label, Object value) {
    return '$label 为 $value。';
  }

  @override
  String get reportLoopContextNotVisible => '无法通过当前数据源看到闭环上下文。';

  @override
  String reportLoopContextEvidence(Object value) {
    return '闭环上下文证据为 $value；不要把它当作闭环决策评估。';
  }

  @override
  String get reportLocalFreshnessNotVisible =>
      '无法看到本地或当前数据流的新鲜度。请先检查已配置的数据源路径，不要直接假设是云端延迟。';

  @override
  String get reportXdripResponseIncomplete => '血糖数据可见，但直接的 xDrip+ 本地响应证据不完整。';

  @override
  String get reportActiveSourceVisible => '血糖数据可通过当前数据源路径看到。';

  @override
  String get reportNightscoutFreshnessNotVisible => '本报告中看不到 Nightscout 读数新鲜度。';

  @override
  String get reportCloudEntriesBehind => '云端 entries 落后于当前数据流。请检查上传、服务器或网络延迟。';

  @override
  String get reportCloudEntriesCurrent =>
      '云端 entries 当前是最新的。如果预期使用本地 xDrip+，请优先检查本地服务暴露。';

  @override
  String get reportFirstInspectionPathTitle => '把这作为第一检查路径，而不是结论。';

  @override
  String get reportFirstInspectionPathBody =>
      '报告指向的是可观察证据。它不能证明根因，也不能替代 CGM 警报。';

  @override
  String get reportNoShareableStatusEvidenceVisible => '暂无可分享的状态证据。';

  @override
  String get reportEvidenceLimitCloud =>
      '本报告无法证明 CGM 厂商云端、Dexcom Share、泵无线连接或手机系统行为。';

  @override
  String get reportEvidenceLimitDeviceLabels => 'Nightscout 设备标签只是线索，不等同于设备真相。';

  @override
  String get reportEvidenceLimitAaps => 'AAPS 上下文取决于当前数据源能够看到的内容。';

  @override
  String get reportEvidenceLimitNotAlarm => '本报告不是报警或诊断工具。';

  @override
  String get pageEyebrowStatusMonitor => '状态监控';

  @override
  String get pageHistoryTitle => '状态历史';

  @override
  String get pageLowBatterySubtitle => '降低状态刷新频率以节省电量。';

  @override
  String get pageFloatingStatusBar => '浮动状态栏';

  @override
  String get pageDashboardSubtitle => 'CGM 传感器 · xDrip+ · Nightscout';

  @override
  String get pageShowNotificationSubtitle => '静默、低优先级的状态监控通知。';

  @override
  String get pageEyebrowLiveStatus => '实时状态';

  @override
  String get pageShowNotificationTitle => '在通知栏显示';

  @override
  String get pageLockScreenStatus => '锁屏状态';

  @override
  String get pageReportTooltip => '报告';

  @override
  String get pageHistorySubtitle => '7 天组件状态';

  @override
  String get pageWidgetsSubtitle => '主屏幕与持续状态展示';

  @override
  String get pageStatusNotification => '状态通知';

  @override
  String get pageLowBatteryTitle => '低电量友好模式';

  @override
  String get pageWidgetsTitle => '小组件与通知';

  @override
  String get pageWidgetTemplates => '小组件模板';

  @override
  String get pageAddToHomeScreen => '添加到主屏幕';

  @override
  String get pageComponents => '组件';

  @override
  String get pageRefreshNow => '立即刷新';

  @override
  String get pageAapsIobCobProfile => 'IOB / COB / 配置';

  @override
  String get pageContextVisibility => '上下文可见性';

  @override
  String get pageProfileTempTarget => '配置 / 临时目标';

  @override
  String get pageSourceNightscoutDeviceStatus => '来源：Nightscout 设备状态';

  @override
  String get pageNoLocalAapsRestAssumed => '不假设本地 AAPS REST';

  @override
  String get pageMissingFieldsReduceConfidence => '缺失字段会降低可信度';

  @override
  String get pagePumpLoopContext => '泵与闭环上下文';

  @override
  String get pageFactualChecksOnly => '仅事实检查';

  @override
  String get pageStatusHealthy => '健康';

  @override
  String get pageStatusWatch => '关注';

  @override
  String get pageStatusIssue => '问题';

  @override
  String get pageStatusUnknown => '未知';

  @override
  String get pageStatusAvailable => '可用';

  @override
  String get pageStatusHistory => '历史';

  @override
  String get pageStatusMixed => '混合';

  @override
  String get pageStatusLive => '实时';

  @override
  String get pageLatestProbe => '最新探测';

  @override
  String get pageLast3h => '最近 3 小时';

  @override
  String get pageLast30m => '最近 30 分钟';

  @override
  String get pageNow => '现在';

  @override
  String get pageThreeHoursAgo => '3 小时前';

  @override
  String get pageFresh => '新鲜';

  @override
  String get pageStalePartial => '过期/部分';

  @override
  String get pageMissing => '缺失';

  @override
  String get pageEvidenceMatrix => '证据矩阵';

  @override
  String get pageLoopEvidenceTimeline => '闭环证据时间线';

  @override
  String pageLatestContext(Object context) {
    return '最新 $context';
  }

  @override
  String get pageNightscoutDeviceStatus => 'Nightscout 设备状态';

  @override
  String get pageOpenapsContext => 'OpenAPS 上下文';

  @override
  String get pageEndpointMatrix => '端点矩阵';

  @override
  String get pageReachable => '可访问';

  @override
  String get pageNotReachable => '不可访问';

  @override
  String get pageCheckedRecently => '最近已检查';

  @override
  String get pageResponseTimeline => '响应时间线';

  @override
  String get pageNoResponseSamples => '暂无响应样本。请在下一次刷新后打开此页面以生成时间线。';

  @override
  String pageMedianMs(Object ms) {
    return '中位数 ${ms}ms';
  }

  @override
  String pageTimeouts(Object count) {
    return '$count 次超时';
  }

  @override
  String get dashboardWaitingForSource => '等待数据源';

  @override
  String get dashboardTemporarilyUnavailable => '状态暂时不可用';

  @override
  String get dashboardRefreshFailedBody =>
      'SolgoInsight 无法刷新当前状态视图。请重试，或检查数据源设置。';

  @override
  String get dashboardCheckingStatus => '正在检查状态';

  @override
  String get dashboardPreparingLatest => 'SolgoInsight 正在准备最新的状态面板。';

  @override
  String get dashboardWaitingTakeaway => '正在等待已配置的数据源。';

  @override
  String get dashboardNoSourceSummary => '当前对象还没有配置数据源。';

  @override
  String get dashboardSourceLabel => '来源';

  @override
  String get dashboardNotConfigured => '未配置';

  @override
  String get dashboardNoSource => '无来源';

  @override
  String get dashboardNeedsSourceHeadline => 'Status 需要先配置数据源。';

  @override
  String get dashboardNeedsSourceBody =>
      '连接 Nightscout 或 xDrip+ Local 后，才能读取 CGM、上传器和服务器状态。';

  @override
  String get dashboardNeedsSourceMeta => '无数据源 - 状态尚未评估';

  @override
  String get dashboardNeedsSourceEmptyReason =>
      '请在 Profile 中设置数据源，以监控 CGM、上传器和服务器状态。';

  @override
  String get notificationChannelTitle => 'Status Monitor';

  @override
  String get notificationChannelDescription => '静默的状态监控通知。';

  @override
  String get pageNoRecentTimeouts => '最近探测中未看到超时';

  @override
  String get pageRecentTimeoutsVisible => '最近探测中可以看到超时';

  @override
  String get pageSensorContext => '传感器上下文';

  @override
  String get pageOptionalSourceData => '可选数据源信息';

  @override
  String get pageSessionAgeRemaining => '会话时长 / 剩余时间';

  @override
  String get pageCollectorContext => '采集器上下文';

  @override
  String get pageCollectorHealthyCopy => '最近一次探测中没有可用的数据源侧采集器警告。';

  @override
  String get pageReadingSource => '读数来源';

  @override
  String pageReadingSourceCopy(Object source) {
    return '最近读数来自 $source，随后进入 CGM 传感器引擎。';
  }

  @override
  String get pageSensorNotice =>
      'SolgoInsight 展示可观察的传感器数据质量。它不能替代 xDrip+ 的传感器处理、校准、主要警报或临床判断。';

  @override
  String get pageLast24h => '最近 24 小时';

  @override
  String get pageContinuous => '连续';

  @override
  String get pageSparse => '稀疏';

  @override
  String get pageGap => '间隔';

  @override
  String get pageUnknownLower => '未知';

  @override
  String pageLatestAge(Object age) {
    return '最新 $age';
  }

  @override
  String get pageNoVisibleGap => '未看到明显间隔';

  @override
  String pageGapBuckets(Object count) {
    return '$count 个间隔桶';
  }

  @override
  String get pageSensorQualityTimeline => '传感器质量时间线';

  @override
  String get pageSuddenJumps => '突变跳点';

  @override
  String pageMajorJumps(Object count) {
    return '$count 个主要跳点';
  }

  @override
  String get pageQuietBaseline => '平静基线';

  @override
  String get pageWatchJump => '关注跳点';

  @override
  String get pageIssueJump => '问题跳点';

  @override
  String get pageNoAbruptSensorJumps => '未看到传感器突变跳点';

  @override
  String pageLargestJump(Object value) {
    return '最大跳点 $value mmol/L';
  }

  @override
  String get pageAdjacentReadingsOnly => '仅比较相邻读数 | 间隔必须不超过 10 分钟';

  @override
  String get pageFlatPeriods => '平直时段';

  @override
  String pageLongestMinutes(Object minutes) {
    return '最长 $minutes 分钟';
  }

  @override
  String get pageWatch30m => '30 分钟关注';

  @override
  String get pageIssue60m => '60 分钟问题';

  @override
  String get pageFlatThresholdReached => '达到平直时段阈值';

  @override
  String get pageNo30mFlatPeriod => '未出现 30 分钟平直时段';

  @override
  String get pageFlatContextNote => '平直时段只是上下文，不是根因标签。';

  @override
  String get pageVariabilityNoise => '波动与噪声';

  @override
  String get pageReadings24h => '24 小时读数';

  @override
  String get pageCvNoise => 'CV / 噪声';

  @override
  String get pageContinuity => '连续性';

  @override
  String get pageCvWatchBody => '关注范围低于 36%。这是波动上下文，不是诊断。';

  @override
  String get pageObservedCadenceBody => '将观察到的读数与预期 5 分钟节奏进行比较。';

  @override
  String pageCadenceFreshnessBody(Object age) {
    return '节奏加上最新传感器新鲜度（$age）。';
  }

  @override
  String get pageServerDataFreshness => '服务器数据新鲜度';

  @override
  String get pageFromEntriesEndpoint => '来自 entries 端点';

  @override
  String get pageLatestServerReading => '最新服务器读数';

  @override
  String get pageAvailableEndpoints => '可用端点';

  @override
  String get pageMeasuredLatestEntry => '根据 Nightscout 返回的最新 entry 测量。';

  @override
  String get pageRecentNightscoutEndpoints => '从 API 探测中解析最近 Nightscout 端点。';

  @override
  String get pageDataFreshnessTimeline => '数据新鲜度时间线';

  @override
  String get pageHealthyCadence => '节奏正常';

  @override
  String get pageDelayed => '延迟';

  @override
  String get pageCompleteness24h => '24小时完整度';

  @override
  String pageExpectedReadings(Object observed, Object expected) {
    return '$observed / $expected 预期';
  }

  @override
  String pageCoveragePercent(Object percent) {
    return '$percent% 覆盖';
  }

  @override
  String get pageExpectedFiveMinuteCadence => '预期 5 分钟一次的读数节奏';

  @override
  String get pageServiceAndBattery => '服务与电量';

  @override
  String get pageLocalService => '本地服务';

  @override
  String get pageXdripLocalModeNote => '/status.json 仅在 xDrip+ 本地模式下可用';

  @override
  String get pageUploaderBattery => '上传端电量';

  @override
  String get pageBatteryPebbleNote => '来自 /pebble 端点的电量信号';

  @override
  String get pageSensorCollectorContext => '传感器与采集器上下文';

  @override
  String get pageOptionalChecks => '可选检查';

  @override
  String get pageUploadLatency => '上传延迟';

  @override
  String get pageUploadLatencyUnavailable => '本地模式无法获得服务器接收时间戳，因此不可用。';

  @override
  String get pageObservedActiveXdripSource => '来自当前活动 xDrip+ 数据源上下文。';

  @override
  String get pageDetectedNightscoutMarkers => '检测到的 Nightscout 标记';

  @override
  String get pageMarkerEvidenceNote => '这是证据，不等同于设备真实状态';

  @override
  String get pageCapabilityContext => '能力上下文';

  @override
  String get pageWhatSiteExposes => '这个站点暴露了什么';

  @override
  String get pageObservedNightscoutApiProbes => '来自 Nightscout API 探测结果。';

  @override
  String get pageFloatingPermissionReady => '浮窗权限已就绪。';

  @override
  String get pageEnableFloatingPermission => '启用浮窗权限';

  @override
  String get pageSevenDayHistory => '7 天历史';

  @override
  String get pageSevenDayHistorySubtitle =>
      '每一行代表一天 - 每天 24 个格子，每小时一个 - 未知表示记录的状态样本不足，无法判断';

  @override
  String get pageToday => '今天';

  @override
  String get pageMonthJan => '1月';

  @override
  String get pageMonthFeb => '2月';

  @override
  String get pageMonthMar => '3月';

  @override
  String get pageMonthApr => '4月';

  @override
  String get pageMonthMay => '5月';

  @override
  String get pageMonthJun => '6月';

  @override
  String get pageMonthJul => '7月';

  @override
  String get pageMonthAug => '8月';

  @override
  String get pageMonthSep => '9月';

  @override
  String get pageMonthOct => '10月';

  @override
  String get pageMonthNov => '11月';

  @override
  String get pageMonthDec => '12月';

  @override
  String get pageXdripSignalMissingReason => '最新报告中未包含这个 xDrip+ 信号';

  @override
  String get pageConnectNightscout => '连接 Nightscout';

  @override
  String get pageSetupSourceBody => '在 Profile 中设置数据源，以监控这个对象的 CGM、上传端和服务器状态。';

  @override
  String get pageSetUp => '设置';

  @override
  String get reportCapabilityEntries => '条目';

  @override
  String get reportCapabilityRangeQuery => '范围查询';

  @override
  String get reportCapabilityPebble => 'Pebble';

  @override
  String get reportCapabilityUploaderBattery => '上传端电量';

  @override
  String get reportCapabilityDeviceStatus => '设备状态';

  @override
  String get reportCapabilityNightscoutStatus => 'Nightscout 状态';

  @override
  String get reportCapabilityUploadLatency => '上传延迟';

  @override
  String get reportConfiguredSource => '已配置的数据源';

  @override
  String reportChecksPassed(Object passed, Object total) {
    return '$passed/$total 项通过';
  }

  @override
  String reportMeetsExpected(Object value, Object expected) {
    return '$value（达到 $expected 条预期）';
  }

  @override
  String reportObservedExpected(
      Object value, Object observed, Object expected) {
    return '$value（$observed/$expected 条预期）';
  }

  @override
  String reportGapsOver15m(Object value, Object count) {
    return '$value，$count 个间隙 >15 分钟';
  }

  @override
  String get widgetStatus => '状态';

  @override
  String get widgetStatusUnavailable => '状态不可用';

  @override
  String get widgetNoRecentStatus => '没有最新状态';

  @override
  String get widgetConnectSourceSummary =>
      '连接 Nightscout 数据源，以监控 CGM、上传端和服务器状态。';

  @override
  String get widgetOpenToRefresh => '打开 SolgoInsight 以刷新最新状态快照。';

  @override
  String get widgetStatusAvailable => '状态可用';

  @override
  String get widgetAllSystemsHealthy => '所有系统正常';

  @override
  String widgetWatchStatus(Object component) {
    return '关注 $component';
  }

  @override
  String widgetComponentIssue(Object component) {
    return '$component 异常';
  }

  @override
  String get widgetUpdatedJustNow => '刚刚更新';

  @override
  String widgetUpdatedMinutesAgo(Object minutes) {
    return '$minutes 分钟前更新';
  }

  @override
  String widgetUpdatedHoursAgo(Object hours) {
    return '$hours 小时前更新';
  }

  @override
  String widgetUpdatedDaysAgo(Object days) {
    return '$days 天前更新';
  }

  @override
  String get metricAccessToken => '访问令牌';

  @override
  String get metricApiReachable => 'API 可访问';

  @override
  String get metricCobContext => 'COB 上下文';

  @override
  String get metricCollectorContext => '采集器上下文';

  @override
  String get metricCv24h => 'CV（24小时）';

  @override
  String get metricDeviceStatus => '设备状态';

  @override
  String get metricDevicestatus => 'devicestatus';

  @override
  String get metricEntriesEndpoint => 'Entries 端点';

  @override
  String get metricFlatLinePeriods => '平直时段';

  @override
  String get metricIobCobContext => 'IOB / COB 上下文';

  @override
  String get metricIobContext => 'IOB 上下文';

  @override
  String get metricLastReadingFreshness => '最新读数新鲜度';

  @override
  String get metricLatestAapsContext => '最新 AAPS 上下文';

  @override
  String get metricLatestServerReading => '最新服务器读数';

  @override
  String get metricLocalService => '本地服务';

  @override
  String get metricLoopContext => '循环上下文';

  @override
  String get metricNightscoutEvidence => 'Nightscout 证据';

  @override
  String get metricNoReadings => '无读数';

  @override
  String get metricP95UploadLatency => 'P95 上传延迟';

  @override
  String get metricProfileTempTarget => 'Profile / 临时目标';

  @override
  String get metricProfileContext => 'Profile 上下文';

  @override
  String get metricPumpContext => '泵上下文';

  @override
  String get metricResponseTime => '响应时间';

  @override
  String get metricSensorContext => '传感器上下文';

  @override
  String get metricSensorDataFreshness => '传感器数据新鲜度';

  @override
  String get metricSensorLifetime => '传感器寿命';

  @override
  String get metricSensorCollectorContext => '传感器/采集器上下文';

  @override
  String get metricSignalContinuity => '信号连续性';

  @override
  String get metricStatusEndpoint => 'Status 端点';

  @override
  String get metricSuddenChanges24h => '突变（24小时）';

  @override
  String get metricUploaderBattery => '上传端电量';

  @override
  String get metricVersionContext => '版本上下文';

  @override
  String metricReadingsCount(Object count) {
    return '$count 条读数';
  }

  @override
  String get metricNotAvailable => '不可用';

  @override
  String get pageAapsSync => 'AAPS 同步';

  @override
  String get pagePump => '泵';

  @override
  String get pageProfile => 'Profile';

  @override
  String get pageNoAapsContext => '没有 AAPS 上下文';

  @override
  String get pageJustNow => '刚刚';

  @override
  String pageMinutesAgoShort(Object minutes) {
    return '$minutes 分钟前';
  }

  @override
  String pageHoursAgoShort(Object hours) {
    return '$hours 小时前';
  }

  @override
  String pageDaysAgoShort(Object days) {
    return '$days 天前';
  }

  @override
  String get pageOpenapsContextNotVisible => 'OpenAPS 上下文不可见。';

  @override
  String get pagePumpContextNotVisibleNightscout => 'Nightscout 中未看到泵上下文。';

  @override
  String get pageIobContextNotVisible => 'IOB 上下文不可见。';

  @override
  String get pageCobContextNotVisible => 'COB 上下文不可见。';

  @override
  String get pageProfileTempTargetNotVisible => 'Profile 或临时目标上下文不可见。';

  @override
  String get pageNightscoutApiReachableEvidence => '可访问。设备状态端点返回了证据。';

  @override
  String get pageNightscoutConfiguredEvidenceUnavailable =>
      'Nightscout 已配置，但当前证据不可用。';

  @override
  String get pageNoNightscoutTargetConfigured => '尚未配置 Nightscout 目标。';

  @override
  String get pageNoOpenapsLoopContextVisible => '采样的设备状态中没有可见的 OpenAPS 循环上下文。';

  @override
  String get pageNoRecentProfileTempTargetContext =>
      '采样响应中没有最近的 Profile 或临时目标上下文。';

  @override
  String get pagePartial => '部分可见';

  @override
  String get pageVisible => '可见';

  @override
  String get pageNoTimelineData => '没有时间线数据';

  @override
  String pageLatestTimelineLabel(Object label) {
    return '最新 $label';
  }

  @override
  String get pageNoVisibleIssueCluster => '没有可见的问题聚集';

  @override
  String pageIssueBucketsInView(Object count) {
    return '视图中有 $count 个问题时段';
  }

  @override
  String get pageOlder => '更早';

  @override
  String get pageMid => '中段';

  @override
  String get pageCurrentReadings => '当前读数';

  @override
  String get pagePossibleDirections => '可能的排查方向';

  @override
  String get pageModeReadingsQuality => '读数质量';

  @override
  String get pageModeLocalService => '本地服务';

  @override
  String get pageModeNightscoutApi => 'Nightscout API';

  @override
  String get pageModeNightscoutEvidence => 'Nightscout 证据';

  @override
  String get pageComponentCgmSensor => 'CGM 传感器';

  @override
  String get pageComponentXdrip => 'xDrip+';

  @override
  String get pageComponentNightscout => 'Nightscout';

  @override
  String get pageComponentAapsLoop => 'AAPS 循环';

  @override
  String get pageLatestSensorReadingObserved => '最新观察到的传感器读数';

  @override
  String get pageConfidenceAvailableMetrics => '基于可用指标的可信度';

  @override
  String get pageConfidenceAvailableEndpoints => '基于可用端点的可信度';

  @override
  String get pageConfidenceAvailableContext => '基于可用上下文的可信度';

  @override
  String get pageConfidenceNightscoutEvidence => '基于 Nightscout 证据的可信度';

  @override
  String pageChecksPassedShort(Object available, Object total) {
    return '$available/$total 项检查通过';
  }

  @override
  String get pageLockScreenDisabled => '锁屏状态已关闭';

  @override
  String get pageNotificationLowPriorityNote => '仅显示低优先级状态。没有声音、震动、稍后提醒或手动消除。';

  @override
  String get pageHowToPlaceWidget => '如何放置小组件';

  @override
  String get pageWidgetStepLongPress => '长按主屏幕任意空白区域';

  @override
  String get pageWidgetStepTapWidgets =>
      '点击小组件，然后滚动到 SolgoInsight Status Monitor';

  @override
  String get pageWidgetStepDragTemplate => '拖动一个状态模板到主屏幕';

  @override
  String get pageStatusDataNotReady => '状态数据尚未准备好。配置数据源后再打开 Status Monitor。';

  @override
  String pageSamplesRecorded(Object percent) {
    return '已记录 $percent% 样本';
  }

  @override
  String get pageDailySummary7Days => '每日汇总 - 7 天';

  @override
  String get pageHourlyDetail => '小时详情';

  @override
  String get pageHistoryScopeNote =>
      '历史记录限定在当前用户和数据源内。它记录 Status Monitor 刷新得到的组件快照；Unknown 表示该小时没有足够的样本数据可判断。';

  @override
  String get pageHistoryReasonRecordedSample => '已记录样本';

  @override
  String get pageHistoryReasonCarriedForward => '沿用上一状态';

  @override
  String get pageHistoryReasonNoSample => '无样本';

  @override
  String get pageHistoryReasonFuture => '未来小时';
}

/// The translations for Chinese, using the Han script (`zh_Hant`).
class StatusMonitorLocalizationsZhHant extends StatusMonitorLocalizationsZh {
  StatusMonitorLocalizationsZhHant() : super('zh_Hant');

  @override
  String get pluginTitle => '狀態監控';

  @override
  String get pluginSubtitle => '隱私安全的資料來源、同步與支援排障。';

  @override
  String get pluginDescription => '隱私安全的資料來源、同步與支援排障。';

  @override
  String get pluginExploreSection => '系統狀態';

  @override
  String get pluginReportTitle => '狀態監控報告';

  @override
  String get pluginLoading => '載入中';

  @override
  String get pluginNoData => '暫無可用資料。';

  @override
  String get pluginUnavailable => '不可用';

  @override
  String get reportSupportTitle => '狀態監控支援報告';

  @override
  String get reportTitle => '狀態監控';

  @override
  String get reportEyebrow => '隱私安全的社群支援報告';

  @override
  String get reportSummary =>
      '這是一份可分享的 CGM 資料鏈排障證據報告。它會提示優先檢查的位置，對比本地與雲端的新鮮度，並隱藏私人 URL、憑證、主體識別和精確伺服器位址。';

  @override
  String get reportDetails => '報告詳情';

  @override
  String get reportSupportTriage => '支援排障摘要';

  @override
  String get reportLocalCloudFreshness => '本地與雲端新鮮度';

  @override
  String get reportDataChainSnapshot => '資料鏈快照';

  @override
  String get reportComponentEvidence => '元件證據';

  @override
  String get reportFreshnessCompleteness => '新鮮度與完整性';

  @override
  String get reportSourceCapabilities => '資料來源能力';

  @override
  String get reportTechnicalEvidence => '技術證據';

  @override
  String get reportSuggestedFirstLook => '建議優先檢查的位置';

  @override
  String get reportPrivacyLabel => '已隱藏 URL、憑證、主體 ID';

  @override
  String get reportDisclaimer =>
      '隱私安全報告。報告在本機產生，僅在使用者主動選擇時分享。URL、憑證、主體識別和精確伺服器位址都會被隱藏。本報告只展示可觀察檢查結果，不是診斷工具、警報系統或醫療建議。';

  @override
  String reportWindowLiveProbe(Object time) {
    return '過去 24 小時，即時探測 $time';
  }

  @override
  String get reportPrint => '列印';

  @override
  String get reportShare => '分享';

  @override
  String get reportCouldNotExport => '無法匯出報告';

  @override
  String get reportCouldNotBuildPreview => '無法產生報告預覽';

  @override
  String get reportTryAgain => '重試';

  @override
  String get reportHeaderBrand => 'Solgo Insight';

  @override
  String get reportComponentColumn => '元件';

  @override
  String get reportStatusColumn => '狀態';

  @override
  String get reportTakeawayColumn => '結論';

  @override
  String get reportChecksColumn => '檢查';

  @override
  String get reportUsefulEvidenceColumn => '有用證據';

  @override
  String get reportMatchesComponents => '符合狀態報告元件';

  @override
  String get reportSafeToShare => '可安全分享';

  @override
  String get reportLast24h => '過去 24 小時';

  @override
  String get reportSourceMode => '資料來源模式';

  @override
  String get reportGenerated => '產生時間';

  @override
  String get reportPrivacy => '隱私';

  @override
  String get reportWindow => '視窗';

  @override
  String get reportSuggestedFirstLookLabel => '建议优先检查';

  @override
  String get reportLocalReading => '本地读数';

  @override
  String get reportCloudReading => '云端读数';

  @override
  String get reportAapsContext => 'AAPS 上下文';

  @override
  String get reportLocalActiveStream => '本地 / 当前数据流';

  @override
  String get reportNightscoutCloud => 'Nightscout 云端';

  @override
  String get reportLatestVisibleReading => '最新可见读数';

  @override
  String get reportLatestServerReading => '最新服务器读数';

  @override
  String get reportModeLabel => '模式标签';

  @override
  String get reportAvailable => '可用';

  @override
  String get reportNotExposed => '未暴露';

  @override
  String get reportFastTriage => '快速排查';

  @override
  String get reportLatestLocalReading => '最新本地读数';

  @override
  String get reportLatestNightscoutReading => '最新 Nightscout 读数';

  @override
  String get reportXdripLocalResponse => 'xDrip+ 本地响应';

  @override
  String get reportNightscoutResponse => 'Nightscout 响应';

  @override
  String get reportCompleteness24h => '24 小时完整性';

  @override
  String get reportLargestVisibleGap => '最大可见间隔';

  @override
  String get reportAapsEvidence => 'AAPS 证据';

  @override
  String get reportUnknown => '未知';

  @override
  String get reportNoShareableEvidence => '暂无可分享证据。';

  @override
  String get reportNoEvidence => '无证据';

  @override
  String get reportConfigureCgmSource => '先配置 CGM 数据源。';

  @override
  String get reportConfigureCgmSourceBody =>
      '状态监控需要 xDrip+ 本地或 Nightscout 证据，才能生成有用的支持报告。';

  @override
  String get reportConfigureCgmSourceTakeaway =>
      '当前还看不到已配置的数据源，第一步是连接 xDrip+ 本地或 Nightscout。';

  @override
  String reportStartWithPath(Object path) {
    return '先检查 $path。';
  }

  @override
  String get reportLocalFresherThanCloudBody =>
      '本地 xDrip+ 证据看起来比 Nightscout 数据流更新。请检查上传是否排队、被阻止、被限流，或是否受到 Nightscout 服务器/网络延迟影响。';

  @override
  String reportLocalFresherThanCloudTakeaway(Object path) {
    return '本地读数看起来比 Nightscout 更新，所以最有用的第一步是检查 $path。';
  }

  @override
  String reportStartWithComponent(Object component) {
    return '先检查 $component。';
  }

  @override
  String reportComponentStrongestIssueTakeaway(Object component) {
    return '$component 显示了最明显的问题证据，因此应先检查本地采集路径，再检查云端或闭环上下文。';
  }

  @override
  String get reportStartWithNightscout => '先检查 Nightscout。';

  @override
  String get reportNightscoutFirstTakeaway =>
      'Nightscout 是最明显的关注/问题组件，因此应先检查云端服务器或上传路径。';

  @override
  String get reportAapsContextLimited => 'AAPS 上下文有限，不一定表示故障。';

  @override
  String get reportAapsContextLimitedBody => 'CGM 数据链已有足够的健康证据，但当前数据源看不到闭环上下文。';

  @override
  String get reportAapsContextLimitedTakeaway =>
      '血糖数据链看起来可用；当前数据源中的 AAPS 上下文有限。';

  @override
  String reportAffectedComponentsTakeaway(
      Object affected, Object verb, Object component) {
    return '$affected 正在显示关注/问题证据。先检查 $component，再用组件证据表对比可见检查项。';
  }

  @override
  String get reportAndOthers => '以及其他组件';

  @override
  String get reportUploadServerDelayPath => '上传/服务器延迟路径';

  @override
  String get reportCloudApiPath => '云端/API 路径';

  @override
  String reportComponentPair(Object first, Object second) {
    return '$first 和 $second';
  }

  @override
  String reportComponentPairAndOthers(
      Object first, Object second, Object others) {
    return '$first、$second $others';
  }

  @override
  String get reportVerbIs => '正在';

  @override
  String get reportVerbAre => '正在';

  @override
  String get reportNoMajorStatusIssue => '未发现明显状态问题。';

  @override
  String get reportNoMajorStatusIssueBody =>
      '当前可见检查处于健康范围。如果问题是间歇性的，可将这份报告作为辅助上下文。';

  @override
  String reportIssuePhraseIssue(Object component) {
    return '$component 处于问题状态';
  }

  @override
  String reportIssuePhraseWatch(Object component) {
    return '$component 处于关注状态';
  }

  @override
  String get reportNoDataSourceConfigured => '未配置数据源';

  @override
  String get reportCurrentIssue => '当前问题';

  @override
  String get reportSourceModeCommunity => '数据源模式';

  @override
  String get reportPrivacyCommunity => '隐私：已隐藏 URL/凭证/主体 ID';

  @override
  String get reportCommunityQuestion => '问题：我应该先检查 CGM 数据链的哪一部分？';

  @override
  String reportEvidenceScoreBody(
      Object available, Object components, Object passed, Object total) {
    return '$available/$components 个组件有足够证据。$passed/$total 个检查通过。';
  }

  @override
  String get reportEvidenceScoreTitle => '證據評分';

  @override
  String get reportCopyCommunityPost => '複製社群求助內容';

  @override
  String get reportPrivacySafe => '隱私安全';

  @override
  String get reportObservedFacts => '可觀察事實';

  @override
  String get reportLimitsOfReport => '本報告的限制';

  @override
  String get reportTimelineCurrent => '目前';

  @override
  String get reportTimelinePartial => '部分';

  @override
  String get reportTimelineGap => '中斷';

  @override
  String reportProbeNotVisible(Object label) {
    return '本报告中看不到 $label。';
  }

  @override
  String reportProbeIsValue(Object label, Object value) {
    return '$label 为 $value。';
  }

  @override
  String get reportLoopContextNotVisible => '无法通过当前数据源看到闭环上下文。';

  @override
  String reportLoopContextEvidence(Object value) {
    return '闭环上下文证据为 $value；不要把它当作闭环决策评估。';
  }

  @override
  String get reportLocalFreshnessNotVisible =>
      '无法看到本地或当前数据流的新鲜度。请先检查已配置的数据源路径，不要直接假设是云端延迟。';

  @override
  String get reportXdripResponseIncomplete => '血糖数据可见，但直接的 xDrip+ 本地响应证据不完整。';

  @override
  String get reportActiveSourceVisible => '血糖数据可通过当前数据源路径看到。';

  @override
  String get reportNightscoutFreshnessNotVisible => '本报告中看不到 Nightscout 读数新鲜度。';

  @override
  String get reportCloudEntriesBehind => '云端 entries 落后于当前数据流。请检查上传、服务器或网络延迟。';

  @override
  String get reportCloudEntriesCurrent =>
      '云端 entries 当前是最新的。如果预期使用本地 xDrip+，请优先检查本地服务暴露。';

  @override
  String get reportFirstInspectionPathTitle => '把这作为第一检查路径，而不是结论。';

  @override
  String get reportFirstInspectionPathBody =>
      '报告指向的是可观察证据。它不能证明根因，也不能替代 CGM 警报。';

  @override
  String get reportNoShareableStatusEvidenceVisible => '暂无可分享的状态证据。';

  @override
  String get reportEvidenceLimitCloud =>
      '本报告无法证明 CGM 厂商云端、Dexcom Share、泵无线连接或手机系统行为。';

  @override
  String get reportEvidenceLimitDeviceLabels => 'Nightscout 设备标签只是线索，不等同于设备真相。';

  @override
  String get reportEvidenceLimitAaps => 'AAPS 上下文取决于当前数据源能够看到的内容。';

  @override
  String get reportEvidenceLimitNotAlarm => '本报告不是报警或诊断工具。';

  @override
  String get pageEyebrowStatusMonitor => '状态监控';

  @override
  String get pageHistoryTitle => '状态历史';

  @override
  String get pageLowBatterySubtitle => '降低状态刷新频率以节省电量。';

  @override
  String get pageFloatingStatusBar => '浮动状态栏';

  @override
  String get pageDashboardSubtitle => 'CGM 传感器 · xDrip+ · Nightscout';

  @override
  String get pageShowNotificationSubtitle => '静默、低优先级的状态监控通知。';

  @override
  String get pageEyebrowLiveStatus => '实时状态';

  @override
  String get pageShowNotificationTitle => '在通知栏显示';

  @override
  String get pageLockScreenStatus => '锁屏状态';

  @override
  String get pageReportTooltip => '报告';

  @override
  String get pageHistorySubtitle => '7 天组件状态';

  @override
  String get pageWidgetsSubtitle => '主屏幕与持续状态展示';

  @override
  String get pageStatusNotification => '状态通知';

  @override
  String get pageLowBatteryTitle => '低电量友好模式';

  @override
  String get pageWidgetsTitle => '小组件与通知';

  @override
  String get pageWidgetTemplates => '小组件模板';

  @override
  String get pageAddToHomeScreen => '添加到主屏幕';

  @override
  String get pageComponents => '组件';

  @override
  String get pageRefreshNow => '立即刷新';

  @override
  String get pageAapsIobCobProfile => 'IOB / COB / 配置';

  @override
  String get pageContextVisibility => '上下文可见性';

  @override
  String get pageProfileTempTarget => '配置 / 临时目标';

  @override
  String get pageSourceNightscoutDeviceStatus => '来源：Nightscout 设备状态';

  @override
  String get pageNoLocalAapsRestAssumed => '不假设本地 AAPS REST';

  @override
  String get pageMissingFieldsReduceConfidence => '缺失字段会降低可信度';

  @override
  String get pagePumpLoopContext => '泵与闭环上下文';

  @override
  String get pageFactualChecksOnly => '仅事实检查';

  @override
  String get pageStatusHealthy => '健康';

  @override
  String get pageStatusWatch => '关注';

  @override
  String get pageStatusIssue => '问题';

  @override
  String get pageStatusUnknown => '未知';

  @override
  String get pageStatusAvailable => '可用';

  @override
  String get pageStatusHistory => '历史';

  @override
  String get pageStatusMixed => '混合';

  @override
  String get pageStatusLive => '实时';

  @override
  String get pageLatestProbe => '最新探测';

  @override
  String get pageLast3h => '最近 3 小时';

  @override
  String get pageLast30m => '最近 30 分钟';

  @override
  String get pageNow => '现在';

  @override
  String get pageThreeHoursAgo => '3 小时前';

  @override
  String get pageFresh => '新鲜';

  @override
  String get pageStalePartial => '过期/部分';

  @override
  String get pageMissing => '缺失';

  @override
  String get pageEvidenceMatrix => '证据矩阵';

  @override
  String get pageLoopEvidenceTimeline => '闭环证据时间线';

  @override
  String pageLatestContext(Object context) {
    return '最新 $context';
  }

  @override
  String get pageNightscoutDeviceStatus => 'Nightscout 设备状态';

  @override
  String get pageOpenapsContext => 'OpenAPS 上下文';

  @override
  String get pageEndpointMatrix => '端点矩阵';

  @override
  String get pageReachable => '可访问';

  @override
  String get pageNotReachable => '不可访问';

  @override
  String get pageCheckedRecently => '最近已检查';

  @override
  String get pageResponseTimeline => '响应时间线';

  @override
  String get pageNoResponseSamples => '暂无响应样本。请在下一次刷新后打开此页面以生成时间线。';

  @override
  String pageMedianMs(Object ms) {
    return '中位数 ${ms}ms';
  }

  @override
  String pageTimeouts(Object count) {
    return '$count 次超时';
  }

  @override
  String get dashboardWaitingForSource => '等待数据源';

  @override
  String get dashboardTemporarilyUnavailable => '状态暂时不可用';

  @override
  String get dashboardRefreshFailedBody =>
      'SolgoInsight 无法刷新当前状态视图。请重试，或检查数据源设置。';

  @override
  String get dashboardCheckingStatus => '正在检查状态';

  @override
  String get dashboardPreparingLatest => 'SolgoInsight 正在准备最新的状态面板。';

  @override
  String get dashboardWaitingTakeaway => '正在等待已配置的数据源。';

  @override
  String get dashboardNoSourceSummary => '当前对象还没有配置数据源。';

  @override
  String get dashboardSourceLabel => '来源';

  @override
  String get dashboardNotConfigured => '未配置';

  @override
  String get dashboardNoSource => '无来源';

  @override
  String get dashboardNeedsSourceHeadline => 'Status 需要先配置数据源。';

  @override
  String get dashboardNeedsSourceBody =>
      '连接 Nightscout 或 xDrip+ Local 后，才能读取 CGM、上传器和服务器状态。';

  @override
  String get dashboardNeedsSourceMeta => '无数据源 - 状态尚未评估';

  @override
  String get dashboardNeedsSourceEmptyReason =>
      '请在 Profile 中设置数据源，以监控 CGM、上传器和服务器状态。';

  @override
  String get notificationChannelTitle => 'Status Monitor';

  @override
  String get notificationChannelDescription => '静默的状态监控通知。';

  @override
  String get pageNoRecentTimeouts => '最近探测中未看到超时';

  @override
  String get pageRecentTimeoutsVisible => '最近探测中可以看到超时';

  @override
  String get pageSensorContext => '传感器上下文';

  @override
  String get pageOptionalSourceData => '可选数据源信息';

  @override
  String get pageSessionAgeRemaining => '会话时长 / 剩余时间';

  @override
  String get pageCollectorContext => '采集器上下文';

  @override
  String get pageCollectorHealthyCopy => '最近一次探测中没有可用的数据源侧采集器警告。';

  @override
  String get pageReadingSource => '读数来源';

  @override
  String pageReadingSourceCopy(Object source) {
    return '最近读数来自 $source，随后进入 CGM 传感器引擎。';
  }

  @override
  String get pageSensorNotice =>
      'SolgoInsight 展示可观察的传感器数据质量。它不能替代 xDrip+ 的传感器处理、校准、主要警报或临床判断。';

  @override
  String get pageLast24h => '最近 24 小时';

  @override
  String get pageContinuous => '连续';

  @override
  String get pageSparse => '稀疏';

  @override
  String get pageGap => '间隔';

  @override
  String get pageUnknownLower => '未知';

  @override
  String pageLatestAge(Object age) {
    return '最新 $age';
  }

  @override
  String get pageNoVisibleGap => '未看到明显间隔';

  @override
  String pageGapBuckets(Object count) {
    return '$count 个间隔桶';
  }

  @override
  String get pageSensorQualityTimeline => '传感器质量时间线';

  @override
  String get pageSuddenJumps => '突变跳点';

  @override
  String pageMajorJumps(Object count) {
    return '$count 个主要跳点';
  }

  @override
  String get pageQuietBaseline => '平静基线';

  @override
  String get pageWatchJump => '关注跳点';

  @override
  String get pageIssueJump => '问题跳点';

  @override
  String get pageNoAbruptSensorJumps => '未看到传感器突变跳点';

  @override
  String pageLargestJump(Object value) {
    return '最大跳点 $value mmol/L';
  }

  @override
  String get pageAdjacentReadingsOnly => '仅比较相邻读数 | 间隔必须不超过 10 分钟';

  @override
  String get pageFlatPeriods => '平直时段';

  @override
  String pageLongestMinutes(Object minutes) {
    return '最长 $minutes 分钟';
  }

  @override
  String get pageWatch30m => '30 分钟关注';

  @override
  String get pageIssue60m => '60 分钟问题';

  @override
  String get pageFlatThresholdReached => '达到平直时段阈值';

  @override
  String get pageNo30mFlatPeriod => '未出现 30 分钟平直时段';

  @override
  String get pageFlatContextNote => '平直时段只是上下文，不是根因标签。';

  @override
  String get pageVariabilityNoise => '波动与噪声';

  @override
  String get pageReadings24h => '24 小时读数';

  @override
  String get pageCvNoise => 'CV / 噪声';

  @override
  String get pageContinuity => '连续性';

  @override
  String get pageCvWatchBody => '关注范围低于 36%。这是波动上下文，不是诊断。';

  @override
  String get pageObservedCadenceBody => '将观察到的读数与预期 5 分钟节奏进行比较。';

  @override
  String pageCadenceFreshnessBody(Object age) {
    return '节奏加上最新传感器新鲜度（$age）。';
  }

  @override
  String get pageServerDataFreshness => '服务器数据新鲜度';

  @override
  String get pageFromEntriesEndpoint => '来自 entries 端点';

  @override
  String get pageLatestServerReading => '最新服务器读数';

  @override
  String get pageAvailableEndpoints => '可用端点';

  @override
  String get pageMeasuredLatestEntry => '根据 Nightscout 返回的最新 entry 测量。';

  @override
  String get pageRecentNightscoutEndpoints => '从 API 探测中解析最近 Nightscout 端点。';

  @override
  String get pageDataFreshnessTimeline => '数据新鲜度时间线';

  @override
  String get pageHealthyCadence => '节奏正常';

  @override
  String get pageDelayed => '延迟';

  @override
  String get pageCompleteness24h => '24小时完整度';

  @override
  String pageExpectedReadings(Object observed, Object expected) {
    return '$observed / $expected 预期';
  }

  @override
  String pageCoveragePercent(Object percent) {
    return '$percent% 覆盖';
  }

  @override
  String get pageExpectedFiveMinuteCadence => '预期 5 分钟一次的读数节奏';

  @override
  String get pageServiceAndBattery => '服务与电量';

  @override
  String get pageLocalService => '本地服务';

  @override
  String get pageXdripLocalModeNote => '/status.json 仅在 xDrip+ 本地模式下可用';

  @override
  String get pageUploaderBattery => '上传端电量';

  @override
  String get pageBatteryPebbleNote => '来自 /pebble 端点的电量信号';

  @override
  String get pageSensorCollectorContext => '传感器与采集器上下文';

  @override
  String get pageOptionalChecks => '可选检查';

  @override
  String get pageUploadLatency => '上传延迟';

  @override
  String get pageUploadLatencyUnavailable => '本地模式无法获得服务器接收时间戳，因此不可用。';

  @override
  String get pageObservedActiveXdripSource => '来自当前活动 xDrip+ 数据源上下文。';

  @override
  String get pageDetectedNightscoutMarkers => '检测到的 Nightscout 标记';

  @override
  String get pageMarkerEvidenceNote => '这是证据，不等同于设备真实状态';

  @override
  String get pageCapabilityContext => '能力上下文';

  @override
  String get pageWhatSiteExposes => '这个站点暴露了什么';

  @override
  String get pageObservedNightscoutApiProbes => '来自 Nightscout API 探测结果。';

  @override
  String get pageFloatingPermissionReady => '浮窗权限已就绪。';

  @override
  String get pageEnableFloatingPermission => '启用浮窗权限';

  @override
  String get pageSevenDayHistory => '7 天历史';

  @override
  String get pageSevenDayHistorySubtitle =>
      '每一行代表一天 - 每天 24 个格子，每小时一个 - 未知表示记录的状态样本不足，无法判断';

  @override
  String get pageToday => '今天';

  @override
  String get pageMonthJan => '1月';

  @override
  String get pageMonthFeb => '2月';

  @override
  String get pageMonthMar => '3月';

  @override
  String get pageMonthApr => '4月';

  @override
  String get pageMonthMay => '5月';

  @override
  String get pageMonthJun => '6月';

  @override
  String get pageMonthJul => '7月';

  @override
  String get pageMonthAug => '8月';

  @override
  String get pageMonthSep => '9月';

  @override
  String get pageMonthOct => '10月';

  @override
  String get pageMonthNov => '11月';

  @override
  String get pageMonthDec => '12月';

  @override
  String get pageXdripSignalMissingReason => '最新报告中未包含这个 xDrip+ 信号';

  @override
  String get pageConnectNightscout => '连接 Nightscout';

  @override
  String get pageSetupSourceBody => '在 Profile 中设置数据源，以监控这个对象的 CGM、上传端和服务器状态。';

  @override
  String get pageSetUp => '设置';

  @override
  String get reportCapabilityEntries => '条目';

  @override
  String get reportCapabilityRangeQuery => '范围查询';

  @override
  String get reportCapabilityPebble => 'Pebble';

  @override
  String get reportCapabilityUploaderBattery => '上传端电量';

  @override
  String get reportCapabilityDeviceStatus => '设备状态';

  @override
  String get reportCapabilityNightscoutStatus => 'Nightscout 状态';

  @override
  String get reportCapabilityUploadLatency => '上传延迟';

  @override
  String get reportConfiguredSource => '已配置的数据源';

  @override
  String reportChecksPassed(Object passed, Object total) {
    return '$passed/$total 项通过';
  }

  @override
  String reportMeetsExpected(Object value, Object expected) {
    return '$value（达到 $expected 条预期）';
  }

  @override
  String reportObservedExpected(
      Object value, Object observed, Object expected) {
    return '$value（$observed/$expected 条预期）';
  }

  @override
  String reportGapsOver15m(Object value, Object count) {
    return '$value，$count 个间隙 >15 分钟';
  }

  @override
  String get widgetStatus => '状态';

  @override
  String get widgetStatusUnavailable => '状态不可用';

  @override
  String get widgetNoRecentStatus => '没有最新状态';

  @override
  String get widgetConnectSourceSummary =>
      '连接 Nightscout 数据源，以监控 CGM、上传端和服务器状态。';

  @override
  String get widgetOpenToRefresh => '打开 SolgoInsight 以刷新最新状态快照。';

  @override
  String get widgetStatusAvailable => '状态可用';

  @override
  String get widgetAllSystemsHealthy => '所有系统正常';

  @override
  String widgetWatchStatus(Object component) {
    return '关注 $component';
  }

  @override
  String widgetComponentIssue(Object component) {
    return '$component 异常';
  }

  @override
  String get widgetUpdatedJustNow => '刚刚更新';

  @override
  String widgetUpdatedMinutesAgo(Object minutes) {
    return '$minutes 分钟前更新';
  }

  @override
  String widgetUpdatedHoursAgo(Object hours) {
    return '$hours 小时前更新';
  }

  @override
  String widgetUpdatedDaysAgo(Object days) {
    return '$days 天前更新';
  }

  @override
  String get metricAccessToken => '访问令牌';

  @override
  String get metricApiReachable => 'API 可访问';

  @override
  String get metricCobContext => 'COB 上下文';

  @override
  String get metricCollectorContext => '采集器上下文';

  @override
  String get metricCv24h => 'CV（24小时）';

  @override
  String get metricDeviceStatus => '设备状态';

  @override
  String get metricDevicestatus => 'devicestatus';

  @override
  String get metricEntriesEndpoint => 'Entries 端点';

  @override
  String get metricFlatLinePeriods => '平直时段';

  @override
  String get metricIobCobContext => 'IOB / COB 上下文';

  @override
  String get metricIobContext => 'IOB 上下文';

  @override
  String get metricLastReadingFreshness => '最新读数新鲜度';

  @override
  String get metricLatestAapsContext => '最新 AAPS 上下文';

  @override
  String get metricLatestServerReading => '最新服务器读数';

  @override
  String get metricLocalService => '本地服务';

  @override
  String get metricLoopContext => '循环上下文';

  @override
  String get metricNightscoutEvidence => 'Nightscout 证据';

  @override
  String get metricNoReadings => '无读数';

  @override
  String get metricP95UploadLatency => 'P95 上传延迟';

  @override
  String get metricProfileTempTarget => 'Profile / 临时目标';

  @override
  String get metricProfileContext => 'Profile 上下文';

  @override
  String get metricPumpContext => '泵上下文';

  @override
  String get metricResponseTime => '响应时间';

  @override
  String get metricSensorContext => '传感器上下文';

  @override
  String get metricSensorDataFreshness => '传感器数据新鲜度';

  @override
  String get metricSensorLifetime => '传感器寿命';

  @override
  String get metricSensorCollectorContext => '传感器/采集器上下文';

  @override
  String get metricSignalContinuity => '信号连续性';

  @override
  String get metricStatusEndpoint => 'Status 端点';

  @override
  String get metricSuddenChanges24h => '突变（24小时）';

  @override
  String get metricUploaderBattery => '上传端电量';

  @override
  String get metricVersionContext => '版本上下文';

  @override
  String metricReadingsCount(Object count) {
    return '$count 条读数';
  }

  @override
  String get metricNotAvailable => '不可用';

  @override
  String get pageAapsSync => 'AAPS 同步';

  @override
  String get pagePump => '泵';

  @override
  String get pageProfile => 'Profile';

  @override
  String get pageNoAapsContext => '没有 AAPS 上下文';

  @override
  String get pageJustNow => '刚刚';

  @override
  String pageMinutesAgoShort(Object minutes) {
    return '$minutes 分钟前';
  }

  @override
  String pageHoursAgoShort(Object hours) {
    return '$hours 小时前';
  }

  @override
  String pageDaysAgoShort(Object days) {
    return '$days 天前';
  }

  @override
  String get pageOpenapsContextNotVisible => 'OpenAPS 上下文不可见。';

  @override
  String get pagePumpContextNotVisibleNightscout => 'Nightscout 中未看到泵上下文。';

  @override
  String get pageIobContextNotVisible => 'IOB 上下文不可见。';

  @override
  String get pageCobContextNotVisible => 'COB 上下文不可见。';

  @override
  String get pageProfileTempTargetNotVisible => 'Profile 或临时目标上下文不可见。';

  @override
  String get pageNightscoutApiReachableEvidence => '可访问。设备状态端点返回了证据。';

  @override
  String get pageNightscoutConfiguredEvidenceUnavailable =>
      'Nightscout 已配置，但当前证据不可用。';

  @override
  String get pageNoNightscoutTargetConfigured => '尚未配置 Nightscout 目标。';

  @override
  String get pageNoOpenapsLoopContextVisible => '采样的设备状态中没有可见的 OpenAPS 循环上下文。';

  @override
  String get pageNoRecentProfileTempTargetContext =>
      '采样响应中没有最近的 Profile 或临时目标上下文。';

  @override
  String get pagePartial => '部分可见';

  @override
  String get pageVisible => '可见';

  @override
  String get pageNoTimelineData => '没有时间线数据';

  @override
  String pageLatestTimelineLabel(Object label) {
    return '最新 $label';
  }

  @override
  String get pageNoVisibleIssueCluster => '没有可见的问题聚集';

  @override
  String pageIssueBucketsInView(Object count) {
    return '视图中有 $count 个问题时段';
  }

  @override
  String get pageOlder => '更早';

  @override
  String get pageMid => '中段';

  @override
  String get pageCurrentReadings => '当前读数';

  @override
  String get pagePossibleDirections => '可能的排查方向';

  @override
  String get pageModeReadingsQuality => '读数质量';

  @override
  String get pageModeLocalService => '本地服务';

  @override
  String get pageModeNightscoutApi => 'Nightscout API';

  @override
  String get pageModeNightscoutEvidence => 'Nightscout 证据';

  @override
  String get pageComponentCgmSensor => 'CGM 传感器';

  @override
  String get pageComponentXdrip => 'xDrip+';

  @override
  String get pageComponentNightscout => 'Nightscout';

  @override
  String get pageComponentAapsLoop => 'AAPS 循环';

  @override
  String get pageLatestSensorReadingObserved => '最新观察到的传感器读数';

  @override
  String get pageConfidenceAvailableMetrics => '基于可用指标的可信度';

  @override
  String get pageConfidenceAvailableEndpoints => '基于可用端点的可信度';

  @override
  String get pageConfidenceAvailableContext => '基于可用上下文的可信度';

  @override
  String get pageConfidenceNightscoutEvidence => '基于 Nightscout 证据的可信度';

  @override
  String pageChecksPassedShort(Object available, Object total) {
    return '$available/$total 项检查通过';
  }

  @override
  String get pageLockScreenDisabled => '锁屏状态已关闭';

  @override
  String get pageNotificationLowPriorityNote => '仅显示低优先级状态。没有声音、震动、稍后提醒或手动消除。';

  @override
  String get pageHowToPlaceWidget => '如何放置小组件';

  @override
  String get pageWidgetStepLongPress => '长按主屏幕任意空白区域';

  @override
  String get pageWidgetStepTapWidgets =>
      '点击小组件，然后滚动到 SolgoInsight Status Monitor';

  @override
  String get pageWidgetStepDragTemplate => '拖动一个状态模板到主屏幕';

  @override
  String get pageStatusDataNotReady => '状态数据尚未准备好。配置数据源后再打开 Status Monitor。';

  @override
  String pageSamplesRecorded(Object percent) {
    return '已记录 $percent% 样本';
  }

  @override
  String get pageDailySummary7Days => '每日汇总 - 7 天';

  @override
  String get pageHourlyDetail => '小时详情';

  @override
  String get pageHistoryScopeNote =>
      '历史记录限定在当前用户和数据源内。它记录 Status Monitor 刷新得到的组件快照；Unknown 表示该小时没有足够的样本数据可判断。';

  @override
  String get pageHistoryReasonRecordedSample => '已记录样本';

  @override
  String get pageHistoryReasonCarriedForward => '沿用上一状态';

  @override
  String get pageHistoryReasonNoSample => '无样本';

  @override
  String get pageHistoryReasonFuture => '未来小时';
}
