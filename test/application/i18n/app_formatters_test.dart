import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:smart_xdrip/application/i18n/app_formatters.dart';
import 'package:smart_xdrip/domain/time/day_period.dart';
import 'package:smart_xdrip/l10n/generated/app_localizations_en.dart';
import 'package:smart_xdrip/l10n/generated/app_localizations_zh.dart';

void main() {
  setUpAll(() async {
    await initializeDateFormatting('en');
    await initializeDateFormatting('zh');
  });

  test('formats localized short dates', () {
    final en = AppFormatters(AppLocalizationsEn());
    final zh = AppFormatters(AppLocalizationsZh());
    final date = DateTime(2026, 6, 23, 14, 30);

    expect(en.dateShort(date), contains('Jun'));
    expect(zh.dateShort(date), '6月23日');
  });

  test('formats localized relative time', () {
    final zh = AppFormatters(AppLocalizationsZh());
    final now = DateTime(2026, 6, 23, 14, 30);

    expect(
        zh.relative(now.subtract(const Duration(seconds: 20)), now: now), '刚刚');
    expect(zh.relative(now.subtract(const Duration(minutes: 5)), now: now),
        '5 分钟前');
  });

  test('formats localized relative day period', () {
    final en = AppFormatters(AppLocalizationsEn());
    final zh = AppFormatters(AppLocalizationsZh());
    final now = DateTime(2026, 6, 23, 14, 30);
    final yesterday = DateTime(2026, 6, 22, 15);

    expect(
      en.relativeDayPeriod(
        yesterday,
        DayPeriod.afternoon,
        now: now,
      ),
      'yesterday afternoon',
    );
    expect(
      zh.relativeDayPeriod(
        yesterday,
        DayPeriod.afternoon,
        now: now,
      ),
      '昨天下午',
    );
  });
}
