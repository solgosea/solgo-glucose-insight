// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'explore_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class ExploreLocalizationsZh extends ExploreLocalizations {
  ExploreLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get pluginTitle => '探索';

  @override
  String get pluginSubtitle => '用专项工具回顾血糖模式。';

  @override
  String get pluginDescription => '用专项工具回顾血糖模式。';

  @override
  String get pluginReportTitle => '探索报告';

  @override
  String get pluginLoading => '加载中';

  @override
  String get pluginNoData => '暂无可用数据。';

  @override
  String get pluginUnavailable => '不可用';

  @override
  String get featuredPlugins => '精选插件';

  @override
  String get featuredReportEyebrow => '报告';

  @override
  String get featuredReportBadge => '免费';

  @override
  String get featuredReportTitle => '适合医生查看的血糖报告';

  @override
  String get featuredReportBody => 'AGP 标准 PDF，几秒内导出和分享。';

  @override
  String get runtimeNoData => '无数据';

  @override
  String get runtimeNoSource => '无数据源';

  @override
  String get runtimeDisabled => '已停用';

  @override
  String get runtimeHidden => '已隐藏';

  @override
  String get runtimeUnavailable => '不可用';

  @override
  String get sectionLabs => '实验室';

  @override
  String get sectionTimePatterns => '时间模式';

  @override
  String get sectionGlucoseProfile => '血糖画像';

  @override
  String get sectionEpisodes => '事件回顾';

  @override
  String get sectionConnectedCare => '远程关注';

  @override
  String get sectionSystemStatus => '系统状态';
}

/// The translations for Chinese, using the Han script (`zh_Hant`).
class ExploreLocalizationsZhHant extends ExploreLocalizationsZh {
  ExploreLocalizationsZhHant(): super('zh_Hant');

  @override
  String get pluginTitle => '探索';

  @override
  String get pluginSubtitle => '用專項工具回顧血糖模式。';

  @override
  String get pluginDescription => '用專項工具回顧血糖模式。';

  @override
  String get pluginReportTitle => '探索報告';

  @override
  String get pluginLoading => '載入中';

  @override
  String get pluginNoData => '暫無可用資料。';

  @override
  String get pluginUnavailable => '不可用';

  @override
  String get featuredPlugins => '精選插件';

  @override
  String get featuredReportEyebrow => '報告';

  @override
  String get featuredReportBadge => '免費';

  @override
  String get featuredReportTitle => '適合醫師查看的血糖報告';

  @override
  String get featuredReportBody => 'AGP 標準 PDF，幾秒內匯出和分享。';

  @override
  String get runtimeNoData => '無資料';

  @override
  String get runtimeNoSource => '無資料來源';

  @override
  String get runtimeDisabled => '已停用';

  @override
  String get runtimeHidden => '已隱藏';

  @override
  String get runtimeUnavailable => '不可用';

  @override
  String get sectionLabs => '實驗室';

  @override
  String get sectionTimePatterns => '時間模式';

  @override
  String get sectionGlucoseProfile => '血糖画像';

  @override
  String get sectionEpisodes => '事件回顧';

  @override
  String get sectionConnectedCare => '遠端關注';

  @override
  String get sectionSystemStatus => '系統狀態';
}
