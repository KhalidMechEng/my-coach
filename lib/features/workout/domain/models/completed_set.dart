class CompletedSet {
  final int setNumber;
  final int repsCompleted;
  final double weightKg;
  final double? rpe;
  final bool isPr;
  final DateTime completedAt;

  const CompletedSet({
    required this.setNumber,
    required this.repsCompleted,
    required this.weightKg,
    this.rpe,
    this.isPr = false,
    required this.completedAt,
  });

  double get volume => weightKg * repsCompleted;

  CompletedSet copyWith({bool? isPr}) {
    return CompletedSet(
      setNumber: setNumber,
      repsCompleted: repsCompleted,
      weightKg: weightKg,
      rpe: rpe,
      isPr: isPr ?? this.isPr,
      completedAt: completedAt,
    );
  }

  factory CompletedSet.fromMap(Map<String, dynamic> map) {
    return CompletedSet(
      setNumber: (map['setNumber'] as num).toInt(),
      repsCompleted: (map['repsCompleted'] as num).toInt(),
      weightKg: (map['weightKg'] as num).toDouble(),
      rpe: (map['rpe'] as num?)?.toDouble(),
      isPr: map['isPr'] as bool? ?? false,
      completedAt: DateTime.parse(map['completedAt'] as String),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'setNumber': setNumber,
      'repsCompleted': repsCompleted,
      'weightKg': weightKg,
      if (rpe != null) 'rpe': rpe,
      'isPr': isPr,
      'completedAt': completedAt.toIso8601String(),
    };
  }
}
