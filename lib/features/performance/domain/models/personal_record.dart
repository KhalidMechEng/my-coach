enum PRType { weight, reps, volume, estimatedOneRepMax }

class PersonalRecord {
  final String id;
  final String exerciseId;
  final String exerciseName;
  final PRType type;
  final double value;
  final double? previousValue;
  final DateTime achievedAt;
  final String workoutSessionId;

  const PersonalRecord({
    required this.id,
    required this.exerciseId,
    required this.exerciseName,
    required this.type,
    required this.value,
    this.previousValue,
    required this.achievedAt,
    required this.workoutSessionId,
  });

  String get typeLabel {
    switch (type) {
      case PRType.weight:
        return 'Best Weight';
      case PRType.reps:
        return 'Max Reps';
      case PRType.volume:
        return 'Total Volume';
      case PRType.estimatedOneRepMax:
        return 'Est. 1RM';
    }
  }

  String displayValue({String unit = 'kg'}) {
    switch (type) {
      case PRType.weight:
      case PRType.estimatedOneRepMax:
      case PRType.volume:
        return '${value.toStringAsFixed(value == value.roundToDouble() ? 0 : 1)} $unit';
      case PRType.reps:
        return '${value.toInt()} reps';
    }
  }

  factory PersonalRecord.fromMap(String id, Map<String, dynamic> map) {
    return PersonalRecord(
      id: id,
      exerciseId: map['exerciseId'] as String,
      exerciseName: map['exerciseName'] as String,
      type: PRType.values.firstWhere((e) => e.name == map['type']),
      value: (map['value'] as num).toDouble(),
      previousValue: (map['previousValue'] as num?)?.toDouble(),
      achievedAt: DateTime.parse(map['achievedAt'] as String),
      workoutSessionId: map['workoutSessionId'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'exerciseId': exerciseId,
      'exerciseName': exerciseName,
      'type': type.name,
      'value': value,
      if (previousValue != null) 'previousValue': previousValue,
      'achievedAt': achievedAt.toIso8601String(),
      'workoutSessionId': workoutSessionId,
    };
  }
}
