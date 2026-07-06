import 'dart:convert';
import 'package:flutter/services.dart';
import '../domain/models/exercise.dart';

/// Loads exercises from the bundled local JSON asset. Fully offline —
/// no Firebase / network dependency.
class ExerciseRepository {
  final Map<String, Exercise> _cache = {};
  List<Exercise>? _all;

  Future<Map<String, dynamic>> _loadRaw() async {
    final json = await rootBundle.loadString('assets/data/exercises_fallback.json');
    return jsonDecode(json) as Map<String, dynamic>;
  }

  Future<Exercise?> getExercise(String exerciseId) async {
    if (_cache.containsKey(exerciseId)) return _cache[exerciseId];
    try {
      final data = await _loadRaw();
      if (data.containsKey(exerciseId)) {
        final exercise = Exercise.fromMap(exerciseId, data[exerciseId] as Map<String, dynamic>);
        _cache[exerciseId] = exercise;
        return exercise;
      }
    } catch (_) {}
    return null;
  }

  Future<List<Exercise>> getExercises(List<String> ids) async {
    final results = <Exercise>[];
    for (final id in ids) {
      final ex = await getExercise(id);
      if (ex != null) results.add(ex);
    }
    return results;
  }

  /// Every exercise in the library, sorted by (localised) name at the call site.
  Future<List<Exercise>> getAllExercises() async {
    if (_all != null) return _all!;
    final data = await _loadRaw();
    final list = data.entries
        .map((e) => Exercise.fromMap(e.key, e.value as Map<String, dynamic>))
        .toList();
    for (final ex in list) {
      _cache[ex.id] = ex;
    }
    _all = list;
    return list;
  }
}
