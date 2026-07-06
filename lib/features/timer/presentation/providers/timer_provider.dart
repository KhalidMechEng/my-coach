import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vibration/vibration.dart';

// ─── Rest Timer ───────────────────────────────────────────────────────────────

class RestTimerState {
  final int totalSeconds;
  final int remainingSeconds;
  final bool isRunning;
  final bool isFinished;

  const RestTimerState({
    this.totalSeconds = 0,
    this.remainingSeconds = 0,
    this.isRunning = false,
    this.isFinished = false,
  });

  double get progress =>
      totalSeconds == 0 ? 0 : 1 - (remainingSeconds / totalSeconds);

  String get displayTime {
    final m = remainingSeconds ~/ 60;
    final s = remainingSeconds % 60;
    return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }
}

class RestTimerNotifier extends StateNotifier<RestTimerState> {
  Timer? _timer;

  RestTimerNotifier() : super(const RestTimerState());

  void start(int seconds) {
    _timer?.cancel();
    state = RestTimerState(
      totalSeconds: seconds,
      remainingSeconds: seconds,
      isRunning: true,
    );
    _tick();
  }

  void _tick() {
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (state.remainingSeconds <= 1) {
        t.cancel();
        state = state.copyWith(remainingSeconds: 0, isRunning: false, isFinished: true);
        _vibrate();
      } else {
        state = state.copyWith(remainingSeconds: state.remainingSeconds - 1);
      }
    });
  }

  void skip() {
    _timer?.cancel();
    state = const RestTimerState(isFinished: true);
  }

  void reset() {
    _timer?.cancel();
    state = const RestTimerState();
  }

  Future<void> _vibrate() async {
    if (await Vibration.hasVibrator() ?? false) {
      Vibration.vibrate(pattern: [0, 200, 100, 200]);
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}

extension _RestTimerStateCopyWith on RestTimerState {
  RestTimerState copyWith({int? remainingSeconds, bool? isRunning, bool? isFinished}) {
    return RestTimerState(
      totalSeconds: totalSeconds,
      remainingSeconds: remainingSeconds ?? this.remainingSeconds,
      isRunning: isRunning ?? this.isRunning,
      isFinished: isFinished ?? this.isFinished,
    );
  }
}

final restTimerProvider = StateNotifierProvider<RestTimerNotifier, RestTimerState>(
  (_) => RestTimerNotifier(),
);

// ─── Session Timer ────────────────────────────────────────────────────────────

class SessionTimerNotifier extends StateNotifier<Duration> {
  Timer? _timer;

  SessionTimerNotifier() : super(Duration.zero);

  void start() {
    _timer?.cancel();
    state = Duration.zero;
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      state = state + const Duration(seconds: 1);
    });
  }

  void stop() {
    _timer?.cancel();
  }

  void reset() {
    _timer?.cancel();
    state = Duration.zero;
  }

  String get displayTime {
    final h = state.inHours;
    final m = state.inMinutes.remainder(60);
    final s = state.inSeconds.remainder(60);
    if (h > 0) {
      return '${h.toString().padLeft(2, '0')}:${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
    }
    return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}

final sessionTimerProvider = StateNotifierProvider<SessionTimerNotifier, Duration>(
  (_) => SessionTimerNotifier(),
);
