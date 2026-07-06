class ExercisePrescription {
  final String exerciseId;
  final String exerciseName;
  final int sets;
  final String repRange;
  final double targetRpe;
  final int restSeconds;
  final int orderIndex;
  final bool isBodyweight;

  const ExercisePrescription({
    required this.exerciseId,
    required this.exerciseName,
    required this.sets,
    required this.repRange,
    required this.targetRpe,
    required this.restSeconds,
    required this.orderIndex,
    this.isBodyweight = false,
  });

  String get rpeDisplay {
    if (targetRpe == targetRpe.roundToDouble()) {
      return 'RPE ${targetRpe.toInt()}';
    }
    return 'RPE $targetRpe';
  }

  String get prescriptionSummary => '$sets × $repRange @ $rpeDisplay';

  String get restDisplay {
    if (restSeconds >= 60) {
      final m = restSeconds ~/ 60;
      final s = restSeconds % 60;
      return s > 0 ? '${m}m ${s}s' : '${m}m';
    }
    return '${restSeconds}s';
  }
}
