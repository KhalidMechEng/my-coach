import 'exercise_prescription.dart';

class WorkoutDay {
  final String dayOfWeek;
  final String sessionType;
  final String sessionLabel;
  final List<ExercisePrescription> exercises;

  const WorkoutDay({
    required this.dayOfWeek,
    required this.sessionType,
    required this.sessionLabel,
    required this.exercises,
  });

  String get displayName => sessionLabel;

  String get dayAbbrev {
    const map = {
      'monday': 'MON',
      'tuesday': 'TUE',
      'wednesday': 'WED',
      'thursday': 'THU',
      'friday': 'FRI',
    };
    return map[dayOfWeek] ?? dayOfWeek.substring(0, 3).toUpperCase();
  }

  int get exerciseCount => exercises.length;
}
