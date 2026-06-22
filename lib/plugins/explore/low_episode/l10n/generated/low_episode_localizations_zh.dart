// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'low_episode_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class LowEpisodeLocalizationsZh extends LowEpisodeLocalizations {
  LowEpisodeLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get pluginTitle => '低血糖事件';

  @override
  String get pluginSubtitle => '回顾低血糖事件和恢复情况。';

  @override
  String get pluginDescription => '回顾低血糖事件和恢复情况。';

  @override
  String get pluginReportTitle => '低血糖事件报告';

  @override
  String get pluginLoading => '加载中';

  @override
  String get pluginNoData => '暂无可用数据。';

  @override
  String get pluginUnavailable => '不可用';
}

/// The translations for Chinese, using the Han script (`zh_Hant`).
class LowEpisodeLocalizationsZhHant extends LowEpisodeLocalizationsZh {
  LowEpisodeLocalizationsZhHant(): super('zh_Hant');

  @override
  String get pluginTitle => '低血糖事件';

  @override
  String get pluginSubtitle => '回顧低血糖事件和恢復情況。';

  @override
  String get pluginDescription => '回顧低血糖事件和恢復情況。';

  @override
  String get pluginReportTitle => '低血糖事件報告';

  @override
  String get pluginLoading => '載入中';

  @override
  String get pluginNoData => '暫無可用資料。';

  @override
  String get pluginUnavailable => '不可用';
}
