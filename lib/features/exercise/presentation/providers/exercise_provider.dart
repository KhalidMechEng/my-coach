import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/exercise_repository_impl.dart';
import '../../domain/models/exercise.dart';

final exerciseRepositoryProvider = Provider<ExerciseRepository>(
  (_) => ExerciseRepository(),
);

final exerciseProvider = FutureProvider.family<Exercise?, String>((ref, exerciseId) {
  return ref.read(exerciseRepositoryProvider).getExercise(exerciseId);
});

/// The full exercise library, used by the browse screen.
final allExercisesProvider = FutureProvider<List<Exercise>>((ref) {
  return ref.read(exerciseRepositoryProvider).getAllExercises();
});
