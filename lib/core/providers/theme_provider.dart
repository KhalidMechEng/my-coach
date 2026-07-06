import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../constants/app_colors.dart';
import '../services/local_store.dart';

const _themeKey = 'theme_mode';

/// Persists the light/dark choice and flips [AppColors.isDark] so the whole
/// palette re-skins on the next rebuild (MaterialApp watches this provider).
class ThemeModeNotifier extends StateNotifier<bool> {
  final LocalStore _store;

  ThemeModeNotifier(this._store) : super(false) {
    final saved = _store.getString(_themeKey);
    state = saved == 'dark';
    AppColors.isDark = state;
  }

  Future<void> setDark(bool dark) async {
    AppColors.isDark = dark;
    state = dark;
    await _store.setString(_themeKey, dark ? 'dark' : 'light');
  }

  Future<void> toggle() => setDark(!state);
}

/// true = dark mode.
final isDarkModeProvider = StateNotifierProvider<ThemeModeNotifier, bool>(
  (ref) => ThemeModeNotifier(ref.watch(localStoreProvider)),
);
