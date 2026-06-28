// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'datasource_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class DatasourceLocalizationsZh extends DatasourceLocalizations {
  DatasourceLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get pluginTitle => '数据源';

  @override
  String get pluginSubtitle => '配置 xDrip+ Local 和 Nightscout 数据源。';

  @override
  String get pluginDescription => '配置 xDrip+ Local 和 Nightscout 数据源。';

  @override
  String get pluginReportTitle => '数据源报告';

  @override
  String get pluginLoading => '加载中';

  @override
  String get pluginNoData => '暂无可用数据。';

  @override
  String get pluginUnavailable => '不可用';

  @override
  String get nightscoutUpdateConnection => '更新连接';

  @override
  String get nightscoutApiTitle => 'Nightscout API';

  @override
  String get nightscoutUpdateSubtitle => '在下方更新站点 URL 或访问令牌。';

  @override
  String get nightscoutSetupSubtitle => '输入你的 Nightscout 站点 URL，可选填写访问令牌。';

  @override
  String get nightscoutSiteUrl => '站点 URL';

  @override
  String get nightscoutUrlHint => 'https://your-site.herokuapp.com';

  @override
  String get nightscoutAccessToken => '访问令牌';

  @override
  String get nightscoutOptional => '可选';

  @override
  String get nightscoutTesting => '正在测试...';

  @override
  String get nightscoutTestAndConnect => '测试并连接';

  @override
  String get nightscoutEnterUrl => '请输入 Nightscout URL 后继续';

  @override
  String get nightscoutTestingConnection => '正在测试连接...';

  @override
  String get nightscoutConnectedSyncing => '已连接，正在同步';
}

/// The translations for Chinese, using the Han script (`zh_Hant`).
class DatasourceLocalizationsZhHant extends DatasourceLocalizationsZh {
  DatasourceLocalizationsZhHant() : super('zh_Hant');

  @override
  String get pluginTitle => '資料來源';

  @override
  String get pluginSubtitle => '設定 xDrip+ Local 和 Nightscout 資料來源。';

  @override
  String get pluginDescription => '設定 xDrip+ Local 和 Nightscout 資料來源。';

  @override
  String get pluginReportTitle => '資料來源報告';

  @override
  String get pluginLoading => '載入中';

  @override
  String get pluginNoData => '暫無可用資料。';

  @override
  String get pluginUnavailable => '不可用';

  @override
  String get nightscoutUpdateConnection => '更新連線';

  @override
  String get nightscoutApiTitle => 'Nightscout API';

  @override
  String get nightscoutUpdateSubtitle => '在下方更新站點 URL 或存取權杖。';

  @override
  String get nightscoutSetupSubtitle => '輸入你的 Nightscout 站點 URL，可選填寫存取權杖。';

  @override
  String get nightscoutSiteUrl => '站點 URL';

  @override
  String get nightscoutUrlHint => 'https://your-site.herokuapp.com';

  @override
  String get nightscoutAccessToken => '存取權杖';

  @override
  String get nightscoutOptional => '可選';

  @override
  String get nightscoutTesting => '正在測試...';

  @override
  String get nightscoutTestAndConnect => '測試並連線';

  @override
  String get nightscoutEnterUrl => '請輸入 Nightscout URL 後繼續';

  @override
  String get nightscoutTestingConnection => '正在測試連線...';

  @override
  String get nightscoutConnectedSyncing => '已連線，正在同步';
}
