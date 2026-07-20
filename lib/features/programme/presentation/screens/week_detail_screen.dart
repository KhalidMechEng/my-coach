import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/extensions/datetime_ext.dart';
import '../../../../core/l10n/app_strings.dart';
import '../../../../core/providers/profile_provider.dart';
import '../../../../core/utils/image_url.dart';
import '../../../../data/programme/programme_data.dart';
import '../../../exercise/presentation/providers/exercise_provider.dart';
import '../../domain/models/exercise_prescription.dart';
import '../../domain/models/workout_day.dart';
import '../providers/week_log_provider.dart';

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

    return ListView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      children: [
        Text(l10n.sessionLabel(day.sessionType), style: AppTextStyles.headlineLarge),
        const SizedBox(height: AppSpacing.sm),
        Row(
          children: [
            _Pill(text: '${day.exerciseCount} ${l10n.pick('exercises', 'تمرين')}'),
            const SizedBox(width: 8),
            _Pill(text: '$totalSets ${l10n.pick('sets', 'مجموعة')}'),
            const SizedBox(width: 8),
            _Pill(
              text: '$doneCount/${day.exerciseCount} ${l10n.pick('done', 'مكتمل')}',
              highlight: doneCount == day.exerciseCount && day.exerciseCount > 0,
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.xxl),
        ...day.exercises.asMap().entries.map((entry) {
          return Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.md),
            child: _ExerciseRow(
              index: entry.key + 1,
              prescription: entry.value,
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

class _Pill extends StatelessWidget {
  final String text;
  final bool highlight;
  const _Pill({required this.text, this.highlight = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: highlight ? AppColors.primary : AppColors.surfaceElevated,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: highlight ? AppColors.textInverse : AppColors.textSecondary,
          fontSize: 11,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _ExerciseRow extends ConsumerStatefulWidget {
  final int index;
  final ExercisePrescription prescription;
  final int week;
  final String unit;
  final L10n l10n;

  const _ExerciseRow({
    required this.index,
    required this.prescription,
    required this.week,
    required this.unit,
    required this.l10n,
  });

  @override
  ConsumerState<_ExerciseRow> createState() => _ExerciseRowState();
}

class _ExerciseRowState extends ConsumerState<_ExerciseRow> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    final entry = ref
        .read(weekLogProvider.notifier)
        .entry(widget.week, widget.prescription.exerciseId);
    _controller = TextEditingController(text: entry.weight != null ? _fmt(entry.weight!) : '');
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  static String _fmt(double v) => v % 1 == 0 ? v.toStringAsFixed(0) : v.toString();

  @override
  Widget build(BuildContext context) {
    final l10n = widget.l10n;
    final id = widget.prescription.exerciseId;
    final notifier = ref.read(weekLogProvider.notifier);

    final entry = ref.watch(weekLogProvider.select((m) => m[widget.week]?[id]));
    final done = entry?.done ?? false;
    final current = entry?.weight;
    final prev = ref.watch(weekLogProvider.select((m) => m[widget.week - 1]?[id]?.weight));
    final delta = (current != null && prev != null) ? current - prev : null;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
        border: Border.all(
          color: done ? AppColors.primary.withOpacity(0.6) : Colors.transparent,
          width: 1.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              // Done tick
              GestureDetector(
                onTap: () => notifier.setDone(widget.week, id, !done),
                child: Container(
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                    color: done ? AppColors.primary : AppColors.surfaceElevated,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: done ? AppColors.primary : AppColors.divider,
                      width: 1.5,
                    ),
                  ),
                  child: Icon(
                    Icons.check,
                    size: 18,
                    color: done ? AppColors.textInverse : AppColors.textTertiary,
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              _ExerciseThumb(exerciseId: id),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.prescription.exerciseName,
                      style: AppTextStyles.titleMedium.copyWith(
                        decoration: done ? TextDecoration.lineThrough : null,
                        color: done ? AppColors.textSecondary : AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(widget.prescription.prescriptionSummary, style: AppTextStyles.bodySmall),
                  ],
                ),
              ),
              IconButton(
                icon: Icon(Icons.info_outline, color: AppColors.textTertiary, size: 20),
                onPressed: () => context.push('/exercise/$id'),
                tooltip: l10n.howToPerform,
              ),
            ],
          ),
          // Time-based work (cardio) logs no weight — the done tick is enough.
          if (!widget.prescription.isTimeBased) ...[
            const SizedBox(height: AppSpacing.md),
            Row(
              children: [
                // Weight input
                SizedBox(
                  width: 120,
                  child: TextField(
                    controller: _controller,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9.]'))],
                    onChanged: (v) => notifier.setWeight(
                        widget.week, id, double.tryParse(v.trim())),
                    decoration: InputDecoration(
                      isDense: true,
                      hintText: l10n.pick('Weight', 'الوزن'),
                      suffixText: widget.unit,
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(child: _Comparison(prev: prev, delta: delta, unit: widget.unit, l10n: l10n)),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class _Comparison extends StatelessWidget {
  final double? prev;
  final double? delta;
  final String unit;
  final L10n l10n;
  const _Comparison({required this.prev, required this.delta, required this.unit, required this.l10n});

  @override
  Widget build(BuildContext context) {
    if (prev == null) {
      return Text(
        l10n.pick('No previous week', 'لا يوجد أسبوع سابق'),
        style: AppTextStyles.bodySmall.copyWith(color: AppColors.textTertiary),
      );
    }
    final up = (delta ?? 0) > 0;
    final down = (delta ?? 0) < 0;
    final color = up ? AppColors.success : (down ? AppColors.error : AppColors.textSecondary);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '${l10n.pick('Last week', 'الأسبوع السابق')}: ${_ExerciseRowState._fmt(prev!)} $unit',
          style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary),
        ),
        if (delta != null && delta != 0)
          Row(
            children: [
              Icon(up ? Icons.arrow_upward : Icons.arrow_downward, size: 13, color: color),
              const SizedBox(width: 2),
              Text(
                '${_ExerciseRowState._fmt(delta!.abs())} $unit',
                style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.w700),
              ),
            ],
          ),
      ],
    );
  }
}

/// Small GIF thumbnail shown beside the exercise name in the day view.
/// Tapping it opens the exercise detail (GIF + technique).
class _ExerciseThumb extends ConsumerWidget {
  final String exerciseId;
  const _ExerciseThumb({required this.exerciseId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final exercises = ref.watch(allExercisesProvider).valueOrNull;
    String? url;
    if (exercises != null) {
      for (final e in exercises) {
        if (e.id == exerciseId) {
          url = e.gifUrl ?? (e.youtubeVideoId != null ? e.youtubeThumbnailUrl : null);
          break;
        }
      }
    }
    return GestureDetector(
      onTap: () => context.push('/exercise/$exerciseId'),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppSpacing.thumbRadius),
        child: Container(
          width: 52,
          height: 52,
          color: AppColors.thumbBackground,
          child: url != null
              ? CachedNetworkImage(
                  imageUrl: webSafeImageUrl(url),
                  fit: BoxFit.cover,
                  placeholder: (_, __) => Container(color: AppColors.thumbBackground),
                  errorWidget: (_, __, ___) => Icon(Icons.fitness_center,
                      size: 20, color: AppColors.textTertiary),
                )
              : Icon(Icons.fitness_center, size: 20, color: AppColors.textTertiary),
        ),
      ),
    );
  }
}
