import 'workout_day.dart';

class ProgrammeBlock {
  final int blockNumber;
  final String name;
  final int startWeek;
  final int endWeek;
  final String focusDescription;
  final String rpeRange;
  final List<WorkoutDay> workoutDays;

  const ProgrammeBlock({
    required this.blockNumber,
    required this.name,
    required this.startWeek,
    required this.endWeek,
    required this.focusDescription,
    required this.rpeRange,
    required this.workoutDays,
  });

  String get weekRange => 'Weeks $startWeek–$endWeek';

  int get weekCount => endWeek - startWeek + 1;

  bool get isDeload => blockNumber == 4;

  WorkoutDay? dayFor(String dayOfWeek) {
    try {
      return workoutDays.firstWhere((d) => d.dayOfWeek == dayOfWeek);
    } catch (_) {
      return null;
    }
  }
}
