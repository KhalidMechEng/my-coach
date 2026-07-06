enum SetStatus { pending, inProgress, completed, skipped }

class SetLog {
  final String exerciseId;
  final int setNumber;
  final int? reps;
  final double? weightKg;
  final double? rpe;
  final SetStatus status;

  const SetLog({
    required this.exerciseId,
    required this.setNumber,
    this.reps,
    this.weightKg,
    this.rpe,
    this.status = SetStatus.pending,
  });

  SetLog copyWith({
    int? reps,
    double? weightKg,
    double? rpe,
    SetStatus? status,
  }) {
    return SetLog(
      exerciseId: exerciseId,
      setNumber: setNumber,
      reps: reps ?? this.reps,
      weightKg: weightKg ?? this.weightKg,
      rpe: rpe ?? this.rpe,
      status: status ?? this.status,
    );
  }

  bool get isCompleted => status == SetStatus.completed;
  bool get isSkipped => status == SetStatus.skipped;
  bool get isDone => isCompleted || isSkipped;
}
