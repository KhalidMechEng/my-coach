import 'completed_set.dart';

class ExerciseLog {
  final String exerciseId;
  final String exerciseName;
  final int orderIndex;
  final List<CompletedSet> sets;

  const ExerciseLog({
    required this.exerciseId,
    required this.exerciseName,
    required this.orderIndex,
    required this.sets,
  });

  double get totalVolume => sets.fold(0.0, (sum, s) => sum + s.volume);

  double get bestWeight =>
      sets.isEmpty ? 0 : sets.map((s) => s.weightKg).reduce((a, b) => a > b ? a : b);

  int get bestReps =>
      sets.isEmpty ? 0 : sets.map((s) => s.repsCompleted).reduce((a, b) => a > b ? a : b);

  bool get hasPr => sets.any((s) => s.isPr);

  int get completedSets => sets.length;

  factory ExerciseLog.fromMap(Map<String, dynamic> map) {
    return ExerciseLog(
      exerciseId: map['exerciseId'] as String,
      exerciseName: map['exerciseName'] as String,
      orderIndex: (map['orderIndex'] as num).toInt(),
      sets: (map['sets'] as List<dynamic>)
          .map((s) => CompletedSet.fromMap(s as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'exerciseId': exerciseId,
      'exerciseName': exerciseName,
      'orderIndex': orderIndex,
      'sets': sets.map((s) => s.toMap()).toList(),
    };
  }
}
