import '../../../core/services/local_store.dart';
import '../domain/models/exercise_stats.dart';
import '../domain/models/personal_record.dart';
import '../../workout/data/pr_detector.dart';
import '../../workout/domain/models/workout_session.dart';
import '../../../core/utils/volume_calculator.dart';

/// Reads personal records from local storage and computes exercise stats from
/// the locally stored workout history. Fully offline.
class PerformanceRepository {
  final LocalStore _store;

  PerformanceRepository(this._store);

  List<PersonalRecord> _loadPRs() {
    final map = _store.getJson(PRDetector.key) ?? {};
    return map.entries
        .map((e) => PersonalRecord.fromMap(e.key, e.value as Map<String, dynamic>))
        .toList();
  }

  Future<List<PersonalRecord>> getPersonalRecords(String userId) async => _loadPRs();

  Future<PersonalRecord?> getPRForExercise(
      String userId, String exerciseId, PRType type) async {
    final map = _store.getJson(PRDetector.key) ?? {};
    final id = '${exerciseId}_${type.name}';
    final raw = map[id] as Map<String, dynamic>?;
    return raw != null ? PersonalRecord.fromMap(id, raw) : null;
  }

  ExerciseStats computeStatsFromSessions(
      String exerciseId, String exerciseName, List<WorkoutSession> sessions) {
    double bestWeight = 0;
    int maxReps = 0;
    double totalVolume = 0;
    double best1RM = 0;
    final weightHistory = <ChartDataPoint>[];
    final Map<int, double> weeklyVolume = {};
    int totalSets = 0;
    int totalSessions = 0;

    for (final session in sessions) {
      for (final log in session.exerciseLogs) {
        if (log.exerciseId != exerciseId) continue;
        totalSessions++;

        for (final set in log.sets) {
          totalSets++;
          totalVolume += set.volume;
          if (set.weightKg > bestWeight) bestWeight = set.weightKg;
          if (set.repsCompleted > maxReps) maxReps = set.repsCompleted;
          final rm = VolumeCalculator.estimatedOneRepMax(set.weightKg, set.repsCompleted);
          if (rm > best1RM) best1RM = rm;
        }

        if (log.bestWeight > 0) {
          weightHistory.add(ChartDataPoint(
            date: session.startTime,
            value: log.bestWeight,
          ));
        }

        final weekNum = _weekNumber(session.startTime);
        weeklyVolume[weekNum] = (weeklyVolume[weekNum] ?? 0) + log.totalVolume;
      }
    }

    final sortedWeeks = weeklyVolume.keys.toList()..sort();
    final volumeHistory = sortedWeeks.map((w) {
      final monday = _mondayOfWeek(w, DateTime.now().year);
      return ChartDataPoint(date: monday, value: weeklyVolume[w]!);
    }).toList();

    return ExerciseStats(
      exerciseId: exerciseId,
      exerciseName: exerciseName,
      bestWeight: bestWeight,
      maxReps: maxReps,
      totalVolume: totalVolume,
      estimatedOneRepMax: best1RM,
      weightHistory: weightHistory.take(20).toList(),
      weeklyVolumeHistory: volumeHistory.take(12).toList(),
      totalSets: totalSets,
      totalSessions: totalSessions,
    );
  }

  int _weekNumber(DateTime date) {
    final startOfYear = DateTime(date.year, 1, 1);
    return ((date.difference(startOfYear).inDays) / 7).floor();
  }

  DateTime _mondayOfWeek(int weekNum, int year) {
    final startOfYear = DateTime(year, 1, 1);
    return startOfYear.add(Duration(days: weekNum * 7));
  }
}
