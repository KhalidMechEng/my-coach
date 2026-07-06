import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:wakelock_plus/wakelock_plus.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../shared/widgets/pr_badge.dart';
import '../../../programme/presentation/providers/programme_provider.dart';
import '../../../timer/presentation/providers/timer_provider.dart';
import '../providers/active_workout_provider.dart';

class GuidedWorkoutScreen extends ConsumerStatefulWidget {
  const GuidedWorkoutScreen({super.key});

  @override
  ConsumerState<GuidedWorkoutScreen> createState() => _GuidedWorkoutScreenState();
}

class _GuidedWorkoutScreenState extends ConsumerState<GuidedWorkoutScreen> {
  bool _showPROverlay = false;
  List<String> _prExercises = [];
  bool _finishing = false;
  int? _energyLevel;

  @override
  void initState() {
    super.initState();
    WakelockPlus.enable();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final block = ref.read(currentBlockProvider);
      final week = ref.read(currentWeekProvider);
      final today = ref.read(todaysWorkoutProvider);
      if (today != null) {
        ref.read(activeWorkoutProvider.notifier).startSession(today, block.blockNumber, week);
        ref.read(sessionTimerProvider.notifier).start();
      }
    });
  }

  @override
  void dispose() {
    WakelockPlus.disable();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(activeWorkoutProvider);
    final sessionTime = ref.watch(sessionTimerProvider);
    final notifier = ref.read(sessionTimerProvider.notifier);

    if (state.exercises.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text('Workout')),
        body: Center(child: CircularProgressIndicator(color: AppColors.primary)),
      );
    }

    final currentEx = state.currentExercise!;
    final prescription = state.exercises[state.currentExerciseIndex];
    final completedSets = state.completedSetsForExercise(currentEx.exerciseId);
    final progress = state.currentExerciseIndex / state.exercises.length;

    return Stack(
      children: [
        Scaffold(
          backgroundColor: AppColors.background,
          appBar: AppBar(
            leading: IconButton(
              icon: const Icon(Icons.close),
              onPressed: _confirmCancel,
            ),
            title: Column(
              children: [
                Text(
                  '${state.currentExerciseIndex + 1} / ${state.exercises.length}',
                  style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
                ),
                Text(
                  _formatDuration(sessionTime),
                  style: TextStyle(fontSize: 12, color: AppColors.textTertiary),
                ),
              ],
            ),
            centerTitle: true,
            actions: [
              TextButton(
                onPressed: _finishing ? null : _finishWorkout,
                child: Text(
                  'Finish',
                  style: TextStyle(
                    color: _finishing ? AppColors.textTertiary : AppColors.primary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          body: Column(
            children: [
              // Progress bar
              LinearProgressIndicator(
                value: progress,
                backgroundColor: AppColors.surfaceElevated,
                valueColor: AlwaysStoppedAnimation(AppColors.primary),
                minHeight: 3,
              ),

              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Exercise header
                      GestureDetector(
                        onTap: () => context.push('/exercise', extra: currentEx.exerciseId),
                        child: Container(
                          padding: const EdgeInsets.all(AppSpacing.lg),
                          decoration: BoxDecoration(
                            color: AppColors.surface,
                            borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(currentEx.exerciseName, style: AppTextStyles.headlineMedium),
                                    const SizedBox(height: 4),
                                    Text(
                                      prescription.prescriptionSummary,
                                      style: AppTextStyles.bodySmall.copyWith(color: AppColors.primary),
                                    ),
                                  ],
                                ),
                              ),
                              Icon(Icons.info_outline, color: AppColors.textTertiary, size: 20),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: AppSpacing.lg),

                      // Set list
                      ...List.generate(prescription.sets, (i) {
                        final setIndex = i;
                        final log = (ref.watch(activeWorkoutProvider).setLogs[currentEx.exerciseId] ?? [])[i];
                        final isCurrent = setIndex == state.currentSetIndex;
                        final isDone = log.isDone;

                        return _SetCard(
                          setNumber: i + 1,
                          isCurrent: isCurrent,
                          isDone: isDone,
                          isSkipped: log.isSkipped,
                          prescription: prescription,
                          prefilledWeight: log.weightKg,
                          prefilledReps: log.reps,
                          onComplete: isCurrent
                              ? (reps, weight, rpe) {
                                  ref.read(activeWorkoutProvider.notifier).completeSet(
                                        exerciseId: currentEx.exerciseId,
                                        reps: reps,
                                        weight: weight,
                                        rpe: rpe,
                                      );
                                  _startRestTimer(prescription.restSeconds);
                                }
                              : null,
                          onSkip: isCurrent
                              ? () {
                                  ref.read(activeWorkoutProvider.notifier).skipSet(currentEx.exerciseId);
                                }
                              : null,
                        );
                      }),

                      const SizedBox(height: AppSpacing.lg),

                      // Navigation
                      Row(
                        children: [
                          if (state.currentExerciseIndex > 0)
                            Expanded(
                              child: OutlinedButton(
                                onPressed: () => ref.read(activeWorkoutProvider.notifier).goToPreviousExercise(),
                                style: OutlinedButton.styleFrom(minimumSize: const Size(0, 48)),
                                child: const Text('Previous'),
                              ),
                            ),
                          if (state.currentExerciseIndex > 0) const SizedBox(width: AppSpacing.md),
                          if (state.currentExerciseIndex < state.exercises.length - 1)
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () => ref.read(activeWorkoutProvider.notifier).goToNextExercise(),
                                style: ElevatedButton.styleFrom(minimumSize: const Size(0, 48)),
                                child: const Text('Next Exercise'),
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              // Rest timer bar
              _RestTimerBar(),
            ],
          ),
        ),

        if (_showPROverlay)
          PRCelebrationOverlay(
            exerciseNames: _prExercises,
            onDismiss: () => setState(() => _showPROverlay = false),
          ),
      ],
    );
  }

  void _startRestTimer(int seconds) {
    ref.read(restTimerProvider.notifier).start(seconds);
  }

  String _formatDuration(Duration d) {
    final m = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final s = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  Future<void> _finishWorkout() async {
    final result = await showModalBottomSheet<int?>(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) => _EnergyPicker(),
    );

    if (!mounted) return;
    setState(() => _finishing = true);

    final session = await ref.read(activeWorkoutProvider.notifier).finishSession(energyLevel: result);
    ref.read(sessionTimerProvider.notifier).stop();
    ref.read(restTimerProvider.notifier).reset();

    final prIds = ref.read(activeWorkoutProvider).prExerciseIds;
    if (prIds.isNotEmpty) {
      setState(() {
        _prExercises = prIds;
        _showPROverlay = true;
        _finishing = false;
      });
      await Future.delayed(const Duration(seconds: 3));
      if (mounted) setState(() => _showPROverlay = false);
    }

    if (mounted && session != null) {
      ref.read(activeWorkoutProvider.notifier).reset();
      context.go('/workout/summary', extra: session.id);
    }
  }

  void _confirmCancel() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: AppColors.surface,
        title: const Text('Cancel Workout?'),
        content: const Text('Your progress will not be saved.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Keep going')),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ref.read(activeWorkoutProvider.notifier).reset();
              ref.read(sessionTimerProvider.notifier).reset();
              ref.read(restTimerProvider.notifier).reset();
              context.go('/');
            },
            child: Text('Cancel workout', style: TextStyle(color: AppColors.error)),
          ),
        ],
      ),
    );
  }
}

class _SetCard extends StatefulWidget {
  final int setNumber;
  final bool isCurrent;
  final bool isDone;
  final bool isSkipped;
  final dynamic prescription;
  final double? prefilledWeight;
  final int? prefilledReps;
  final void Function(int reps, double weight, double? rpe)? onComplete;
  final VoidCallback? onSkip;

  const _SetCard({
    required this.setNumber,
    required this.isCurrent,
    required this.isDone,
    required this.isSkipped,
    required this.prescription,
    this.prefilledWeight,
    this.prefilledReps,
    this.onComplete,
    this.onSkip,
  });

  @override
  State<_SetCard> createState() => _SetCardState();
}

class _SetCardState extends State<_SetCard> {
  final _weightCtrl = TextEditingController();
  final _repsCtrl = TextEditingController();
  final _rpeCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.prefilledWeight != null) _weightCtrl.text = widget.prefilledWeight.toString();
    if (widget.prefilledReps != null) _repsCtrl.text = widget.prefilledReps.toString();
  }

  @override
  void dispose() {
    _weightCtrl.dispose();
    _repsCtrl.dispose();
    _rpeCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Color borderColor;
    if (widget.isSkipped) borderColor = AppColors.textTertiary;
    else if (widget.isDone) borderColor = AppColors.success;
    else if (widget.isCurrent) borderColor = AppColors.primary;
    else borderColor = AppColors.divider;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: widget.isCurrent ? AppColors.surface : AppColors.surface.withOpacity(0.6),
        borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
        border: Border.all(color: borderColor, width: widget.isCurrent ? 2 : 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: widget.isDone && !widget.isSkipped
                      ? AppColors.success
                      : widget.isSkipped
                          ? AppColors.textTertiary
                          : AppColors.surfaceElevated,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: widget.isDone
                      ? Icon(
                          widget.isSkipped ? Icons.remove : Icons.check,
                          color: Colors.white,
                          size: 16,
                        )
                      : Text(
                          '${widget.setNumber}',
                          style: TextStyle(color: AppColors.textSecondary, fontSize: 13, fontWeight: FontWeight.w700),
                        ),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Text(
                'Set ${widget.setNumber}',
                style: AppTextStyles.titleMedium.copyWith(
                  color: widget.isCurrent ? AppColors.textPrimary : AppColors.textSecondary,
                ),
              ),
              const Spacer(),
              Text(
                widget.prescription.prescriptionSummary,
                style: AppTextStyles.bodySmall.copyWith(color: AppColors.textTertiary),
              ),
            ],
          ),

          if (widget.isCurrent && !widget.isDone) ...[
            const SizedBox(height: AppSpacing.lg),
            Row(
              children: [
                Expanded(
                  child: _InputField(
                    controller: _weightCtrl,
                    label: 'Weight (kg)',
                    hint: '0.0',
                    isDecimal: true,
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: _InputField(
                    controller: _repsCtrl,
                    label: 'Reps',
                    hint: widget.prescription.repRange,
                    isDecimal: false,
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                SizedBox(
                  width: 64,
                  child: _InputField(
                    controller: _rpeCtrl,
                    label: 'RPE',
                    hint: '${widget.prescription.targetRpe.toInt()}',
                    isDecimal: true,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(minimumSize: const Size(0, 50)),
                    onPressed: () {
                      final reps = int.tryParse(_repsCtrl.text) ?? 0;
                      final weight = double.tryParse(_weightCtrl.text) ?? 0;
                      final rpe = double.tryParse(_rpeCtrl.text);
                      if (reps > 0 && weight > 0) widget.onComplete?.call(reps, weight, rpe);
                    },
                    child: const Text('Done', style: TextStyle(fontWeight: FontWeight.w700)),
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                OutlinedButton(
                  style: OutlinedButton.styleFrom(minimumSize: const Size(0, 50)),
                  onPressed: widget.onSkip,
                  child: const Text('Skip'),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class _InputField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String hint;
  final bool isDecimal;

  const _InputField({
    required this.controller,
    required this.label,
    required this.hint,
    required this.isDecimal,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(color: AppColors.textSecondary, fontSize: 11, fontWeight: FontWeight.w500)),
        const SizedBox(height: 4),
        TextField(
          controller: controller,
          keyboardType: isDecimal
              ? const TextInputType.numberWithOptions(decimal: true)
              : TextInputType.number,
          textAlign: TextAlign.center,
          style: TextStyle(color: AppColors.textPrimary, fontSize: 18, fontWeight: FontWeight.w700),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: AppColors.textTertiary, fontSize: 16),
            contentPadding: const EdgeInsets.symmetric(vertical: 12),
          ),
        ),
      ],
    );
  }
}

class _RestTimerBar extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final timer = ref.watch(restTimerProvider);

    if (!timer.isRunning && !timer.isFinished) return const SizedBox.shrink();

    return Container(
      color: AppColors.surface,
      padding: EdgeInsets.fromLTRB(
        AppSpacing.lg,
        AppSpacing.md,
        AppSpacing.lg,
        MediaQuery.of(context).padding.bottom + AppSpacing.md,
      ),
      child: Row(
        children: [
          Icon(Icons.timer_outlined, color: AppColors.primary, size: 20),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  timer.isFinished ? 'Rest done!' : 'Rest: ${timer.displayTime}',
                  style: TextStyle(
                    color: timer.isFinished ? AppColors.success : AppColors.textPrimary,
                    fontWeight: FontWeight.w700,
                    fontSize: 15,
                  ),
                ),
                if (!timer.isFinished)
                  LinearProgressIndicator(
                    value: timer.progress,
                    backgroundColor: AppColors.surfaceElevated,
                    valueColor: AlwaysStoppedAnimation(AppColors.primary),
                    minHeight: 3,
                  ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          TextButton(
            onPressed: () => ref.read(restTimerProvider.notifier).skip(),
            child: Text(timer.isFinished ? 'Dismiss' : 'Skip', style: TextStyle(color: AppColors.primary)),
          ),
        ],
      ),
    );
  }
}

class _EnergyPicker extends StatefulWidget {
  @override
  State<_EnergyPicker> createState() => _EnergyPickerState();
}

class _EnergyPickerState extends State<_EnergyPicker> {
  int? _selected;

  static const _labels = ['Very Low', 'Low', 'Moderate', 'High', 'Max'];
  static const _emojis = ['😴', '😑', '🙂', '💪', '🔥'];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
          AppSpacing.xxl, AppSpacing.xxl, AppSpacing.xxl, MediaQuery.of(context).padding.bottom + AppSpacing.lg),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('How was your energy?', style: AppTextStyles.headlineMedium),
          const SizedBox(height: AppSpacing.xxl),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(5, (i) {
              final level = i + 1;
              final isSelected = _selected == level;
              return GestureDetector(
                onTap: () => setState(() => _selected = level),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 150),
                  width: 56,
                  height: 64,
                  decoration: BoxDecoration(
                    color: isSelected ? AppColors.primaryContainer : AppColors.surfaceElevated,
                    borderRadius: BorderRadius.circular(12),
                    border: isSelected ? Border.all(color: AppColors.primary, width: 2) : null,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(_emojis[i], style: const TextStyle(fontSize: 22)),
                      const SizedBox(height: 2),
                      Text(
                        _labels[i],
                        style: TextStyle(
                          color: isSelected ? AppColors.primary : AppColors.textSecondary,
                          fontSize: 8,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
          const SizedBox(height: AppSpacing.xxl),
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              onPressed: () => Navigator.of(context).pop(_selected),
              child: const Text('Finish Workout', style: TextStyle(fontWeight: FontWeight.w700)),
            ),
          ),
        ],
      ),
    );
  }
}
