import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_xdrip/application/i18n/app_locale_controller.dart';
import 'package:smart_xdrip/application/i18n/app_locale_resolver.dart';
import 'package:smart_xdrip/application/i18n/app_locale_store.dart';

void main() {
  group('AppLocaleResolver', () {
    const resolver = AppLocaleResolver();

    test('normalizes supported locales', () {
      expect(resolver.resolve(const Locale('en')), const Locale('en'));
      expect(resolver.resolve(const Locale('zh')), const Locale('zh'));
      expect(
        resolver.resolve(const Locale('zh', 'TW')),
        const Locale.fromSubtags(languageCode: 'zh', scriptCode: 'Hant'),
      );
      expect(
        resolver.resolve(
          const Locale.fromSubtags(languageCode: 'zh', scriptCode: 'Hant'),
        ),
        const Locale.fromSubtags(languageCode: 'zh', scriptCode: 'Hant'),
      );
      expect(resolver.resolve(const Locale('fr')), const Locale('en'));
    });

    test('parses language tags', () {
      expect(resolver.fromLanguageTag('zh-Hant')?.scriptCode, 'Hant');
      expect(resolver.fromLanguageTag('zh_CN')?.languageCode, 'zh');
      expect(resolver.normalizeLanguageTag(' zh_Hant '), 'zh-hant');
    });
  });

  group('AppLocaleController', () {
    test('loads and persists selected locale', () async {
      SharedPreferences.setMockInitialValues({});
      final store = AppLocaleStore();
      final controller = AppLocaleController(store);

      await controller.load();
      expect(controller.ready, isTrue);
      expect(controller.locale, isNull);

      await controller.setLocale(
        const Locale.fromSubtags(languageCode: 'zh', scriptCode: 'Hant'),
      );
      expect(controller.locale?.languageCode, 'zh');
      expect(controller.locale?.scriptCode, 'Hant');

      final restored = AppLocaleController(AppLocaleStore());
      await restored.load();
      expect(restored.locale?.languageCode, 'zh');
      expect(restored.locale?.scriptCode, 'Hant');

      await restored.useSystemLocale();
      expect(restored.locale, isNull);
    });
  });
}
