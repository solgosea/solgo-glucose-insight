// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'glance_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class GlanceLocalizationsZh extends GlanceLocalizations {
  GlanceLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get pluginTitle => '组件与通知';

  @override
  String get pluginSubtitle => '桌面组件、通知和悬浮 Glance。';

  @override
  String get pluginDescription => '桌面组件、通知和悬浮 Glance。';

  @override
  String get pluginReportTitle => '组件与通知报告';

  @override
  String get pluginLoading => '加载中';

  @override
  String get pluginNoData => '暂无可用数据。';

  @override
  String get pluginUnavailable => '不可用';

  @override
  String get glancePrivacySection => '隐私';

  @override
  String get glanceLowBatterySubtitle => '降低刷新频率以节省电量';

  @override
  String get glanceLockScreenModeTitle => '锁屏 Glance';

  @override
  String get glanceHubTitle => '小组件与通知';

  @override
  String get floatingUnavailableAction => '不可用';

  @override
  String get floatingVisibleBody => '可以拖到任意位置。点击浮窗可返回应用。';

  @override
  String get glanceGraphExpandedSubtitle => '在展开通知中显示小趋势图';

  @override
  String get glanceWidgetTemplatesSection => '小组件模板';

  @override
  String get glanceShowNotificationTitle => '显示在通知栏';

  @override
  String get glancePersistentNotificationSection => '常驻通知';

  @override
  String get glanceIosWidgetGuide =>
      '请从 iOS 小组件选择器添加 SolgoInsight Glance。主屏幕和锁屏小组件会使用最近共享的 Glance 快照更新。';

  @override
  String get glanceNotificationSettingsSection => '通知设置';

  @override
  String get glanceLockScreenModeSubtitle => '选择完整数值、仅范围或隐私模式';

  @override
  String get glanceAndroidWidgetGuide =>
      'Android 不允许应用替你直接放置小组件。这是系统操作，不同手机品牌的步骤可能略有差异。';

  @override
  String get glanceLockScreenGlanceTitle => '锁屏 Glance';

  @override
  String get floatingVisibleTitle => 'Floating Glance 正在显示';

  @override
  String get glanceTabNotifications => '通知';

  @override
  String get floatingUnavailableTitle => 'Floating Glance 不可用';

  @override
  String get floatingPermissionNeededBody => '请先允许在其他应用上层显示。Android 授权后返回这里。';

  @override
  String get glanceNotificationPrivacySection => '通知隐私';

  @override
  String get floatingPermissionNeededTitle => '需要浮窗权限';

  @override
  String get glancePrivateModeTitle => '隐私模式文字';

  @override
  String get floatingPermissionGrantedBody => '点一下即可把 Floating Glance 显示到屏幕上。';

  @override
  String get floatingHiddenTitle => 'Floating Glance 已隐藏';

  @override
  String get glanceFloatingSection => '浮动 Glance';

  @override
  String get glanceFloatingCardTitle => 'Floating Glance';

  @override
  String get glanceFloatingCardBody =>
      '允许 SolgoInsight 在其他应用上方显示血糖状态。它保持静音，只同步 Glance 状态。';

  @override
  String get glanceFloatingVisiblePill => '显示中';

  @override
  String get glanceFloatingSetupPill => '设置';

  @override
  String get glanceFloatingSizeTitle => 'Floating Glance 尺寸';

  @override
  String get glanceFloatingSizeAuto => '自动';

  @override
  String get glanceFloatingSizeSmall => '小';

  @override
  String get glanceFloatingSizeMedium => '中';

  @override
  String get glanceFloatingSizeLarge => '大';

  @override
  String get glanceFloatingShapeTitle => '形态';

  @override
  String get glanceFloatingShapePill => '胶囊';

  @override
  String get glanceFloatingShapeCard => '卡片';

  @override
  String glanceFloatingRecommendedPreset(String size, String shape) {
    return '此设备推荐：$size$shape';
  }

  @override
  String get glanceFloatingCustomPreset => '自定义尺寸。你的选择不会被自动更改。';

  @override
  String get floatingUnavailableBody => '此设备未提供 Android 浮窗服务。';

  @override
  String get glanceHomeScreenWidgetSubtitle => '小号和中号小组件使用最新的 Glance 快照';

  @override
  String get glanceAddHomeScreenSection => '添加到主屏幕';

  @override
  String get glanceShowNotificationSubtitle => '常驻血糖状态，静音且低优先级';

  @override
  String get floatingShowAction => '显示 Floating Glance';

  @override
  String get floatingHiddenBody => '权限已准备好。需要屏幕浮窗时可以再次显示。';

  @override
  String get glanceHomeScreenWidgetTitle => '主屏幕小组件';

  @override
  String get glanceLockAodSection => '锁屏与 AOD';

  @override
  String get glanceGraphExpandedTitle => '展开视图中的曲线';

  @override
  String get glanceLockScreenGlanceSubtitle =>
      'iOS 16+ 的辅助小组件。AOD 行为遵循 iOS 系统。';

  @override
  String get glanceAodFriendlySection => 'AOD 友好';

  @override
  String get glanceLowBatteryTitle => '低耗电模式';

  @override
  String get floatingHideAction => '隐藏 Floating Glance';

  @override
  String get floatingPermissionGrantedTitle => 'Floating Glance 权限已授予';

  @override
  String get floatingPermissionNeededAction => '启用浮窗权限';

  @override
  String get glanceQuickActionsTitle => '快捷操作';

  @override
  String get glanceTabWidgets => '小组件';

  @override
  String get glanceHomeLockWidgetsSection => '主屏幕与锁屏小组件';

  @override
  String get glancePrivateModeSubtitle => '血糖数据可用 - 解锁后查看';

  @override
  String get glanceQuickActionsSubtitle => '打开应用、数据源和设置';

  @override
  String get glanceNotificationPreviewDataSource => '数据源';

  @override
  String glanceFloatingPreviewSourceUpdated(String freshness, String source) {
    return '来源 $source - 更新于 $freshness';
  }

  @override
  String get glanceWidgetGraphRange => '图表范围';

  @override
  String get glanceWidgetLastUpdated => '最后更新';

  @override
  String get glanceNotificationPreviewOpen => '打开';

  @override
  String get glanceWidgetShowOnWidget => '小组件显示内容';

  @override
  String get glanceWidgetMiniGraph => '迷你图表';

  @override
  String get glanceNotificationPreviewFlat => '平稳';

  @override
  String get glanceNotificationPreviewSettings => '设置';

  @override
  String get glanceWidgetTrendArrow => '趋势箭头';

  @override
  String get glanceNotificationPreviewTir24h => '24 小时 TIR';

  @override
  String get glanceNotificationPreviewSource => '来源';

  @override
  String get glanceWidgetAddWidget => '添加小组件';

  @override
  String get glanceNotificationPreviewTrend => '趋势';

  @override
  String get glanceWidgetDelta => '变化值';

  @override
  String get glanceFloatingPreviewWindow => '窗口';

  @override
  String get glanceWidgetTapAction => '点击动作';

  @override
  String get glanceFloatingPreviewCompact => '紧凑';

  @override
  String get glanceFloatingPreviewExpanded => '展开';

  @override
  String get glancePrivateUnlockToView => '解锁查看当前血糖';

  @override
  String get glancePrivateDataAvailable => '血糖数据可用';

  @override
  String glanceFloatingPreviewUpdated(String freshness) {
    return '更新于 $freshness';
  }

  @override
  String get glanceNotificationGlucoseDataAvailable => '血糖数据可用';

  @override
  String get glanceNotificationSourceOffline => '数据源离线';

  @override
  String get glanceNotificationGlucoseStale => '血糖数据已过期';

  @override
  String get glanceNotificationHidden => '速览已隐藏';

  @override
  String get glanceNotificationHiddenOnLockScreen => '锁屏速览已隐藏';

  @override
  String get glanceNotificationUnlockCurrentGlucose => '解锁后查看当前血糖';

  @override
  String get glanceNotificationNoRecentGlucoseData => '暂无近期血糖数据';

  @override
  String get glanceNotificationRangeHigh => '偏高';

  @override
  String get glanceNotificationRangeLow => '偏低';

  @override
  String get glanceNotificationRangeInRange => '目标范围内';

  @override
  String get glanceNotificationStatusAvailable => '血糖状态可用';

  @override
  String get glanceNotificationChannelTitle => '速览状态';

  @override
  String get glanceNotificationChannelDescription => '锁屏血糖状态，无提示音和振动。';
}

/// The translations for Chinese, using the Han script (`zh_Hant`).
class GlanceLocalizationsZhHant extends GlanceLocalizationsZh {
  GlanceLocalizationsZhHant() : super('zh_Hant');

  @override
  String get pluginTitle => '元件與通知';

  @override
  String get pluginSubtitle => '桌面元件、通知和懸浮 Glance。';

  @override
  String get pluginDescription => '桌面元件、通知和懸浮 Glance。';

  @override
  String get pluginReportTitle => '元件與通知報告';

  @override
  String get pluginLoading => '載入中';

  @override
  String get pluginNoData => '暫無可用資料。';

  @override
  String get pluginUnavailable => '不可用';

  @override
  String get glancePrivacySection => '隱私';

  @override
  String get glanceLowBatterySubtitle => '降低刷新頻率以節省電量';

  @override
  String get glanceLockScreenModeTitle => '鎖定畫面 Glance';

  @override
  String get glanceHubTitle => '小工具與通知';

  @override
  String get floatingUnavailableAction => '不可用';

  @override
  String get floatingVisibleBody => '可以拖到任意位置。點擊浮窗可返回應用程式。';

  @override
  String get glanceGraphExpandedSubtitle => '在展開通知中顯示小趨勢圖';

  @override
  String get glanceWidgetTemplatesSection => '小工具範本';

  @override
  String get glanceShowNotificationTitle => '顯示在通知列';

  @override
  String get glancePersistentNotificationSection => '常駐通知';

  @override
  String get glanceIosWidgetGuide =>
      '請從 iOS 小工具選擇器加入 SolgoInsight Glance。主畫面和鎖定畫面小工具會使用最近共享的 Glance 快照更新。';

  @override
  String get glanceNotificationSettingsSection => '通知設定';

  @override
  String get glanceLockScreenModeSubtitle => '選擇完整數值、僅範圍或隱私模式';

  @override
  String get glanceAndroidWidgetGuide =>
      'Android 不允許應用程式替你直接放置小工具。這是系統操作，不同手機品牌的步驟可能略有差異。';

  @override
  String get glanceLockScreenGlanceTitle => '鎖定畫面 Glance';

  @override
  String get floatingVisibleTitle => 'Floating Glance 正在顯示';

  @override
  String get glanceTabNotifications => '通知';

  @override
  String get floatingUnavailableTitle => 'Floating Glance 不可用';

  @override
  String get floatingPermissionNeededBody => '請先允許在其他應用程式上層顯示。Android 授權後返回這裡。';

  @override
  String get glanceNotificationPrivacySection => '通知隱私';

  @override
  String get floatingPermissionNeededTitle => '需要浮窗權限';

  @override
  String get glancePrivateModeTitle => '隱私模式文字';

  @override
  String get floatingPermissionGrantedBody => '點一下即可把 Floating Glance 顯示到螢幕上。';

  @override
  String get floatingHiddenTitle => 'Floating Glance 已隱藏';

  @override
  String get glanceFloatingSection => '浮動 Glance';

  @override
  String get glanceFloatingCardTitle => 'Floating Glance';

  @override
  String get glanceFloatingCardBody =>
      '允許 SolgoInsight 在其他應用上方顯示血糖狀態。它保持靜音，只同步 Glance 狀態。';

  @override
  String get glanceFloatingVisiblePill => '顯示中';

  @override
  String get glanceFloatingSetupPill => '設定';

  @override
  String get glanceFloatingSizeTitle => 'Floating Glance 尺寸';

  @override
  String get glanceFloatingSizeAuto => '自動';

  @override
  String get glanceFloatingSizeSmall => '小';

  @override
  String get glanceFloatingSizeMedium => '中';

  @override
  String get glanceFloatingSizeLarge => '大';

  @override
  String get glanceFloatingShapeTitle => '形態';

  @override
  String get glanceFloatingShapePill => '膠囊';

  @override
  String get glanceFloatingShapeCard => '卡片';

  @override
  String glanceFloatingRecommendedPreset(String size, String shape) {
    return '此裝置推薦：$size$shape';
  }

  @override
  String get glanceFloatingCustomPreset => '自訂尺寸。你的選擇不會被自動更改。';

  @override
  String get floatingUnavailableBody => '此裝置未提供 Android 浮窗服務。';

  @override
  String get glanceHomeScreenWidgetSubtitle => '小型和中型小工具使用最新的 Glance 快照';

  @override
  String get glanceAddHomeScreenSection => '加入主畫面';

  @override
  String get glanceShowNotificationSubtitle => '常駐血糖狀態，靜音且低優先級';

  @override
  String get floatingShowAction => '顯示 Floating Glance';

  @override
  String get floatingHiddenBody => '權限已準備好。需要螢幕浮窗時可以再次顯示。';

  @override
  String get glanceHomeScreenWidgetTitle => '主畫面小工具';

  @override
  String get glanceLockAodSection => '鎖定畫面與 AOD';

  @override
  String get glanceGraphExpandedTitle => '展開檢視中的曲線';

  @override
  String get glanceLockScreenGlanceSubtitle =>
      'iOS 16+ 的輔助小工具。AOD 行為遵循 iOS 系統。';

  @override
  String get glanceAodFriendlySection => 'AOD 友善';

  @override
  String get glanceLowBatteryTitle => '低耗電模式';

  @override
  String get floatingHideAction => '隱藏 Floating Glance';

  @override
  String get floatingPermissionGrantedTitle => 'Floating Glance 權限已授予';

  @override
  String get floatingPermissionNeededAction => '啟用浮窗權限';

  @override
  String get glanceQuickActionsTitle => '快捷操作';

  @override
  String get glanceTabWidgets => '小工具';

  @override
  String get glanceHomeLockWidgetsSection => '主畫面與鎖定畫面小工具';

  @override
  String get glancePrivateModeSubtitle => '血糖資料可用 - 解鎖後查看';

  @override
  String get glanceQuickActionsSubtitle => '開啟應用程式、資料來源和設定';

  @override
  String get glanceNotificationPreviewDataSource => '数据源';

  @override
  String glanceFloatingPreviewSourceUpdated(String freshness, String source) {
    return '来源 $source - 更新于 $freshness';
  }

  @override
  String get glanceWidgetGraphRange => '图表范围';

  @override
  String get glanceWidgetLastUpdated => '最后更新';

  @override
  String get glanceNotificationPreviewOpen => '打开';

  @override
  String get glanceWidgetShowOnWidget => '小组件显示内容';

  @override
  String get glanceWidgetMiniGraph => '迷你图表';

  @override
  String get glanceNotificationPreviewFlat => '平稳';

  @override
  String get glanceNotificationPreviewSettings => '设置';

  @override
  String get glanceWidgetTrendArrow => '趋势箭头';

  @override
  String get glanceNotificationPreviewTir24h => '24 小时 TIR';

  @override
  String get glanceNotificationPreviewSource => '来源';

  @override
  String get glanceWidgetAddWidget => '添加小组件';

  @override
  String get glanceNotificationPreviewTrend => '趋势';

  @override
  String get glanceWidgetDelta => '变化值';

  @override
  String get glanceFloatingPreviewWindow => '窗口';

  @override
  String get glanceWidgetTapAction => '点击动作';

  @override
  String get glanceFloatingPreviewCompact => '紧凑';

  @override
  String get glanceFloatingPreviewExpanded => '展开';

  @override
  String get glancePrivateUnlockToView => '解锁查看当前血糖';

  @override
  String get glancePrivateDataAvailable => '血糖数据可用';

  @override
  String glanceFloatingPreviewUpdated(String freshness) {
    return '更新于 $freshness';
  }

  @override
  String get glanceNotificationGlucoseDataAvailable => '血糖数据可用';

  @override
  String get glanceNotificationSourceOffline => '数据源离线';

  @override
  String get glanceNotificationGlucoseStale => '血糖数据已过期';

  @override
  String get glanceNotificationHidden => '速览已隐藏';

  @override
  String get glanceNotificationHiddenOnLockScreen => '锁屏速览已隐藏';

  @override
  String get glanceNotificationUnlockCurrentGlucose => '解锁后查看当前血糖';

  @override
  String get glanceNotificationNoRecentGlucoseData => '暂无近期血糖数据';

  @override
  String get glanceNotificationRangeHigh => '偏高';

  @override
  String get glanceNotificationRangeLow => '偏低';

  @override
  String get glanceNotificationRangeInRange => '目标范围内';

  @override
  String get glanceNotificationStatusAvailable => '血糖状态可用';

  @override
  String get glanceNotificationChannelTitle => '速览状态';

  @override
  String get glanceNotificationChannelDescription => '锁屏血糖状态，无提示音和振动。';
}
