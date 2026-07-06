import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/utils/volume_calculator.dart';
import '../../../../shared/widgets/loading_indicator.dart';
import '../../../../shared/widgets/pr_badge.dart';
import '../providers/workout_history_provider.dart';

class WorkoutHistoryScreen extends ConsumerWidget {
  const WorkoutHistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final historyAsync = ref.watch(workoutHistoryProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('History')),
      body: historyAsync.when(
        loading: () => const LoadingIndicator(),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (sessions) {
          final completed = sessions.where((s) => s.isCompleted).toList();
          if (completed.isEmpty) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('🏋️', style: TextStyle(fontSize: 48)),
                  SizedBox(height: 16),
                  Text('No workouts yet', style: AppTextStyles.headlineMedium),
                  SizedBox(height: 8),
                  Text('Complete your first session to see it here.', style: AppTextStyles.bodySmall),
                ],
              ),
            );
          }

          // Group by month
          final grouped = <String, List<dynamic>>{};
          for (final s in completed) {
            final key = DateFormat('MMMM yyyy').format(s.startTime);
            grouped.putIfAbsent(key, () => []).add(s);
          }

          return ListView(
            padding: const EdgeInsets.all(AppSpacing.lg),
            children: grouped.entries.expand((entry) {
              return [
                Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.md, top: AppSpacing.lg),
                  child: Text(entry.key, style: AppTextStyles.headlineMedium),
                ),
                ...entry.value.map((session) => Padding(
                      padding: const EdgeInsets.only(bottom: AppSpacing.md),
                      child: GestureDetector(
                        onTap: () => context.push('/workout/summary', extra: session.id),
                        child: Container(
                          padding: const EdgeInsets.all(AppSpacing.lg),
                          decoration: BoxDecoration(
                            color: AppColors.surface,
                            borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    width: 40,
                                    height: 40,
                                    decoration: BoxDecoration(
                                      color: AppColors.primaryContainer,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Center(
                                      child: Text(
                                        session.sessionType.substring(0, 1).toUpperCase(),
                                        style: TextStyle(
                                          color: AppColors.primary,
                                          fontWeight: FontWeight.w800,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: AppSpacing.md),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(session.sessionLabel, style: AppTextStyles.titleMedium),
                                        Text(
                                          DateFormat('EEE, d MMM · HH:mm').format(session.startTime),
                                          style: AppTextStyles.bodySmall,
                                        ),
                                      ],
                                    ),
                                  ),
                                  if (session.exerciseLogs.any((l) => l.hasPr))
                                    const PRBadge(),
                                  const SizedBox(width: AppSpacing.sm),
                                  Icon(Icons.chevron_right, color: AppColors.textTertiary, size: 18),
                                ],
                              ),
                              if (session.totalVolume != null || session.durationSeconds != null) ...[
                                const SizedBox(height: AppSpacing.md),
                                Divider(color: AppColors.divider, height: 1),
                                const SizedBox(height: AppSpacing.md),
                                Row(
                                  children: [
                                    if (session.durationSeconds != null) ...[
                                      Icon(Icons.timer_outlined, size: 14, color: AppColors.textSecondary),
                                      const SizedBox(width: 4),
                                      Text(
                                        VolumeCalculator.formatDuration(session.durationSeconds!),
                                        style: AppTextStyles.bodySmall,
                                      ),
                                      const SizedBox(width: AppSpacing.lg),
                                    ],
                                    if (session.totalVolume != null) ...[
                                      Icon(Icons.fitness_center, size: 14, color: AppColors.textSecondary),
                                      const SizedBox(width: 4),
                                      Text(
                                        VolumeCalculator.formatVolume(session.totalVolume!),
                                        style: AppTextStyles.bodySmall,
                                      ),
                                    ],
                                    const Spacer(),
                                    Text(
                                      'B${session.blockNumber} W${session.weekNumber}',
                                      style: AppTextStyles.labelSmall.copyWith(color: AppColors.textTertiary),
                                    ),
                                  ],
                                ),
                              ],
                            ],
                          ),
                        ),
                      ),
                    )),
              ];
            }).toList(),
          );
        },
      ),
    );
  }
}
