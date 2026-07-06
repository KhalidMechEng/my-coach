class ChartDataPoint {
  final DateTime date;
  final double value;
  const ChartDataPoint({required this.date, required this.value});
}

class ExerciseStats {
  final String exerciseId;
  final String exerciseName;
  final double bestWeight;
  final int maxReps;
  final double totalVolume;
  final double estimatedOneRepMax;
  final List<ChartDataPoint> weightHistory;
  final List<ChartDataPoint> weeklyVolumeHistory;
  final int totalSets;
  final int totalSessions;

  const ExerciseStats({
    required this.exerciseId,
    required this.exerciseName,
    this.bestWeight = 0,
    this.maxReps = 0,
    this.totalVolume = 0,
    this.estimatedOneRepMax = 0,
    this.weightHistory = const [],
    this.weeklyVolumeHistory = const [],
    this.totalSets = 0,
    this.totalSessions = 0,
  });

  bool get hasData => totalSessions > 0;
}
