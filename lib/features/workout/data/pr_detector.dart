import '../../../core/services/local_store.dart';
import '../../performance/domain/models/personal_record.dart';
import '../domain/models/exercise_log.dart';
import '../../../core/utils/volume_calculator.dart';

/// Detects personal records against locally stored PRs and persists new ones.
/// Storage key holds a map of `${exerciseId}_${type}` -> PR map.
class PRDetector {
  final LocalStore _store;
  static const key = 'personal_records';

  PRDetector(this._store);

  Map<String, dynamic> _all() => _store.getJson(key) ?? {};

  Future<List<String>> detectAndSavePRs(
    String userId,
    String sessionId,
    List<ExerciseLog> logs,
  ) async {
    final prExercises = <String>[];
    final store = _all();

    for (final log in logs) {
      if (log.sets.isEmpty) continue;

      final bestWeight = log.bestWeight;
      final bestReps = log.bestReps;
      final sessionVolume = log.totalVolume;
      final best1RM = log.sets
          .map((s) => VolumeCalculator.estimatedOneRepMax(s.weightKg, s.repsCompleted))
          .reduce((a, b) => a > b ? a : b);

      final checks = [
        (PRType.weight, bestWeight),
        (PRType.reps, bestReps.toDouble()),
        (PRType.volume, sessionVolume),
        (PRType.estimatedOneRepMax, best1RM),
      ];

      bool exerciseHadPR = false;

      for (final (type, newValue) in checks) {
        final id = '${log.exerciseId}_${type.name}';
        final existingMap = store[id] as Map<String, dynamic>?;
        final existing = existingMap != null ? PersonalRecord.fromMap(id, existingMap) : null;

        if (existing == null || newValue > existing.value) {
          final pr = PersonalRecord(
            id: id,
            exerciseId: log.exerciseId,
            exerciseName: log.exerciseName,
            type: type,
            value: newValue,
            previousValue: existing?.value,
            achievedAt: DateTime.now(),
            workoutSessionId: sessionId,
          );
          store[id] = pr.toMap();
          exerciseHadPR = true;
        }
      }

      if (exerciseHadPR) prExercises.add(log.exerciseId);
    }

    await _store.setJson(key, store);
    return prExercises;
  }
}
