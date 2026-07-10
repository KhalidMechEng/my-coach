import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/utils/volume_calculator.dart';
import '../../../../core/l10n/app_strings.dart';
import '../../../../shared/widgets/app_card.dart';
import '../../../../shared/widgets/section_header.dart';
import '../providers/dashboard_provider.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dash = ref.watch(dashboardProvider);
    final l10n = ref.watch(l10nProvider);

    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
          color: AppColors.primary,
          onRefresh: () async {},
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(AppSpacing.lg, AppSpacing.xxl, AppSpacing.lg, AppSpacing.lg),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _greeting(l10n),
                            style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
                          ),
                          Text(
                            'Khalid',
                            style: AppTextStyles.displayMedium,
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          _BlockBadge(block: dash.currentBlock, week: dash.currentWeek, l10n: l10n),
                          IconButton(
                            icon: Icon(Icons.settings_outlined, color: AppColors.textSecondary),
                            onPressed: () => context.push('/settings'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              // Today's workout card
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                  child: _TodayCard(dash: dash, l10n: l10n)
                      .animate()
                      .fadeIn(duration: 450.ms)
                      .slideY(begin: 0.08, curve: Curves.easeOutCubic),
                ),
              ),

              const SliverToBoxAdapter(child: SizedBox(height: AppSpacing.xxl)),

              // Stats row
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                  child: Row(
                    children: [
                      Expanded(child: _StatCard(label: l10n.pick('Workouts', 'التمارين'), value: '${dash.totalWorkouts}')),
                      const SizedBox(width: AppSpacing.md),
                      Expanded(child: _StatCard(label: l10n.pick('Streak', 'التتابع'), value: '${dash.currentStreak}${l10n.pick('d', 'ي')}')),
                      const SizedBox(width: AppSpacing.md),
                      Expanded(child: _StatCard(label: l10n.pick('Consistency', 'الالتزام'), value: '${dash.consistencyPercent.round()}%')),
                    ],
                  )
                      .animate()
                      .fadeIn(delay: 120.ms, duration: 450.ms)
                      .slideY(begin: 0.1, curve: Curves.easeOutCubic),
                ),
              ),

              const SliverToBoxAdapter(child: SizedBox(height: AppSpacing.xxl)),

              // Weekly volume chart
              if (dash.weeklyVolume.isNotEmpty) ...[
                SliverToBoxAdapter(
                  child: SectionHeader(title: l10n.pick('Weekly Volume', 'الحجم الأسبوعي')),
                ),
                const SliverToBoxAdapter(child: SizedBox(height: AppSpacing.lg)),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                    child: _VolumeChart(data: dash.weeklyVolume),
                  ),
                ),
              ],

              const SliverToBoxAdapter(child: SizedBox(height: AppSpacing.xxl)),

              // Recent sessions
              if (dash.recentSessions.isNotEmpty) ...[
                SliverToBoxAdapter(
                  child: SectionHeader(
                    title: l10n.pick('Recent Sessions', 'الجلسات الأخيرة'),
                    action: l10n.pick('See all', 'عرض الكل'),
                    onAction: () => context.push('/workout/history'),
                  ),
                ),
                const SliverToBoxAdapter(child: SizedBox(height: AppSpacing.lg)),
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (ctx, i) {
                      final s = dash.recentSessions[i];
                      return Padding(
                        padding: const EdgeInsets.fromLTRB(AppSpacing.lg, 0, AppSpacing.lg, AppSpacing.md),
                        child: AppCard(
                          padding: const EdgeInsets.all(AppSpacing.lg),
                          child: Row(
                            children: [
                              Container(
                                width: 44,
                                height: 44,
                                decoration: BoxDecoration(
                                  color: AppColors.primaryContainer,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Center(
                                  child: Text(
                                    s.sessionType.substring(0, 1).toUpperCase(),
                                    style: TextStyle(
                                      color: AppColors.primary,
                                      fontWeight: FontWeight.w800,
                                      fontSize: 18,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: AppSpacing.md),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(l10n.sessionLabel(s.sessionType), style: AppTextStyles.titleMedium),
                                    Text(
                                      DateFormat('EEE, d MMM').format(s.startTime),
                                      style: AppTextStyles.bodySmall,
                                    ),
                                  ],
                                ),
                              ),
                              if (s.totalVolume != null)
                                Text(
                                  VolumeCalculator.formatVolume(s.totalVolume!),
                                  style: AppTextStyles.labelLarge.copyWith(color: AppColors.primary),
                                ),
                            ],
                          ),
                        ),
                      );
                    },
                    childCount: dash.recentSessions.length,
                  ),
                ),
              ],

              const SliverToBoxAdapter(child: SizedBox(height: 100)),
            ],
          ),
        ),
      ),
    );
  }

  String _greeting(L10n l10n) {
    final h = DateTime.now().hour;
    if (h < 12) return l10n.pick('Good morning,', 'صباح الخير،');
    if (h < 17) return l10n.pick('Good afternoon,', 'مساء الخير،');
    return l10n.pick('Good evening,', 'مساء الخير،');
  }
}

class _BlockBadge extends StatelessWidget {
  final int block;
  final int week;
  final L10n l10n;
  const _BlockBadge({required this.block, required this.week, required this.l10n});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.primaryContainer,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text('${l10n.block} $block', style: TextStyle(color: AppColors.primary, fontSize: 12, fontWeight: FontWeight.w700)),
          Text('${l10n.week} $week', style: TextStyle(color: AppColors.primary, fontSize: 11)),
        ],
      ),
    );
  }
}

class _TodayCard extends StatelessWidget {
  final DashboardState dash;
  final L10n l10n;
  const _TodayCard({required this.dash, required this.l10n});

  @override
  Widget build(BuildContext context) {
    final today = dash.todaysWorkout;

    if (today == null) {
      return AppCard(
        padding: const EdgeInsets.all(AppSpacing.xxl),
        child: Column(
          children: [
            const Text('🛌', style: TextStyle(fontSize: 40)),
            const SizedBox(height: AppSpacing.sm),
            Text(l10n.pick('Rest Day', 'يوم راحة'), style: AppTextStyles.headlineMedium),
            const SizedBox(height: 2),
            Text(l10n.pick('Recover and come back stronger.', 'استعد وارجع أقوى.'),
                textAlign: TextAlign.center, style: AppTextStyles.bodySmall),
          ],
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(AppSpacing.xxl),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.navy, AppColors.navyDark],
        ),
        borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.22), width: 1),
        boxShadow: [
          BoxShadow(
            color: AppColors.navy.withValues(alpha: 0.35),
            blurRadius: 24,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Soft teal glow anchored top-right for depth.
          Positioned(
            top: -30,
            right: -20,
            child: Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [AppColors.primary.withValues(alpha: 0.28), Colors.transparent],
                ),
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 7,
                    height: 7,
                    decoration: BoxDecoration(color: AppColors.primary, shape: BoxShape.circle),
                  ),
                  const SizedBox(width: 6),
                  Text(l10n.pick('TODAY', 'اليوم'),
                      style: TextStyle(color: AppColors.primary, fontSize: 12, fontWeight: FontWeight.w800, letterSpacing: 1.5)),
                ],
              ),
              const SizedBox(height: 6),
              Text(l10n.sessionLabel(today.sessionType),
                  style: AppTextStyles.headlineLarge.copyWith(color: AppColors.onNavy)),
              const SizedBox(height: 4),
              Text(
                '${today.exerciseCount} ${l10n.pick('exercises', 'تمرين')} · ${today.exercises.map((e) => e.sets).fold(0, (a, b) => a + b)} ${l10n.pick('total sets', 'مجموعة')}',
                style: AppTextStyles.bodySmall.copyWith(color: AppColors.onNavySecondary),
              ),
              const SizedBox(height: AppSpacing.xl),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton.icon(
                  onPressed: () => context.push('/programme/week/${dash.currentWeek}'),
                  icon: const Icon(Icons.play_arrow_rounded, size: 22),
                  label: Text(l10n.pick('Start Workout', 'ابدأ التمرين'),
                      style: const TextStyle(fontWeight: FontWeight.w700)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  const _StatCard({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(value, style: AppTextStyles.numericMedium.copyWith(color: AppColors.primary)),
          const SizedBox(height: 2),
          Text(label, style: AppTextStyles.bodySmall),
        ],
      ),
    );
  }
}

class _VolumeChart extends StatelessWidget {
  final List<({DateTime date, double volume})> data;
  const _VolumeChart({required this.data});

  @override
  Widget build(BuildContext context) {
    final maxVal = data.map((d) => d.volume).fold(0.0, (a, b) => a > b ? a : b);
    return AppCard(
      padding: const EdgeInsets.fromLTRB(AppSpacing.md, AppSpacing.lg, AppSpacing.md, AppSpacing.sm),
      child: SizedBox(
      height: 132,
      child: BarChart(
        BarChartData(
          maxY: maxVal * 1.2 + 1,
          minY: 0,
          gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
            getDrawingHorizontalLine: (_) => FlLine(
              color: AppColors.chartGrid,
              strokeWidth: 1,
            ),
          ),
          borderData: FlBorderData(show: false),
          titlesData: FlTitlesData(
            leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  final i = value.toInt();
                  if (i < 0 || i >= data.length) return const SizedBox();
                  return Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      DateFormat('d/M').format(data[i].date),
                      style: TextStyle(color: AppColors.textTertiary, fontSize: 9),
                    ),
                  );
                },
              ),
            ),
          ),
          barGroups: data.asMap().entries.map((entry) {
            return BarChartGroupData(
              x: entry.key,
              barRods: [
                BarChartRodData(
                  toY: entry.value.volume,
                  color: entry.value.volume > 0 ? AppColors.primary : AppColors.surfaceElevated,
                  width: 14,
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
                ),
              ],
            );
          }).toList(),
        ),
      ),
      ),
    );
  }
}
