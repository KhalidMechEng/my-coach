import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../providers/performance_provider.dart';

class ExerciseTrendScreen extends ConsumerWidget {
  final String exerciseId;
  final String exerciseName;

  const ExerciseTrendScreen({
    super.key,
    required this.exerciseId,
    required this.exerciseName,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stats = ref.watch(exerciseStatsProvider((exerciseId: exerciseId, exerciseName: exerciseName)));

    return Scaffold(
      appBar: AppBar(title: Text(exerciseName, maxLines: 1, overflow: TextOverflow.ellipsis)),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        children: [
          if (!stats.hasData)
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 80),
                child: Column(
                  children: [
                    const Text('📈', style: TextStyle(fontSize: 48)),
                    const SizedBox(height: 16),
                    Text('No data yet', style: AppTextStyles.headlineMedium),
                    Text('Log a session to see trends.', style: AppTextStyles.bodySmall),
                  ],
                ),
              ),
            )
          else ...[
            // Stat cards
            Row(children: [
              Expanded(child: _StatCard(label: 'Best Weight', value: '${stats.bestWeight}kg')),
              const SizedBox(width: AppSpacing.md),
              Expanded(child: _StatCard(label: 'Max Reps', value: '${stats.maxReps}')),
            ]),
            const SizedBox(height: AppSpacing.md),
            Row(children: [
              Expanded(child: _StatCard(label: 'Est. 1RM', value: '${stats.estimatedOneRepMax.toStringAsFixed(1)}kg')),
              const SizedBox(width: AppSpacing.md),
              Expanded(child: _StatCard(label: 'Sessions', value: '${stats.totalSessions}')),
            ]),

            const SizedBox(height: AppSpacing.xxl),

            // Weight over time
            if (stats.weightHistory.length >= 2) ...[
              Text('Weight Progression', style: AppTextStyles.headlineMedium),
              const SizedBox(height: AppSpacing.lg),
              _LineChart(
                data: stats.weightHistory.map((p) => (p.date, p.value)).toList(),
                unit: 'kg',
                color: AppColors.primary,
              ),
              const SizedBox(height: AppSpacing.xxl),
            ],

            // Weekly volume
            if (stats.weeklyVolumeHistory.length >= 2) ...[
              Text('Weekly Volume', style: AppTextStyles.headlineMedium),
              const SizedBox(height: AppSpacing.lg),
              _BarChart(
                data: stats.weeklyVolumeHistory.map((p) => (p.date, p.value)).toList(),
              ),
            ],

            const SizedBox(height: 40),
          ],
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
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(value, style: AppTextStyles.numericMedium),
          const SizedBox(height: 2),
          Text(label, style: AppTextStyles.bodySmall),
        ],
      ),
    );
  }
}

class _LineChart extends StatelessWidget {
  final List<(DateTime, double)> data;
  final String unit;
  final Color color;

  const _LineChart({required this.data, required this.unit, required this.color});

  @override
  Widget build(BuildContext context) {
    final minY = data.map((d) => d.$2).reduce((a, b) => a < b ? a : b);
    final maxY = data.map((d) => d.$2).reduce((a, b) => a > b ? a : b);
    final paddedMin = (minY * 0.95).floorToDouble();
    final paddedMax = (maxY * 1.05).ceilToDouble();

    return Container(
      height: 200,
      padding: const EdgeInsets.fromLTRB(AppSpacing.sm, AppSpacing.lg, AppSpacing.lg, AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
      ),
      child: LineChart(
        LineChartData(
          minY: paddedMin,
          maxY: paddedMax,
          gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
            getDrawingHorizontalLine: (_) => FlLine(color: AppColors.chartGrid, strokeWidth: 1),
          ),
          borderData: FlBorderData(show: false),
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 44,
                getTitlesWidget: (v, _) => Text(
                  '${v.toInt()}$unit',
                  style: TextStyle(color: AppColors.textTertiary, fontSize: 9),
                ),
              ),
            ),
            rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, _) {
                  final i = value.toInt();
                  if (i < 0 || i >= data.length || i % (data.length > 6 ? 3 : 1) != 0) {
                    return const SizedBox();
                  }
                  return Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      DateFormat('d/M').format(data[i].$1),
                      style: TextStyle(color: AppColors.textTertiary, fontSize: 9),
                    ),
                  );
                },
              ),
            ),
          ),
          lineBarsData: [
            LineChartBarData(
              spots: data.asMap().entries.map((e) => FlSpot(e.key.toDouble(), e.value.$2)).toList(),
              isCurved: true,
              curveSmoothness: 0.3,
              color: color,
              barWidth: 2.5,
              dotData: FlDotData(
                show: true,
                getDotPainter: (_, __, ___, ____) => FlDotCirclePainter(
                  radius: 3,
                  color: color,
                  strokeWidth: 0,
                ),
              ),
              belowBarData: BarAreaData(
                show: true,
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [color.withOpacity(0.25), color.withOpacity(0)],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BarChart extends StatelessWidget {
  final List<(DateTime, double)> data;
  const _BarChart({required this.data});

  @override
  Widget build(BuildContext context) {
    final maxY = data.map((d) => d.$2).fold(0.0, (a, b) => a > b ? a : b);

    return Container(
      height: 160,
      padding: const EdgeInsets.fromLTRB(AppSpacing.md, AppSpacing.lg, AppSpacing.md, AppSpacing.sm),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
      ),
      child: BarChart(
        BarChartData(
          maxY: maxY * 1.2 + 1,
          gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
            getDrawingHorizontalLine: (_) => FlLine(color: AppColors.chartGrid, strokeWidth: 1),
          ),
          borderData: FlBorderData(show: false),
          titlesData: FlTitlesData(
            leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, _) {
                  final i = value.toInt();
                  if (i < 0 || i >= data.length) return const SizedBox();
                  return Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      DateFormat('d/M').format(data[i].$1),
                      style: TextStyle(color: AppColors.textTertiary, fontSize: 9),
                    ),
                  );
                },
              ),
            ),
          ),
          barGroups: data.asMap().entries.map((e) {
            return BarChartGroupData(
              x: e.key,
              barRods: [
                BarChartRodData(
                  toY: e.value.$2,
                  color: e.value.$2 > 0 ? AppColors.primary : AppColors.surfaceElevated,
                  width: 12,
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
                ),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }
}
