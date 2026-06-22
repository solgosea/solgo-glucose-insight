import 'dart:ui';

import 'package:flutter/foundation.dart';

import 'app_locale_store.dart';

class AppLocaleController extends ChangeNotifier {
  AppLocaleController(this._store);

  final AppLocaleStore _store;

  Locale? _locale;
  bool _ready = false;

  Locale? get locale => _locale;
  bool get ready => _ready;

  Future<void> load() async {
    if (_ready) return;
    await _store.load();
    _locale = _store.preferredLocaleSync();
    _ready = true;
    notifyListeners();
  }

  Future<void> useSystemLocale() async {
    await _store.save(null);
    _locale = null;
    notifyListeners();
  }

  Future<void> setLocale(Locale locale) async {
    await _store.save(locale);
    _locale = _store.preferredLocaleSync();
    notifyListeners();
  }

  Future<void> ensureLoaded() => _ready ? Future.value() : load();
}
