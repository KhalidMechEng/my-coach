import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/constants/app_colors.dart';
import 'core/l10n/app_strings.dart';
import 'core/providers/locale_provider.dart';
import 'core/providers/theme_provider.dart';
import 'core/theme/app_theme.dart';
import 'routing/app_router.dart';

class MyCoachApp extends ConsumerWidget {
  const MyCoachApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);
    final locale = ref.watch(localeProvider);
    final l10n = ref.watch(l10nProvider);
    // Screens read `AppColors.*` directly, and go_router keeps the same screen
    // instances across a theme flip — so only the ThemeData would update while
    // already-built screens stayed on the old palette (white cards on a dark
    // background). Re-key the whole screen subtree on the flag so every screen
    // rebuilds and re-reads the active palette when the theme changes.
    final isDark = ref.watch(isDarkModeProvider);

    return MaterialApp.router(
      title: l10n.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.current,
      locale: locale,
      supportedLocales: const [Locale('en'), Locale('ar')],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      routerConfig: router,
      // The app is designed for phones. On wide screens (web/desktop preview)
      // constrain it to a phone-sized frame instead of stretching.
      builder: (context, child) {
        // Force a full rebuild of the screen subtree whenever the theme flips.
        final themedChild = KeyedSubtree(key: ValueKey(isDark), child: child!);
        return LayoutBuilder(
          builder: (context, constraints) {
            if (constraints.maxWidth <= 500) return themedChild;
            // Letterbox "desk" behind the phone frame — theme-aware so it isn't a
            // glaring light slab in dark mode.
            return ColoredBox(
              color: isDark ? const Color(0xFF060D13) : const Color(0xFFE7ECEF),
              child: Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(24),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 430, maxHeight: 930),
                    child: themedChild,
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
