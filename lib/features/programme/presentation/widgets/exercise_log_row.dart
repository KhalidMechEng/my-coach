import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/l10n/app_strings.dart';
import '../../../../core/utils/image_url.dart';
import '../../../../shared/widgets/app_card.dart';
import '../../../exercise/presentation/providers/exercise_provider.dart';
import '../../domain/models/exercise_prescription.dart';
import '../providers/week_log_provider.dart';

String _fmt(double v) => v % 1 == 0 ? v.toStringAsFixed(0) : v.toString();

/// One logging row in the week-detail screen: a large done-tick, exercise
/// thumbnail + name + prescription, a big-number weight field (prefilled with
/// last week's weight so a repeat week is a single tap), and the last-week
/// delta. Backed by [AppCard] for the flat minimal look.
class ExerciseLogRow extends ConsumerStatefulWidget {
  final ExercisePrescription prescription;
  final int week;
  final String unit;
  final L10n l10n;

  const ExerciseLogRow({
    super.key,
    required this.prescription,
    required this.week,
    required this.unit,
    required this.l10n,
  });

  @override
  ConsumerState<ExerciseLogRow> createState() => _ExerciseLogRowState();
}

class _ExerciseLogRowState extends ConsumerState<ExerciseLogRow> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    final n = ref.read(weekLogProvider.notifier);
    final thisWeek = n.entry(widget.week, widget.prescription.exerciseId).weight;
    // Prefill with last week's weight when this week is untouched, so repeating
    // a session is one tap. Shown as editable text (not yet persisted).
    final lastWeek = n.entry(widget.week - 1, widget.prescription.exerciseId).weight;
    final seed = thisWeek ?? lastWeek;
    _controller = TextEditingController(text: seed != null ? _fmt(seed) : '');
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _commitWeight() {
    final parsed = double.tryParse(_controller.text.trim());
    ref.read(weekLogProvider.notifier).setWeight(widget.week, widget.prescription.exerciseId, parsed);
  }

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

    return AppCard(
      padding: const EdgeInsets.all(AppSpacing.lg),
      border: done ? Border.all(color: AppColors.primary, width: 1.5) : null,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              // Large (44px) done target — commits the shown weight, then toggles.
              GestureDetector(
                onTap: () {
                  if (!done && !widget.prescription.isTimeBased) _commitWeight();
                  notifier.setDone(widget.week, id, !done);
                },
                behavior: HitTestBehavior.opaque,
                child: Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: done ? AppColors.primary : AppColors.surfaceElevated,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: done ? AppColors.primary : AppColors.divider,
                      width: 1.5,
                    ),
                  ),
                  child: Icon(
                    Icons.check,
                    size: 22,
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
                SizedBox(
                  width: 128,
                  child: TextField(
                    controller: _controller,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9.]'))],
                    style: AppTextStyles.numericSmall,
                    onChanged: (v) => notifier.setWeight(widget.week, id, double.tryParse(v.trim())),
                    decoration: InputDecoration(
                      isDense: true,
                      hintText: l10n.pick('Weight', 'الوزن'),
                      hintStyle: AppTextStyles.bodyMedium.copyWith(color: AppColors.textTertiary),
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
          '${l10n.pick('Last week', 'الأسبوع السابق')}: ${_fmt(prev!)} $unit',
          style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary),
        ),
        if (delta != null && delta != 0)
          Row(
            children: [
              Icon(up ? Icons.arrow_upward : Icons.arrow_downward, size: 13, color: color),
              const SizedBox(width: 2),
              Text(
                '${_fmt(delta!.abs())} $unit',
                style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.w700),
              ),
            ],
          ),
      ],
    );
  }
}

/// Small GIF thumbnail beside the exercise name; taps open the exercise detail.
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
                  errorWidget: (_, __, ___) => Icon(Icons.fitness_center, size: 20, color: AppColors.textTertiary),
                )
              : Icon(Icons.fitness_center, size: 20, color: AppColors.textTertiary),
        ),
      ),
    );
  }
}
