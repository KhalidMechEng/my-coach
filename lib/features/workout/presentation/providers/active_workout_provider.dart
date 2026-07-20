import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../../../../core/services/local_store.dart';
import '../../data/pr_detector.dart';
import '../../data/workout_repository_impl.dart';
import '../../domain/models/completed_set.dart';
import '../../domain/models/exercise_log.dart';
import '../../domain/models/set_log.dart';
import '../../domain/models/workout_session.dart';
import '../../../programme/domain/models/exercise_prescription.dart';
import '../../../programme/domain/models/workout_day.dart';
import 'workout_history_provider.dart';

const _uuid = Uuid();

class ActiveWorkoutState {
  final WorkoutSession? session;
  final List<ExercisePrescription> exercises;
  final Map<String, List<SetLog>> setLogs;
  final int currentExerciseIndex;
  final int currentSetIndex;
  final bool isFinished;
  final List<String> prExerciseIds;
  final DateTime? sessionStart;

  const ActiveWorkoutState({
    this.session,
    this.exercises = const [],
    this.setLogs = const {},
    this.currentExerciseIndex = 0,
    this.currentSetIndex = 0,
    this.isFinished = false,
    this.prExerciseIds = const [],
    this.sessionStart,
  });

  bool get isActive => session != null && !isFinished;

  ExercisePrescription? get currentExercise =>
      exercises.isEmpty ? null : exercises[currentExerciseIndex];

  SetLog? get currentSetLog {
    final ex = currentExercise;
    if (ex == null) return null;
    final logs = setLogs[ex.exerciseId] ?? [];
    if (currentSetIndex >= logs.length) return null;
    return logs[currentSetIndex];
  }

  int completedSetsForExercise(String exerciseId) {
    return (setLogs[exerciseId] ?? []).where((s) => s.isDone).length;
  }

  ActiveWorkoutState copyWith({
    WorkoutSession? session,
    List<ExercisePrescription>? exercises,
    Map<String, List<SetLog>>? setLogs,
    int? currentExerciseIndex,
    int? currentSetIndex,
    bool? isFinished,
    List<String>? prExerciseIds,
    DateTime? sessionStart,
  }) {
    return ActiveWorkoutState(
      session: session ?? this.session,
      exercises: exercises ?? this.exercises,
      setLogs: setLogs ?? this.setLogs,
      currentExerciseIndex: currentExerciseIndex ?? this.currentExerciseIndex,
      currentSetIndex: currentSetIndex ?? this.currentSetIndex,
      isFinished: isFinished ?? this.isFinished,
      prExerciseIds: prExerciseIds ?? this.prExerciseIds,
      sessionStart: sessionStart ?? this.sessionStart,
    );
  }
}

class ActiveWorkoutNotifier extends StateNotifier<ActiveWorkoutState> {
  final WorkoutRepository _workoutRepo;
  final PRDetector _prDetector;

  ActiveWorkoutNotifier(Ref ref)
      : _workoutRepo = ref.read(workoutRepositoryProvider),
        _prDetector = PRDetector(ref.read(localStoreProvider)),
        super(const ActiveWorkoutState());

  void startSession(WorkoutDay day, int blockNumber, int weekNumber) {
    final now = DateTime.now();
    final sessionId = _uuid.v4();

    final initialSetLogs = <String, List<SetLog>>{};
    for (final ex in day.exercises) {
      initialSetLogs[ex.exerciseId] = List.generate(
        ex.sets,
        (i) => SetLog(exerciseId: ex.exerciseId, setNumber: i + 1),
      );
    }

    final session = WorkoutSession(
      id: sessionId,
      startTime: now,
      sessionType: day.sessionType,
      blockNumber: blockNumber,
      weekNumber: weekNumber,
      dayOfWeek: day.dayOfWeek,
      status: SessionStatus.inProgress,
      exerciseLogs: [],
    );

    state = ActiveWorkoutState(
      session: session,
      exercises: List.from(day.exercises),
      setLogs: initialSetLogs,
      sessionStart: now,
    );

    _workoutRepo.saveSession('local', session);
  }

  void completeSet({
    required String exerciseId,
    required int reps,
    required double weight,
    double? rpe,
  }) {
    final logs = Map<String, List<SetLog>>.from(state.setLogs);
    final exerciseLogs = List<SetLog>.from(logs[exerciseId] ?? []);

    if (state.currentSetIndex < exerciseLogs.length) {
      exerciseLogs[state.currentSetIndex] = exerciseLogs[state.currentSetIndex].copyWith(
        reps: reps,
        weightKg: weight,
        rpe: rpe,
        status: SetStatus.completed,
      );
    }

    logs[exerciseId] = exerciseLogs;
    state = state.copyWith(setLogs: logs);
    _advanceSet(exerciseId);
  }

  /// Marks the current set done for time-based work (cardio) — no weight/reps,
  /// so it contributes no volume and is excluded from PR detection.
  void completeTimeBasedSet(String exerciseId) {
    final logs = Map<String, List<SetLog>>.from(state.setLogs);
    final exerciseLogs = List<SetLog>.from(logs[exerciseId] ?? []);

    if (state.currentSetIndex < exerciseLogs.length) {
      exerciseLogs[state.currentSetIndex] = exerciseLogs[state.currentSetIndex].copyWith(
        status: SetStatus.completed,
      );
    }

    logs[exerciseId] = exerciseLogs;
    state = state.copyWith(setLogs: logs);
    _advanceSet(exerciseId);
  }

  void skipSet(String exerciseId) {
    final logs = Map<String, List<SetLog>>.from(state.setLogs);
    final exerciseLogs = List<SetLog>.from(logs[exerciseId] ?? []);

    if (state.currentSetIndex < exerciseLogs.length) {
      exerciseLogs[state.currentSetIndex] = exerciseLogs[state.currentSetIndex].copyWith(
        status: SetStatus.skipped,
      );
    }

    logs[exerciseId] = exerciseLogs;
    state = state.copyWith(setLogs: logs);
    _advanceSet(exerciseId);
  }

  void _advanceSet(String exerciseId) {
    final ex = state.currentExercise;
    if (ex == null) return;

    final nextSet = state.currentSetIndex + 1;
    if (nextSet < ex.sets) {
      state = state.copyWith(currentSetIndex: nextSet);
    } else {
      goToNextExercise();
    }
  }

  void goToNextExercise() {
    final nextEx = state.currentExerciseIndex + 1;
    if (nextEx < state.exercises.length) {
      state = state.copyWith(
        currentExerciseIndex: nextEx,
        currentSetIndex: 0,
      );
    }
  }

  void goToPreviousExercise() {
    if (state.currentExerciseIndex > 0) {
      state = state.copyWith(
        currentExerciseIndex: state.currentExerciseIndex - 1,
        currentSetIndex: 0,
      );
    }
  }

  Future<WorkoutSession?> finishSession({int? energyLevel}) async {
    if (state.session == null) return null;

    final endTime = DateTime.now();
    final duration = endTime.difference(state.sessionStart!).inSeconds;

    final exerciseLogs = <ExerciseLog>[];
    for (final ex in state.exercises) {
      final logs = state.setLogs[ex.exerciseId] ?? [];
      final completedSets = logs
          .where((l) => l.isCompleted && l.reps != null && l.weightKg != null)
          .map((l) => CompletedSet(
                setNumber: l.setNumber,
                repsCompleted: l.reps!,
                weightKg: l.weightKg!,
                rpe: l.rpe,
                completedAt: endTime,
              ))
          .toList();

      if (completedSets.isNotEmpty) {
        exerciseLogs.add(ExerciseLog(
          exerciseId: ex.exerciseId,
          exerciseName: ex.exerciseName,
          orderIndex: ex.orderIndex,
          sets: completedSets,
        ));
      }
    }

    final totalVolume = exerciseLogs.fold(0.0, (sum, el) => sum + el.totalVolume);

    final finishedSession = WorkoutSession(
      id: state.session!.id,
      startTime: state.session!.startTime,
      endTime: endTime,
      sessionType: state.session!.sessionType,
      blockNumber: state.session!.blockNumber,
      weekNumber: state.session!.weekNumber,
      dayOfWeek: state.session!.dayOfWeek,
      status: SessionStatus.completed,
      exerciseLogs: exerciseLogs,
      energyLevel: energyLevel,
      durationSeconds: duration,
      totalVolume: totalVolume,
    );

    await _workoutRepo.saveSession('local', finishedSession);
    final prIds = await _prDetector.detectAndSavePRs(
      'local',
      finishedSession.id,
      exerciseLogs,
    );

    state = state.copyWith(
      session: finishedSession,
      isFinished: true,
      prExerciseIds: prIds,
    );

    return finishedSession;
  }

  void reset() {
    state = const ActiveWorkoutState();
  }
}

final activeWorkoutProvider =
    StateNotifierProvider<ActiveWorkoutNotifier, ActiveWorkoutState>(
  (ref) => ActiveWorkoutNotifier(ref),
);
