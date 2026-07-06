import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../workout/domain/models/workout_session.dart';
import '../../../workout/presentation/providers/workout_history_provider.dart';

class CalendarState {
  final Map<DateTime, WorkoutSession> sessionsByDate;
  final DateTime focusedDay;
  final DateTime? selectedDay;

  const CalendarState({
    this.sessionsByDate = const {},
    required this.focusedDay,
    this.selectedDay,
  });

  WorkoutSession? sessionForDay(DateTime day) {
    final key = DateTime(day.year, day.month, day.day);
    return sessionsByDate[key];
  }

  bool isCompleted(DateTime day) {
    final s = sessionForDay(day);
    return s?.isCompleted ?? false;
  }

  bool isMissed(DateTime day) {
    final s = sessionForDay(day);
    if (s != null) return s.status == SessionStatus.skipped;
    // A weekday in the past with no session = missed
    final now = DateTime.now();
    final key = DateTime(day.year, day.month, day.day);
    return key.isBefore(DateTime(now.year, now.month, now.day)) &&
        day.weekday <= 5 &&
        !sessionsByDate.containsKey(key);
  }

  CalendarState copyWith({DateTime? focusedDay, DateTime? selectedDay}) {
    return CalendarState(
      sessionsByDate: sessionsByDate,
      focusedDay: focusedDay ?? this.focusedDay,
      selectedDay: selectedDay ?? this.selectedDay,
    );
  }
}

class CalendarNotifier extends StateNotifier<CalendarState> {
  final Ref _ref;

  CalendarNotifier(this._ref)
      : super(CalendarState(focusedDay: DateTime.now())) {
    _listen();
  }

  void _listen() {
    _ref.listen(workoutHistoryProvider, (_, next) {
      final sessions = next.valueOrNull ?? [];
      final map = <DateTime, WorkoutSession>{};
      for (final s in sessions) {
        final key = DateTime(s.startTime.year, s.startTime.month, s.startTime.day);
        map[key] = s;
      }
      state = CalendarState(
        sessionsByDate: map,
        focusedDay: state.focusedDay,
        selectedDay: state.selectedDay,
      );
    });
  }

  void onDaySelected(DateTime day) {
    state = state.copyWith(
      focusedDay: day,
      selectedDay: day,
    );
  }

  void onPageChanged(DateTime focusedDay) {
    state = state.copyWith(focusedDay: focusedDay);
  }
}

final calendarProvider = StateNotifierProvider<CalendarNotifier, CalendarState>(
  (ref) => CalendarNotifier(ref),
);
