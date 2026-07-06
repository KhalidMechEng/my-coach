import 'dart:async';
import '../../../core/services/local_store.dart';
import '../domain/models/workout_session.dart';

/// On-device workout history. Sessions are stored as a JSON list in
/// SharedPreferences (replaced Firestore). The [userId] argument is kept for
/// call-site compatibility but ignored — this is a single-user local app.
class WorkoutRepository {
  final LocalStore _store;
  static const _key = 'workout_sessions';

  final _controller = StreamController<List<WorkoutSession>>.broadcast();
  List<WorkoutSession>? _cache;

  WorkoutRepository(this._store);

  List<WorkoutSession> _load() {
    if (_cache != null) return _cache!;
    final raw = _store.getJsonList(_key);
    final list = <WorkoutSession>[];
    for (final m in raw) {
      try {
        list.add(WorkoutSession.fromMap(m['id'] as String, m));
      } catch (_) {}
    }
    list.sort((a, b) => b.startTime.compareTo(a.startTime));
    _cache = list;
    return list;
  }

  Future<void> _persist() async {
    final list = _cache ?? [];
    await _store.setJsonList(
      _key,
      list.map((s) => {...s.toMap(), 'id': s.id}).toList(),
    );
    _controller.add(List.of(list));
  }

  Future<void> saveSession(String userId, WorkoutSession session) async {
    final list = _load();
    list.removeWhere((s) => s.id == session.id);
    list.insert(0, session);
    list.sort((a, b) => b.startTime.compareTo(a.startTime));
    await _persist();
  }

  Future<void> updateSession(String userId, WorkoutSession session) =>
      saveSession(userId, session);

  Stream<List<WorkoutSession>> watchHistory(String userId) async* {
    yield _load();
    yield* _controller.stream;
  }

  Future<List<WorkoutSession>> getHistory(String userId) async => _load();

  Future<WorkoutSession?> getSessionById(String userId, String sessionId) async {
    final matches = _load().where((s) => s.id == sessionId);
    return matches.isEmpty ? null : matches.first;
  }

  Future<WorkoutSession?> getSessionForDate(String userId, DateTime date) async {
    final matches = _load().where((s) =>
        s.startTime.year == date.year &&
        s.startTime.month == date.month &&
        s.startTime.day == date.day);
    return matches.isEmpty ? null : matches.first;
  }
}
