import 'dart:ui';

enum AppLocaleOption {
  system,
  english,
  simplifiedChinese,
  traditionalChinese;

  Locale? get locale {
    return switch (this) {
      AppLocaleOption.system => null,
      AppLocaleOption.english => const Locale('en'),
      AppLocaleOption.simplifiedChinese => const Locale('zh'),
      AppLocaleOption.traditionalChinese => const Locale.fromSubtags(
          languageCode: 'zh',
          scriptCode: 'Hant',
        ),
    };
  }
}
