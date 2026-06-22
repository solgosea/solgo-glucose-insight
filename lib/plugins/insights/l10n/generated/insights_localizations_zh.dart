// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'insights_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class InsightsLocalizationsZh extends InsightsLocalizations {
  InsightsLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get pluginTitle => '洞察';

  @override
  String get pluginSubtitle => '生成的回顾洞察与摘要。';

  @override
  String get pluginDescription => '生成的回顾洞察与摘要。';

  @override
  String get pluginReportTitle => '洞察报告';

  @override
  String get pluginLoading => '加载中';

  @override
  String get pluginNoData => '暂无可用数据。';

  @override
  String get pluginUnavailable => '不可用';

  @override
  String get insightsDailyBriefToday => '今日摘要';

  @override
  String get insightsSectionPatternsDetected => '已发现的模式';
}

/// The translations for Chinese, using the Han script (`zh_Hant`).
class InsightsLocalizationsZhHant extends InsightsLocalizationsZh {
  InsightsLocalizationsZhHant() : super('zh_Hant');

  @override
  String get pluginTitle => '洞察';

  @override
  String get pluginSubtitle => '產生的回顧洞察與摘要。';

  @override
  String get pluginDescription => '產生的回顧洞察與摘要。';

  @override
  String get pluginReportTitle => '洞察報告';

  @override
  String get pluginLoading => '載入中';

  @override
  String get pluginNoData => '暫無可用資料。';

  @override
  String get pluginUnavailable => '不可用';

  @override
  String get insightsDailyBriefToday => '今日摘要';

  @override
  String get insightsSectionPatternsDetected => '已發現的模式';
}
