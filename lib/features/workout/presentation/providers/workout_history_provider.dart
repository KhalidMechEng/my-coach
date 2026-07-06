import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/services/local_store.dart';
import '../../data/workout_repository_impl.dart';
import '../../domain/models/workout_session.dart';

final workoutRepositoryProvider = Provider<WorkoutRepository>(
  (ref) => WorkoutRepository(ref.watch(localStoreProvider)),
);

final workoutHistoryProvider = StreamProvider<List<WorkoutSession>>((ref) {
  return ref.watch(workoutRepositoryProvider).watchHistory('local');
});
