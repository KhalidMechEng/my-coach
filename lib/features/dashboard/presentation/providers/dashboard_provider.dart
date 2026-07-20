import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../workout/domain/models/workout_session.dart';
import '../../../workout/presentation/providers/workout_history_provider.dart';
import '../../../programme/presentation/providers/programme_provider.dart';
import '../../../programme/domain/models/workout_day.dart';

class DashboardState {
  final WorkoutDay? todaysWorkout;
  final int currentBlock;
  final int currentWeek;
  final int currentStreak;
  final int longestStreak;
  final int totalWorkouts;
  final double totalVolume;
  final double consistencyPercent;
  final List<WorkoutSession> recentSessions;
  final List<({DateTime date, double volume})> weeklyVolume;

  const DashboardState({
    this.todaysWorkout,
    this.currentBlock = 1,
    this.currentWeek = 1,
    this.currentStreak = 0,
    this.longestStreak = 0,
    this.totalWorkouts = 0,
    this.totalVolume = 0,
    this.consistencyPercent = 0,
    this.recentSessions = const [],
    this.weeklyVolume = const [],
  });
}

final dashboardProvider = Provider<DashboardState>((ref) {
  final sessions = ref.watch(workoutHistoryProvider).valueOrNull ?? [];
  final todaysWorkout = ref.watch(todaysWorkoutProvider);
  final currentBlock = ref.watch(currentBlockProvider);
  final currentWeek = ref.watch(currentWeekProvider);

  final completedSessions = sessions.where((s) => s.isCompleted).toList();

  final totalWorkouts = completedSessions.length;
  final totalVolume = completedSessions.fold(0.0, (sum, s) => sum + (s.totalVolume ?? 0));

  // Streaks — count consecutive training days (Mon–Fri)
  final streak = _computeStreak(completedSessions);

  // Consistency: sessions completed vs sessions scheduled in current block
  final weekdaysInBlock =
      currentBlock.weekCount * currentBlock.workoutDays.length; // training days per week
  final blockSessions = completedSessions
      .where((s) => s.blockNumber == currentBlock.blockNumber)
      .length;
  final consistency = weekdaysInBlock > 0
      ? (blockSessions / weekdaysInBlock * 100).clamp(0, 100).toDouble()
      : 0.0;

  // Weekly volume for last 8 weeks
  final weeklyVolumeMap = <DateTime, double>{};
  final now = DateTime.now();
  for (var i = 0; i < 8; i++) {
    final monday = _mondayOfWeek(now.subtract(Duration(days: i * 7)));
    weeklyVolumeMap[monday] = 0;
  }
  for (final s in completedSessions) {
    final monday = _mondayOfWeek(s.startTime);
    if (weeklyVolumeMap.containsKey(monday)) {
      weeklyVolumeMap[monday] = weeklyVolumeMap[monday]! + (s.totalVolume ?? 0);
    }
  }
  final weeklyVolume = weeklyVolumeMap.entries
      .map((e) => (date: e.key, volume: e.value))
      .toList()
    ..sort((a, b) => a.date.compareTo(b.date));

  return DashboardState(
    todaysWorkout: todaysWorkout,
    currentBlock: currentBlock.blockNumber,
    currentWeek: currentWeek,
    currentStreak: streak.$1,
    longestStreak: streak.$2,
    totalWorkouts: totalWorkouts,
    totalVolume: totalVolume,
    consistencyPercent: consistency,
    recentSessions: completedSessions.take(5).toList(),
    weeklyVolume: weeklyVolume,
  );
});

(int current, int longest) _computeStreak(List<WorkoutSession> sessions) {
  if (sessions.isEmpty) return (0, 0);

  final dates = sessions
      .map((s) => DateTime(s.startTime.year, s.startTime.month, s.startTime.day))
      .toSet()
      .toList()
    ..sort((a, b) => b.compareTo(a));

  int current = 0;
  int longest = 0;
  int temp = 1;
  final today = DateTime.now();
  final todayDate = DateTime(today.year, today.month, today.day);
  final yesterdayDate = todayDate.subtract(const Duration(days: 1));

  if (dates.isEmpty) return (0, 0);

  // Current streak — walking back from today
  if (dates.first == todayDate || dates.first == yesterdayDate) {
    current = 1;
    for (var i = 1; i < dates.length; i++) {
      final diff = dates[i - 1].difference(dates[i]).inDays;
      if (diff == 1) {
        current++;
      } else {
        break;
      }
    }
  }

  // Longest streak
  for (var i = 1; i < dates.length; i++) {
    final diff = dates[i - 1].difference(dates[i]).inDays;
    if (diff == 1) {
      temp++;
      if (temp > longest) longest = temp;
    } else {
      temp = 1;
    }
  }
  if (temp > longest) longest = temp;

  return (current, longest);
}

DateTime _mondayOfWeek(DateTime date) {
  return date.subtract(Duration(days: date.weekday - 1));
}
