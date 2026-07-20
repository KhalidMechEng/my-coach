import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/extensions/datetime_ext.dart';
import '../../../../core/l10n/app_strings.dart';
import '../../../../core/providers/profile_provider.dart';
import '../../../../data/programme/programme_data.dart';
import '../../domain/models/workout_day.dart';
import '../providers/week_log_provider.dart';
import '../widgets/exercise_log_row.dart';

class WeekDetailScreen extends ConsumerWidget {
  final int weekNumber;

  const WeekDetailScreen({super.key, required this.weekNumber});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final block = blockForWeek(weekNumber);
    final l10n = ref.watch(l10nProvider);
    final unit = ref.watch(profileProvider).unit;

    // Open on today's session tab when today is a training day.
    final todayKey = DateTime.now().weekdayKey;
    final todayIdx = block.workoutDays.indexWhere((d) => d.dayOfWeek == todayKey);
    final initialIndex = todayIdx >= 0 ? todayIdx : 0;

    return DefaultTabController(
      length: block.workoutDays.length,
      initialIndex: initialIndex,
      child: Scaffold(
        appBar: AppBar(
          title: Text('${l10n.block} ${block.blockNumber} · ${l10n.week} $weekNumber'),
          bottom: TabBar(
            isScrollable: true,
            indicatorColor: AppColors.primary,
            labelColor: AppColors.primary,
            unselectedLabelColor: AppColors.textSecondary,
            tabs: block.workoutDays.map((d) => Tab(text: d.dayAbbrev)).toList(),
          ),
        ),
        body: TabBarView(
          children: block.workoutDays
              .map((day) => _DayView(day: day, week: weekNumber, l10n: l10n, unit: unit))
              .toList(),
        ),
      ),
    );
  }
}

class _DayView extends ConsumerWidget {
  final WorkoutDay day;
  final int week;
  final L10n l10n;
  final String unit;
  const _DayView({required this.day, required this.week, required this.l10n, required this.unit});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ids = day.exercises.map((e) => e.exerciseId).toList();
    final doneCount = ref.watch(weekLogProvider
        .select((m) => ids.where((id) => m[week]?[id]?.done ?? false).length));
    final totalSets = day.exercises.map((e) => e.sets).fold(0, (a, b) => a + b);

    final allDone = doneCount == day.exerciseCount && day.exerciseCount > 0;
    final progress = day.exerciseCount == 0 ? 0.0 : doneCount / day.exerciseCount;

    return ListView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      children: [
        Text(l10n.sessionLabel(day.sessionType), style: AppTextStyles.headlineLarge),
        const SizedBox(height: AppSpacing.xs),
        Text(
          '${day.exerciseCount} ${l10n.pick('exercises', 'تمرين')} · $totalSets ${l10n.pick('sets', 'مجموعة')}',
          style: AppTextStyles.bodySmall,
        ),
        const SizedBox(height: AppSpacing.md),
        // One progress line replaces the old three summary pills.
        Row(
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: progress,
                  minHeight: 6,
                  backgroundColor: AppColors.surfaceElevated,
                  valueColor: AlwaysStoppedAnimation(allDone ? AppColors.success : AppColors.primary),
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Text(
              '$doneCount/${day.exerciseCount}',
              style: AppTextStyles.labelLarge.copyWith(
                color: allDone ? AppColors.success : AppColors.textSecondary,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.xl),
        ...day.exercises.map((prescription) {
          return Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.md),
            child: ExerciseLogRow(
              prescription: prescription,
              week: week,
              unit: unit,
              l10n: l10n,
            ),
          );
        }),
      ],
    );
  }
}
