import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/utils/volume_calculator.dart';
import '../../../../shared/widgets/pr_badge.dart';
import '../../domain/models/workout_session.dart';
import '../providers/workout_history_provider.dart';

class WorkoutSummaryScreen extends ConsumerWidget {
  final String sessionId;
  const WorkoutSummaryScreen({super.key, required this.sessionId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final repo = ref.watch(workoutRepositoryProvider);

    return FutureBuilder<WorkoutSession?>(
      future: repo.getSessionById('local', sessionId),
      builder: (context, snapshot) {
        final session = snapshot.data;
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            body: Center(child: CircularProgressIndicator(color: AppColors.primary)),
          );
        }
        if (session == null) {
          return Scaffold(
            appBar: AppBar(),
            body: const Center(child: Text('Session not found.')),
          );
        }
        return _SummaryContent(session: session);
      },
    );
  }
}

class _SummaryContent extends StatelessWidget {
  final WorkoutSession session;
  const _SummaryContent({required this.session});

  @override
  Widget build(BuildContext context) {
    final totalSets = session.exerciseLogs.fold(0, (sum, l) => sum + l.sets.length);
    final hasPR = session.exerciseLogs.any((l) => l.hasPr);

    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.xxl),
                child: Column(
                  children: [
                    const SizedBox(height: AppSpacing.xl),
                    Text('🎉', style: const TextStyle(fontSize: 56))
                        .animate()
                        .scale(begin: const Offset(0, 0), duration: 500.ms, curve: Curves.elasticOut),
                    const SizedBox(height: AppSpacing.lg),
                    Text('Workout Complete!', style: AppTextStyles.displayMedium)
                        .animate()
                        .fadeIn(delay: 200.ms, duration: 400.ms)
                        .slideY(begin: 0.3, end: 0),
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      '${session.sessionLabel} · ${DateFormat('EEE, d MMM').format(session.startTime)}',
                      style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
                    ).animate().fadeIn(delay: 300.ms),
                    if (hasPR) ...[
                      const SizedBox(height: AppSpacing.lg),
                      const PRBadge(label: '🏆 New Personal Record', large: true),
                    ],
                  ],
                ),
              ),
            ),

            // Stats grid
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                child: Row(
                  children: [
                    Expanded(
                      child: _StatCard(
                        label: 'Duration',
                        value: session.durationSeconds != null
                            ? VolumeCalculator.formatDuration(session.durationSeconds!)
                            : '—',
                        icon: Icons.timer_outlined,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: _StatCard(
                        label: 'Volume',
                        value: session.totalVolume != null
                            ? VolumeCalculator.formatVolume(session.totalVolume!)
                            : '—',
                        icon: Icons.fitness_center,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: _StatCard(
                        label: 'Sets',
                        value: '$totalSets',
                        icon: Icons.repeat,
                      ),
                    ),
                  ],
                ).animate().fadeIn(delay: 400.ms).slideY(begin: 0.2, end: 0),
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: AppSpacing.xxl)),

            // Exercise breakdown
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                child: Text('Exercise Summary', style: AppTextStyles.headlineMedium),
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: AppSpacing.md)),

            SliverList(
              delegate: SliverChildBuilderDelegate(
                (ctx, i) {
                  final log = session.exerciseLogs[i];
                  return Padding(
                    padding: const EdgeInsets.fromLTRB(AppSpacing.lg, 0, AppSpacing.lg, AppSpacing.md),
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
                              Expanded(
                                child: Text(log.exerciseName, style: AppTextStyles.titleMedium),
                              ),
                              if (log.hasPr) const PRBadge(),
                            ],
                          ),
                          const SizedBox(height: AppSpacing.sm),
                          Wrap(
                            spacing: 8,
                            runSpacing: 4,
                            children: log.sets.asMap().entries.map((entry) {
                              final s = entry.value;
                              return Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                decoration: BoxDecoration(
                                  color: s.isPr ? AppColors.prGold.withOpacity(0.15) : AppColors.surfaceElevated,
                                  borderRadius: BorderRadius.circular(8),
                                  border: s.isPr ? Border.all(color: AppColors.prGold.withOpacity(0.5)) : null,
                                ),
                                child: Text(
                                  '${s.weightKg}kg × ${s.repsCompleted}',
                                  style: TextStyle(
                                    color: s.isPr ? AppColors.prGold : AppColors.textSecondary,
                                    fontSize: 12,
                                    fontWeight: s.isPr ? FontWeight.w700 : FontWeight.w400,
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                          const SizedBox(height: AppSpacing.sm),
                          Text(
                            VolumeCalculator.formatVolume(log.totalVolume),
                            style: AppTextStyles.bodySmall.copyWith(color: AppColors.primary),
                          ),
                        ],
                      ),
                    ).animate(delay: Duration(milliseconds: 100 * i)).fadeIn().slideX(begin: 0.05, end: 0),
                  );
                },
                childCount: session.exerciseLogs.length,
              ),
            ),

            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.fromLTRB(
                    AppSpacing.lg, AppSpacing.lg, AppSpacing.lg, AppSpacing.lg + MediaQuery.of(context).padding.bottom),
                child: ElevatedButton(
                  onPressed: () => context.go('/'),
                  child: const Text('Back to Home'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  const _StatCard({required this.label, required this.value, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
      ),
      child: Column(
        children: [
          Icon(icon, color: AppColors.primary, size: 22),
          const SizedBox(height: 6),
          Text(value, style: AppTextStyles.numericMedium.copyWith(fontSize: 18)),
          const SizedBox(height: 2),
          Text(label, style: AppTextStyles.bodySmall),
        ],
      ),
    );
  }
}
