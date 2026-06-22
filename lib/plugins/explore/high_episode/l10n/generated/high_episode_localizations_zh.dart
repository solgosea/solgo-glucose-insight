// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'high_episode_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class HighEpisodeLocalizationsZh extends HighEpisodeLocalizations {
  HighEpisodeLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get pluginTitle => '高血糖事件';

  @override
  String get pluginSubtitle => '回顾高血糖事件和模式。';

  @override
  String get pluginDescription => '回顾高血糖事件和模式。';

  @override
  String get pluginReportTitle => '高血糖事件报告';

  @override
  String get pluginLoading => '加载中';

  @override
  String get pluginNoData => '暂无可用数据。';

  @override
  String get pluginUnavailable => '不可用';
}

/// The translations for Chinese, using the Han script (`zh_Hant`).
class HighEpisodeLocalizationsZhHant extends HighEpisodeLocalizationsZh {
  HighEpisodeLocalizationsZhHant(): super('zh_Hant');

  @override
  String get pluginTitle => '高血糖事件';

  @override
  String get pluginSubtitle => '回顧高血糖事件和模式。';

  @override
  String get pluginDescription => '回顧高血糖事件和模式。';

  @override
  String get pluginReportTitle => '高血糖事件報告';

  @override
  String get pluginLoading => '載入中';

  @override
  String get pluginNoData => '暫無可用資料。';

  @override
  String get pluginUnavailable => '不可用';
}
