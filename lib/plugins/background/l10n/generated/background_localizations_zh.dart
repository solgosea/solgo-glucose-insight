// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'background_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class BackgroundLocalizationsZh extends BackgroundLocalizations {
  BackgroundLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get glucoseSyncSubtitle => '同步当前血糖数据源';

  @override
  String get sourceHealthSubtitle => '验证当前数据源可用性';

  @override
  String get sourceHealthTitle => '数据源健康检查';

  @override
  String get glucoseSyncTitle => '血糖同步';

  @override
  String get glucoseSyncDescription => '从当前数据源同步血糖读数。';

  @override
  String get sourceHealthDescription => '检查当前 xDrip 或 Nightscout 数据源是否可访问。';

  @override
  String get pluginUnavailable => '不可用';

  @override
  String get pluginReportTitle => '后台报告';

  @override
  String get pluginSubtitle => '后台血糖同步和数据源健康任务。';

  @override
  String get pluginTitle => '后台任务';

  @override
  String get pluginDescription => '后台血糖同步和数据源健康任务。';

  @override
  String get pluginNoData => '暂无可用数据。';

  @override
  String get pluginLoading => '加载中';
}

/// The translations for Chinese, using the Han script (`zh_Hant`).
class BackgroundLocalizationsZhHant extends BackgroundLocalizationsZh {
  BackgroundLocalizationsZhHant(): super('zh_Hant');

  @override
  String get glucoseSyncSubtitle => '同步目前血糖資料來源';

  @override
  String get sourceHealthSubtitle => '驗證目前資料來源可用性';

  @override
  String get sourceHealthTitle => '資料來源健康檢查';

  @override
  String get glucoseSyncTitle => '血糖同步';

  @override
  String get glucoseSyncDescription => '從目前資料來源同步血糖讀數。';

  @override
  String get sourceHealthDescription => '檢查目前 xDrip 或 Nightscout 資料來源是否可存取。';

  @override
  String get pluginUnavailable => '不可用';

  @override
  String get pluginReportTitle => '背景報告';

  @override
  String get pluginSubtitle => '背景血糖同步和資料來源健康工作。';

  @override
  String get pluginTitle => '背景工作';

  @override
  String get pluginDescription => '背景血糖同步和資料來源健康工作。';

  @override
  String get pluginNoData => '暫無可用資料。';

  @override
  String get pluginLoading => '載入中';
}
