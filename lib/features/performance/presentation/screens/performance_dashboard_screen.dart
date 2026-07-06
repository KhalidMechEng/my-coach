import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../shared/widgets/loading_indicator.dart';
import '../../../performance/domain/models/personal_record.dart';
import '../providers/performance_provider.dart';
import '../../../workout/presentation/providers/workout_history_provider.dart';

class PerformanceDashboardScreen extends ConsumerWidget {
  const PerformanceDashboardScreen({super.key});

  static const _exercises = [
    (id: 'bench_press', name: 'Barbell Bench Press'),
    (id: 'back_squat', name: 'Barbell Back Squat'),
    (id: 'romanian_deadlift', name: 'Romanian Deadlift'),
    (id: 'incline_barbell_press', name: 'Incline Barbell Press'),
    (id: 'pull_up', name: 'Pull-Up'),
    (id: 'bent_over_row', name: 'Barbell Bent-Over Row'),
    (id: 'hack_squat', name: 'Hack Squat'),
    (id: 'hip_thrust', name: 'Barbell Hip Thrust'),
    (id: 'seated_cable_row', name: 'Seated Cable Row'),
    (id: 'incline_db_press', name: 'Incline DB Press'),
    (id: 'seated_db_ohp', name: 'Seated DB Overhead Press'),
    (id: 'bulgarian_split_squat', name: 'Bulgarian Split Squat'),
    (id: 'lat_pulldown_neutral', name: 'Lat Pulldown (Neutral)'),
    (id: 'lat_pulldown_bar', name: 'Lat Pulldown (Bar)'),
    (id: 'leg_press', name: 'Leg Press'),
    (id: 'barbell_curl', name: 'Barbell Curl'),
    (id: 'hammer_curl', name: 'Hammer Curl'),
    (id: 'incline_db_curl', name: 'Incline DB Curl'),
    (id: 'tricep_pushdown', name: 'Tricep Pushdown'),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final historyAsync = ref.watch(workoutHistoryProvider);
    final prsAsync = ref.watch(allPersonalRecordsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Progress'),
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: () => context.push('/workout/history'),
          ),
        ],
      ),
      body: historyAsync.when(
        loading: () => const LoadingIndicator(),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (sessions) {
          if (sessions.isEmpty) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('📊', style: TextStyle(fontSize: 48)),
                  SizedBox(height: 16),
                  Text('No data yet', style: AppTextStyles.headlineMedium),
                  Text('Complete your first workout to see performance data.', style: AppTextStyles.bodySmall),
                ],
              ),
            );
          }

          return ListView(
            padding: const EdgeInsets.all(AppSpacing.lg),
            children: [
              // PRs summary
              prsAsync.when(
                data: (prs) => prs.isEmpty ? const SizedBox() : _PRsSection(prs: prs),
                loading: () => const ShimmerCard(height: 100),
                error: (_, __) => const SizedBox(),
              ),

              const SizedBox(height: AppSpacing.xxl),
              Text('Exercises', style: AppTextStyles.headlineMedium),
              const SizedBox(height: AppSpacing.lg),

              ..._exercises.map((ex) {
                final stats = ref.watch(exerciseStatsProvider((exerciseId: ex.id, exerciseName: ex.name)));
                return Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.md),
                  child: GestureDetector(
                    onTap: () => context.push('/performance/exercise', extra: {'id': ex.id, 'name': ex.name}),
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
                                Text(ex.name, style: AppTextStyles.titleMedium),
                                const SizedBox(height: 4),
                                if (stats.hasData)
                                  Text(
                                    '${stats.totalSessions} sessions · Best: ${stats.bestWeight}kg',
                                    style: AppTextStyles.bodySmall,
                                  )
                                else
                                  Text('No data yet', style: AppTextStyles.bodySmall),
                              ],
                            ),
                          ),
                          if (stats.hasData) ...[
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  '${stats.estimatedOneRepMax.toStringAsFixed(1)}kg',
                                  style: AppTextStyles.titleMedium.copyWith(color: AppColors.primary),
                                ),
                                Text('est. 1RM', style: TextStyle(color: AppColors.textSecondary, fontSize: 10)),
                              ],
                            ),
                            const SizedBox(width: AppSpacing.sm),
                          ],
                          Icon(Icons.chevron_right, color: AppColors.textTertiary, size: 20),
                        ],
                      ),
                    ),
                  ),
                );
              }),
            ],
          );
        },
      ),
    );
  }
}

class _PRsSection extends StatelessWidget {
  final List<PersonalRecord> prs;
  const _PRsSection({required this.prs});

  @override
  Widget build(BuildContext context) {
    final weightPRs = prs.where((p) => p.type == PRType.weight).take(3).toList();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Personal Records', style: AppTextStyles.headlineMedium),
        const SizedBox(height: AppSpacing.md),
        ...weightPRs.map((pr) => Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.sm),
              child: Container(
                padding: const EdgeInsets.all(AppSpacing.md),
                decoration: BoxDecoration(
                  color: AppColors.prGold.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
                  border: Border.all(color: AppColors.prGold.withOpacity(0.25)),
                ),
                child: Row(
                  children: [
                    const Text('🏆', style: TextStyle(fontSize: 20)),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(pr.exerciseName, style: AppTextStyles.titleMedium),
                          Text(pr.typeLabel, style: AppTextStyles.bodySmall),
                        ],
                      ),
                    ),
                    Text(
                      pr.displayValue(),
                      style: AppTextStyles.numericMedium.copyWith(color: AppColors.prGold, fontSize: 18),
                    ),
                  ],
                ),
              ),
            )),
      ],
    );
  }
}
