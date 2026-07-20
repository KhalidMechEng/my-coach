import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/l10n/app_strings.dart';
import '../../domain/models/programme_block.dart';
import '../providers/programme_provider.dart';

class ProgrammeOverviewScreen extends ConsumerWidget {
  const ProgrammeOverviewScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final blocks = ref.watch(programmeProvider);
    final currentBlock = ref.watch(currentBlockProvider);
    final currentWeek = ref.watch(currentWeekProvider);
    final l10n = ref.watch(l10nProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.programme),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: AppSpacing.lg),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.primaryContainer,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                '${l10n.pick('W', 'أ')}$currentWeek · ${l10n.pick('B', 'م')}${currentBlock.blockNumber}',
                style: TextStyle(color: AppColors.primary, fontSize: 12, fontWeight: FontWeight.w700),
              ),
            ),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        children: [
          Text(l10n.pick('Upper / Lower · 4-Day Split', 'تقسيمة علوي / سفلي · 4 أيام'), style: AppTextStyles.headlineLarge),
          const SizedBox(height: AppSpacing.sm),
          Text(
            l10n.pick('Upper A · Lower A · Upper B · Lower B  |  Mon · Tue · Thu · Fri',
                'علوي أ · سفلي أ · علوي ب · سفلي ب  |  الإثنين · الثلاثاء · الخميس · الجمعة'),
            style: AppTextStyles.bodySmall,
          ),
          const SizedBox(height: AppSpacing.xxl),
          ...blocks.map((block) => _BlockCard(
                block: block,
                isCurrent: block.blockNumber == currentBlock.blockNumber,
                currentWeek: currentWeek,
                l10n: l10n,
                onWeekTap: (week) => context.push('/programme/week/$week'),
              )),
        ],
      ),
    );
  }
}

class _BlockCard extends StatelessWidget {
  final ProgrammeBlock block;
  final bool isCurrent;
  final int currentWeek;
  final L10n l10n;
  final void Function(int week) onWeekTap;

  const _BlockCard({
    required this.block,
    required this.isCurrent,
    required this.currentWeek,
    required this.l10n,
    required this.onWeekTap,
  });

  static const _sessionColors = AppColors.muscleGroup;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.lg),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
          border: Border.all(
            color: isCurrent ? AppColors.primary : AppColors.cardBorder,
            width: isCurrent ? 2 : 1,
          ),
          boxShadow: AppColors.cardShadow,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              '${l10n.block} ${block.blockNumber} — ${l10n.blockName(block.blockNumber)}',
                              style: AppTextStyles.headlineMedium,
                            ),
                            if (isCurrent) ...[
                              const SizedBox(width: AppSpacing.sm),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                decoration: BoxDecoration(
                                  color: AppColors.primary,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  l10n.pick('Current', 'الحالي'),
                                  style: TextStyle(color: AppColors.textInverse, fontSize: 10, fontWeight: FontWeight.w700),
                                ),
                              ),
                            ],
                          ],
                        ),
                        const SizedBox(height: 2),
                        Text('${l10n.week} ${block.startWeek}–${block.endWeek}', style: AppTextStyles.bodySmall),
                        const SizedBox(height: 4),
                        Text(
                          block.focusDescription,
                          style: AppTextStyles.bodySmall.copyWith(color: AppColors.textTertiary),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceElevated,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      'RPE\n${block.rpeRange}',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: AppColors.primary,
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        height: 1.3,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Day chips
            Padding(
              padding: const EdgeInsets.fromLTRB(AppSpacing.lg, 0, AppSpacing.lg, AppSpacing.md),
              child: Row(
                children: block.workoutDays.map((day) {
                  final color = _sessionColors[day.sessionType] ?? AppColors.primary;
                  return Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(right: block.workoutDays.last != day ? 6 : 0),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        decoration: BoxDecoration(
                          color: color.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          children: [
                            Text(
                              day.dayAbbrev,
                              style: TextStyle(color: color, fontSize: 9, fontWeight: FontWeight.w700),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              day.sessionType.substring(0, 1).toUpperCase(),
                              style: TextStyle(color: color, fontSize: 13, fontWeight: FontWeight.w800),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),

            // Week pills
            Padding(
              padding: const EdgeInsets.fromLTRB(AppSpacing.lg, 0, AppSpacing.lg, AppSpacing.lg),
              child: Wrap(
                spacing: 6,
                runSpacing: 6,
                children: List.generate(block.weekCount, (i) {
                  final week = block.startWeek + i;
                  final isCurrentWeek = isCurrent && week == currentWeek;
                  return GestureDetector(
                    onTap: () => onWeekTap(week),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                      decoration: BoxDecoration(
                        color: isCurrentWeek ? AppColors.primary : AppColors.surfaceElevated,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        '${l10n.week} $week',
                        style: TextStyle(
                          color: isCurrentWeek ? AppColors.textInverse : AppColors.textSecondary,
                          fontSize: 12,
                          fontWeight: isCurrentWeek ? FontWeight.w700 : FontWeight.w400,
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
