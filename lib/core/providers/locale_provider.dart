import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/local_store.dart';

const _localeKey = 'app_locale';

/// Holds the app's current locale (English or Arabic) and persists the choice.
class LocaleNotifier extends StateNotifier<Locale> {
  final LocalStore _store;

  LocaleNotifier(this._store) : super(const Locale('en')) {
    final saved = _store.getString(_localeKey);
    if (saved == 'ar' || saved == 'en') {
      state = Locale(saved!);
    }
  }

  bool get isArabic => state.languageCode == 'ar';

  Future<void> setLocale(Locale locale) async {
    state = locale;
    await _store.setString(_localeKey, locale.languageCode);
  }

  Future<void> toggle() =>
      setLocale(isArabic ? const Locale('en') : const Locale('ar'));
}

final localeProvider = StateNotifierProvider<LocaleNotifier, Locale>(
  (ref) => LocaleNotifier(ref.watch(localStoreProvider)),
);

/// Convenience: true when the UI language is Arabic.
final isArabicProvider = Provider<bool>(
  (ref) => ref.watch(localeProvider).languageCode == 'ar',
);
