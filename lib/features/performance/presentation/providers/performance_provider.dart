import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/services/local_store.dart';
import '../../data/performance_repository_impl.dart';
import '../../domain/models/exercise_stats.dart';
import '../../domain/models/personal_record.dart';
import '../../../workout/presentation/providers/workout_history_provider.dart';

final performanceRepositoryProvider = Provider<PerformanceRepository>(
  (ref) => PerformanceRepository(ref.watch(localStoreProvider)),
);

final allPersonalRecordsProvider = FutureProvider<List<PersonalRecord>>((ref) {
  // Recompute whenever workout history changes (new PRs may have been saved).
  ref.watch(workoutHistoryProvider);
  return ref.watch(performanceRepositoryProvider).getPersonalRecords('local');
});

final exerciseStatsProvider =
    Provider.family<ExerciseStats, ({String exerciseId, String exerciseName})>((ref, args) {
  final history = ref.watch(workoutHistoryProvider).valueOrNull ?? [];
  return ref
      .watch(performanceRepositoryProvider)
      .computeStatsFromSessions(args.exerciseId, args.exerciseName, history);
});
