import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/utils/volume_calculator.dart';
import '../providers/calendar_provider.dart';

class CalendarScreen extends ConsumerWidget {
  const CalendarScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(calendarProvider);
    final notifier = ref.read(calendarProvider.notifier);

    return Scaffold(
      appBar: AppBar(title: const Text('Calendar')),
      body: Column(
        children: [
          TableCalendar(
            firstDay: DateTime(2024, 1, 1),
            lastDay: DateTime(2030, 12, 31),
            focusedDay: state.focusedDay,
            selectedDayPredicate: (day) =>
                state.selectedDay != null && isSameDay(state.selectedDay!, day),
            onDaySelected: (selected, focused) {
              notifier.onDaySelected(selected);
            },
            onPageChanged: notifier.onPageChanged,
            calendarStyle: CalendarStyle(
              outsideDaysVisible: false,
              defaultTextStyle: TextStyle(color: AppColors.textPrimary),
              weekendTextStyle: TextStyle(color: AppColors.textSecondary),
              selectedTextStyle: TextStyle(color: AppColors.textInverse, fontWeight: FontWeight.w700),
              selectedDecoration: BoxDecoration(
                color: AppColors.primary,
                shape: BoxShape.circle,
              ),
              todayDecoration: BoxDecoration(
                color: AppColors.primaryContainer,
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.primary, width: 2),
              ),
              todayTextStyle: TextStyle(color: AppColors.primary, fontWeight: FontWeight.w700),
              markerDecoration: BoxDecoration(
                color: AppColors.primary,
                shape: BoxShape.circle,
              ),
            ),
            headerStyle: HeaderStyle(
              formatButtonVisible: false,
              titleCentered: true,
              titleTextStyle: AppTextStyles.headlineMedium,
              leftChevronIcon: Icon(Icons.chevron_left, color: AppColors.textPrimary),
              rightChevronIcon: Icon(Icons.chevron_right, color: AppColors.textPrimary),
            ),
            daysOfWeekStyle: DaysOfWeekStyle(
              weekdayStyle: TextStyle(color: AppColors.textSecondary, fontSize: 12),
              weekendStyle: TextStyle(color: AppColors.textTertiary, fontSize: 12),
            ),
            calendarBuilders: CalendarBuilders(
              defaultBuilder: (ctx, day, focusedDay) {
                return _DayCell(
                  day: day,
                  isCompleted: state.isCompleted(day),
                  isMissed: state.isMissed(day),
                  isSelected: false,
                  isToday: isSameDay(day, DateTime.now()),
                );
              },
            ),
          ),

          Divider(height: 1, color: AppColors.divider),

          // Selected day detail
          Expanded(
            child: state.selectedDay == null
                ? Center(
                    child: Text('Tap a day to see details', style: AppTextStyles.bodySmall),
                  )
                : _DayDetail(
                    day: state.selectedDay!,
                    session: state.sessionForDay(state.selectedDay!),
                  ),
          ),
        ],
      ),
    );
  }
}

class _DayCell extends StatelessWidget {
  final DateTime day;
  final bool isCompleted;
  final bool isMissed;
  final bool isSelected;
  final bool isToday;

  const _DayCell({
    required this.day,
    required this.isCompleted,
    required this.isMissed,
    required this.isSelected,
    required this.isToday,
  });

  @override
  Widget build(BuildContext context) {
    Color? dotColor;
    if (isCompleted) dotColor = AppColors.completed;
    if (isMissed && !isCompleted) dotColor = AppColors.missed;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          '${day.day}',
          style: TextStyle(
            color: isToday ? AppColors.primary : AppColors.textPrimary,
            fontWeight: isToday ? FontWeight.w700 : FontWeight.w400,
          ),
        ),
        if (dotColor != null) ...[
          const SizedBox(height: 2),
          Container(
            width: 5,
            height: 5,
            decoration: BoxDecoration(color: dotColor, shape: BoxShape.circle),
          ),
        ],
      ],
    );
  }
}

class _DayDetail extends StatelessWidget {
  final DateTime day;
  final dynamic session;

  const _DayDetail({required this.day, required this.session});

  @override
  Widget build(BuildContext context) {
    final isWeekend = day.weekday > 5;
    final isPast = day.isBefore(DateTime.now().subtract(const Duration(days: 1)));

    return Padding(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            DateFormat('EEEE, d MMMM').format(day),
            style: AppTextStyles.headlineMedium,
          ),
          const SizedBox(height: AppSpacing.lg),

          if (isWeekend)
            _InfoTile(icon: Icons.self_improvement, label: 'Rest Day', color: AppColors.textSecondary)
          else if (session == null && !isPast)
            _InfoTile(icon: Icons.fitness_center_outlined, label: 'Scheduled workout', color: AppColors.primary)
          else if (session == null && isPast)
            _InfoTile(icon: Icons.cancel_outlined, label: 'Missed', color: AppColors.missed)
          else ...[
            _InfoTile(
              icon: Icons.check_circle_outline,
              label: session.sessionLabel,
              color: AppColors.completed,
            ),
            if (session.totalVolume != null) ...[
              const SizedBox(height: AppSpacing.md),
              Row(
                children: [
                  _Chip(label: VolumeCalculator.formatVolume(session.totalVolume!), icon: Icons.fitness_center),
                  const SizedBox(width: AppSpacing.sm),
                  if (session.durationSeconds != null)
                    _Chip(label: VolumeCalculator.formatDuration(session.durationSeconds!), icon: Icons.timer_outlined),
                ],
              ),
            ],
            const SizedBox(height: AppSpacing.lg),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () => context.push('/workout/summary', extra: session.id),
                child: const Text('View Session'),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _InfoTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  const _InfoTile({required this.icon, required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: color, size: 22),
        const SizedBox(width: AppSpacing.md),
        Text(label, style: AppTextStyles.titleLarge.copyWith(color: color)),
      ],
    );
  }
}

class _Chip extends StatelessWidget {
  final String label;
  final IconData icon;
  const _Chip({required this.label, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.surfaceElevated,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: AppColors.textSecondary),
          const SizedBox(width: 4),
          Text(label, style: AppTextStyles.labelMedium),
        ],
      ),
    );
  }
}
