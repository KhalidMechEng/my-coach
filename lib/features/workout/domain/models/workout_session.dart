import 'exercise_log.dart';

enum SessionStatus { inProgress, completed, skipped }

class WorkoutSession {
  final String id;
  final DateTime startTime;
  final DateTime? endTime;
  final String sessionType;
  final int blockNumber;
  final int weekNumber;
  final String dayOfWeek;
  final SessionStatus status;
  final List<ExerciseLog> exerciseLogs;
  final int? energyLevel;
  final int? durationSeconds;
  final double? totalVolume;

  const WorkoutSession({
    required this.id,
    required this.startTime,
    this.endTime,
    required this.sessionType,
    required this.blockNumber,
    required this.weekNumber,
    required this.dayOfWeek,
    required this.status,
    required this.exerciseLogs,
    this.energyLevel,
    this.durationSeconds,
    this.totalVolume,
  });

  String get sessionLabel {
    const labels = {
      'upper': 'Upper Body',
      'lower': 'Lower Body',
      'push': 'Push',
      'pull': 'Pull',
      'legs': 'Legs',
    };
    return labels[sessionType] ?? sessionType;
  }

  bool get isCompleted => status == SessionStatus.completed;

  WorkoutSession copyWith({SessionStatus? status, int? durationSeconds, double? totalVolume}) {
    return WorkoutSession(
      id: id,
      startTime: startTime,
      endTime: endTime,
      sessionType: sessionType,
      blockNumber: blockNumber,
      weekNumber: weekNumber,
      dayOfWeek: dayOfWeek,
      status: status ?? this.status,
      exerciseLogs: exerciseLogs,
      energyLevel: energyLevel,
      durationSeconds: durationSeconds ?? this.durationSeconds,
      totalVolume: totalVolume ?? this.totalVolume,
    );
  }

  factory WorkoutSession.fromMap(String id, Map<String, dynamic> map) {
    return WorkoutSession(
      id: id,
      startTime: DateTime.parse(map['startTime'] as String),
      endTime: map['endTime'] != null ? DateTime.parse(map['endTime'] as String) : null,
      sessionType: map['sessionType'] as String,
      blockNumber: (map['blockNumber'] as num).toInt(),
      weekNumber: (map['weekNumber'] as num).toInt(),
      dayOfWeek: map['dayOfWeek'] as String,
      status: SessionStatus.values.firstWhere(
        (e) => e.name == map['status'],
        orElse: () => SessionStatus.completed,
      ),
      exerciseLogs: (map['exerciseLogs'] as List<dynamic>)
          .map((e) => ExerciseLog.fromMap(e as Map<String, dynamic>))
          .toList(),
      energyLevel: (map['energyLevel'] as num?)?.toInt(),
      durationSeconds: (map['durationSeconds'] as num?)?.toInt(),
      totalVolume: (map['totalVolume'] as num?)?.toDouble(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'startTime': startTime.toIso8601String(),
      if (endTime != null) 'endTime': endTime!.toIso8601String(),
      'sessionType': sessionType,
      'blockNumber': blockNumber,
      'weekNumber': weekNumber,
      'dayOfWeek': dayOfWeek,
      'status': status.name,
      'exerciseLogs': exerciseLogs.map((e) => e.toMap()).toList(),
      if (energyLevel != null) 'energyLevel': energyLevel,
      if (durationSeconds != null) 'durationSeconds': durationSeconds,
      if (totalVolume != null) 'totalVolume': totalVolume,
    };
  }
}
