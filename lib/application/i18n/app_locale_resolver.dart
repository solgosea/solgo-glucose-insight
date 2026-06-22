import 'dart:ui';

class AppLocaleResolver {
  const AppLocaleResolver();

  static const supportedLocales = <Locale>[
    Locale('en'),
    Locale('zh'),
    Locale.fromSubtags(languageCode: 'zh', scriptCode: 'Hant'),
  ];

  Locale resolve(Locale? locale) {
    return resolveNullable(locale) ?? const Locale('en');
  }

  Locale? resolveNullable(Locale? locale) {
    if (locale == null) return null;
    final language = locale.languageCode.toLowerCase();
    final script = locale.scriptCode?.toLowerCase();
    final country = locale.countryCode?.toLowerCase();
    if (language == 'en') {
      return const Locale('en');
    }
    if (language == 'zh') {
      if (script == 'hant' ||
          country == 'tw' ||
          country == 'hk' ||
          country == 'mo') {
        return const Locale.fromSubtags(
          languageCode: 'zh',
          scriptCode: 'Hant',
        );
      }
      return const Locale('zh');
    }
    return const Locale('en');
  }

  Locale? fromLanguageTag(String? tag) {
    final normalized = normalizeLanguageTag(tag);
    if (normalized == null) return null;
    final parts = normalized.split('-');
    if (parts.isEmpty || parts.first.isEmpty) return null;
    String? scriptCode;
    String? countryCode;
    for (final part in parts.skip(1)) {
      if (part == 'hans' || part == 'hant') {
        scriptCode = part[0].toUpperCase() + part.substring(1);
      } else if (part.length == 2) {
        countryCode = part.toUpperCase();
      }
    }
    return Locale.fromSubtags(
      languageCode: parts.first,
      scriptCode: scriptCode,
      countryCode: countryCode,
    );
  }

  String? normalizeLanguageTag(String? raw) {
    final text = raw?.trim();
    if (text == null || text.isEmpty) return null;
    return text.replaceAll('_', '-').toLowerCase();
  }
}
