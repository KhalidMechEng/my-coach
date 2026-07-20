import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_spacing.dart';
import '../../core/constants/app_text_styles.dart';
import 'app_card.dart';

/// A compact flat stat: a big number over a quiet label. The number stays
/// neutral (`textPrimary`) by default so the teal accent keeps its meaning;
/// pass `emphasize: true` for the one value that represents a live/positive
/// signal.
class StatTile extends StatelessWidget {
  final String label;
  final String value;
  final bool emphasize;

  const StatTile({
    super.key,
    required this.label,
    required this.value,
    this.emphasize = false,
  });

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            value,
            style: AppTextStyles.numericMedium.copyWith(
              color: emphasize ? AppColors.primary : AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 2),
          Text(label, style: AppTextStyles.bodySmall),
        ],
      ),
    );
  }
}
