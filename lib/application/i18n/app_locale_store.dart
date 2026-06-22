import 'dart:ui';

import 'package:shared_preferences/shared_preferences.dart';

import 'app_locale_resolver.dart';

class AppLocaleStore {
  AppLocaleStore({
    AppLocaleResolver resolver = const AppLocaleResolver(),
  }) : _resolver = resolver;

  static const prefKey = 'app.locale.language_tag';

  final AppLocaleResolver _resolver;

  String? _savedLanguageTag;
  bool _loaded = false;

  Future<void> load() async {
    if (_loaded) return;
    final prefs = await SharedPreferences.getInstance();
    _savedLanguageTag = _resolver.normalizeLanguageTag(
      prefs.getString(prefKey),
    );
    _loaded = true;
  }

  Future<void> save(Locale? locale) async {
    final prefs = await SharedPreferences.getInstance();
    if (locale == null) {
      _savedLanguageTag = null;
      await prefs.remove(prefKey);
      return;
    }
    final resolved = _resolver.resolve(locale);
    final tag = _resolver.normalizeLanguageTag(resolved.toLanguageTag());
    _savedLanguageTag = tag;
    if (tag == null) {
      await prefs.remove(prefKey);
      return;
    }
    await prefs.setString(prefKey, tag);
  }

  Locale? preferredLocaleSync() {
    return _resolver
        .resolveNullable(_resolver.fromLanguageTag(_savedLanguageTag));
  }

  String currentLanguageTagSync() {
    final saved = _resolver.normalizeLanguageTag(_savedLanguageTag);
    if (saved != null) return saved;
    return _resolver.normalizeLanguageTag(
          PlatformDispatcher.instance.locale.toLanguageTag(),
        ) ??
        'en';
  }
}
