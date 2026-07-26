import 'package:flutter/material.dart';
import 'l10n.dart';

/// Locale Manager provider helper.
class LocaleManager extends ChangeNotifier {
  Locale _locale = const Locale('en', 'US');

  Locale get locale => _locale;

  void setLocale(Locale locale) {
    if (!L10n.all.contains(locale)) return;
    _locale = locale;
    notifyListeners();
  }
}
