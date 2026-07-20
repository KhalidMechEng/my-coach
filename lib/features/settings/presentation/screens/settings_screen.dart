import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/l10n/app_strings.dart';
import '../../../../core/providers/locale_provider.dart';
import '../../../../core/providers/profile_provider.dart';
import '../../../../core/providers/theme_provider.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = ref.watch(l10nProvider);
    final locale = ref.watch(localeProvider);
    final profile = ref.watch(profileProvider);
    final isDark = ref.watch(isDarkModeProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.settings)),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        children: [
          _SectionLabel(l10n.name),
          _ValueTile(
            label: profile.name.isNotEmpty ? profile.name : l10n.athlete,
            actionIcon: Icons.edit_outlined,
            onTap: () => _editName(context, ref, l10n, profile.name),
          ),
          const SizedBox(height: AppSpacing.xxl),

          _SectionLabel(l10n.language),
          _OptionTile(
            label: l10n.english,
            selected: locale.languageCode == 'en',
            onTap: () => ref.read(localeProvider.notifier).setLocale(const Locale('en')),
          ),
          _OptionTile(
            label: l10n.arabic,
            selected: locale.languageCode == 'ar',
            onTap: () => ref.read(localeProvider.notifier).setLocale(const Locale('ar')),
          ),
          const SizedBox(height: AppSpacing.xxl),

          _SectionLabel(l10n.unit),
          _OptionTile(
            label: l10n.kilograms,
            selected: profile.unitPreference == 'kg',
            onTap: () => ref.read(profileProvider.notifier).setUnit('kg'),
          ),
          _OptionTile(
            label: l10n.pounds,
            selected: profile.unitPreference == 'lbs',
            onTap: () => ref.read(profileProvider.notifier).setUnit('lbs'),
          ),
          const SizedBox(height: AppSpacing.xxl),

          _SectionLabel(l10n.theme),
          _OptionTile(
            label: l10n.pick('Light', 'نهاري'),
            selected: !isDark,
            onTap: () => ref.read(isDarkModeProvider.notifier).setDark(false),
          ),
          _OptionTile(
            label: l10n.themeDark,
            selected: isDark,
            onTap: () => ref.read(isDarkModeProvider.notifier).setDark(true),
          ),
        ],
      ),
    );
  }
}

Future<void> _editName(BuildContext context, WidgetRef ref, L10n l10n, String current) async {
  final controller = TextEditingController(text: current);
  final result = await showDialog<String>(
    context: context,
    builder: (ctx) => AlertDialog(
      backgroundColor: AppColors.surface,
      title: Text(l10n.editName, style: AppTextStyles.headlineMedium),
      content: TextField(
        controller: controller,
        autofocus: true,
        textCapitalization: TextCapitalization.words,
        style: AppTextStyles.bodyLarge,
        decoration: InputDecoration(hintText: l10n.yourName),
        onSubmitted: (v) => Navigator.pop(ctx, v),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(ctx), child: Text(l10n.cancel)),
        TextButton(
          onPressed: () => Navigator.pop(ctx, controller.text),
          child: Text(l10n.save, style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.w700)),
        ),
      ],
    ),
  );
  if (result != null) {
    await ref.read(profileProvider.notifier).setName(result);
  }
}

class _ValueTile extends StatelessWidget {
  final String label;
  final IconData actionIcon;
  final VoidCallback onTap;
  const _ValueTile({required this.label, required this.actionIcon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.lg),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
            border: Border.all(color: AppColors.cardBorder, width: 1.5),
          ),
          child: Row(
            children: [
              Expanded(child: Text(label, style: AppTextStyles.bodyMedium)),
              Icon(actionIcon, color: AppColors.textSecondary, size: 20),
            ],
          ),
        ),
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String text;
  const _SectionLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm, left: 4, right: 4),
      child: Text(
        text.toUpperCase(),
        style: AppTextStyles.bodySmall.copyWith(
          color: AppColors.textTertiary,
          letterSpacing: 1.2,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _OptionTile extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;
  const _OptionTile({required this.label, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.lg),
          decoration: BoxDecoration(
            color: selected ? AppColors.primaryContainer : AppColors.surface,
            borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
            border: Border.all(
              color: selected ? AppColors.primary : AppColors.cardBorder,
              width: 1.5,
            ),
          ),
          child: Row(
            children: [
              Expanded(child: Text(label, style: AppTextStyles.bodyMedium)),
              if (selected) Icon(Icons.check_circle, color: AppColors.primary, size: 20),
            ],
          ),
        ),
      ),
    );
  }
}
