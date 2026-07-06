import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/services/local_store.dart';

/// A single logged entry for one exercise in one week: the working weight the
/// user used and whether they ticked the exercise as done.
class WeekLogEntry {
  final double? weight;
  final bool done;
  const WeekLogEntry({this.weight, this.done = false});

  factory WeekLogEntry.fromMap(Map<String, dynamic> m) => WeekLogEntry(
        weight: (m['weight'] as num?)?.toDouble(),
        done: m['done'] == true,
      );

  Map<String, dynamic> toMap() => {'weight': weight, 'done': done};
}

/// Local, offline log keyed by weekNumber -> exerciseId -> entry.
class WeekLogNotifier extends StateNotifier<Map<int, Map<String, WeekLogEntry>>> {
  final LocalStore _store;
  static const _key = 'week_logs';

  WeekLogNotifier(this._store) : super(_read(_store));

  static Map<int, Map<String, WeekLogEntry>> _read(LocalStore store) {
    final raw = store.getJson(_key) ?? {};
    final out = <int, Map<String, WeekLogEntry>>{};
    raw.forEach((weekKey, exMap) {
      final week = int.tryParse(weekKey);
      if (week == null || exMap is! Map) return;
      final entries = <String, WeekLogEntry>{};
      exMap.forEach((exId, v) {
        if (v is Map) {
          entries[exId as String] = WeekLogEntry.fromMap(Map<String, dynamic>.from(v));
        }
      });
      out[week] = entries;
    });
    return out;
  }

  WeekLogEntry entry(int week, String exerciseId) =>
      state[week]?[exerciseId] ?? const WeekLogEntry();

  int completedCount(int week, List<String> exerciseIds) =>
      exerciseIds.where((id) => entry(week, id).done).length;

  Future<void> _persist() async {
    final raw = <String, dynamic>{};
    state.forEach((week, entries) {
      raw['$week'] = {for (final e in entries.entries) e.key: e.value.toMap()};
    });
    await _store.setJson(_key, raw);
  }

  Future<void> setWeight(int week, String exerciseId, double? weight) async {
    final weekMap = Map<String, WeekLogEntry>.from(state[week] ?? {});
    final prev = weekMap[exerciseId] ?? const WeekLogEntry();
    weekMap[exerciseId] = WeekLogEntry(weight: weight, done: prev.done);
    state = {...state, week: weekMap};
    await _persist();
  }

  Future<void> setDone(int week, String exerciseId, bool done) async {
    final weekMap = Map<String, WeekLogEntry>.from(state[week] ?? {});
    final prev = weekMap[exerciseId] ?? const WeekLogEntry();
    weekMap[exerciseId] = WeekLogEntry(weight: prev.weight, done: done);
    state = {...state, week: weekMap};
    await _persist();
  }
}

final weekLogProvider =
    StateNotifierProvider<WeekLogNotifier, Map<int, Map<String, WeekLogEntry>>>(
  (ref) => WeekLogNotifier(ref.watch(localStoreProvider)),
);
