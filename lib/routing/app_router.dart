import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../features/calendar/presentation/screens/calendar_screen.dart';
import '../features/dashboard/presentation/screens/dashboard_screen.dart';
import '../features/exercise/presentation/screens/exercise_detail_screen.dart';
import '../features/exercise/presentation/screens/exercise_library_screen.dart';
import '../features/performance/presentation/screens/exercise_trend_screen.dart';
import '../features/performance/presentation/screens/performance_dashboard_screen.dart';
import '../features/programme/presentation/screens/programme_overview_screen.dart';
import '../features/programme/presentation/screens/week_detail_screen.dart';
import '../features/settings/presentation/screens/settings_screen.dart';
import '../features/workout/presentation/screens/guided_workout_screen.dart';
import '../features/workout/presentation/screens/workout_history_screen.dart';
import '../features/workout/presentation/screens/workout_summary_screen.dart';
import '../shared/widgets/main_shell.dart';
import 'route_names.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'root');
final _shellNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'shell');

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    debugLogDiagnostics: false,
    initialLocation: '/',
    routes: [
      // ── Shell (5-tab bottom nav) ──────────────────────────────────────────
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) =>
            MainShell(navigationShell: navigationShell),
        branches: [
          StatefulShellBranch(
            navigatorKey: _shellNavigatorKey,
            routes: [
              GoRoute(
                path: '/',
                name: RouteNames.home,
                builder: (context, state) => const DashboardScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/programme',
                name: RouteNames.programme,
                builder: (context, state) => const ProgrammeOverviewScreen(),
                routes: [
                  GoRoute(
                    path: 'week/:weekNumber',
                    name: RouteNames.weekDetail,
                    builder: (context, state) {
                      final week = int.tryParse(
                            state.pathParameters['weekNumber'] ?? '1',
                          ) ??
                          1;
                      return WeekDetailScreen(weekNumber: week);
                    },
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/library',
                name: RouteNames.library,
                builder: (context, state) => const ExerciseLibraryScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/performance',
                name: RouteNames.performance,
                builder: (context, state) =>
                    const PerformanceDashboardScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/calendar',
                name: RouteNames.calendar,
                builder: (context, state) => const CalendarScreen(),
              ),
            ],
          ),
        ],
      ),

      // ── Settings (full-screen) ────────────────────────────────────────────
      GoRoute(
        path: '/settings',
        name: RouteNames.settings,
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const SettingsScreen(),
      ),

      // ── Workout (full-screen) ─────────────────────────────────────────────
      GoRoute(
        path: '/workout/active',
        name: RouteNames.workoutActive,
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const GuidedWorkoutScreen(),
      ),
      GoRoute(
        path: '/workout/summary',
        name: RouteNames.workoutSummary,
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) {
          final sessionId = state.extra as String? ?? '';
          return WorkoutSummaryScreen(sessionId: sessionId);
        },
      ),
      GoRoute(
        path: '/workout/history',
        name: RouteNames.workoutHistory,
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const WorkoutHistoryScreen(),
      ),

      // ── Exercise detail (full-screen) ────────────────────────────────────
      GoRoute(
        path: '/exercise/:exerciseId',
        name: RouteNames.exerciseDetail,
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) {
          final id = state.pathParameters['exerciseId'] ?? '';
          return ExerciseDetailScreen(exerciseId: id);
        },
      ),

      // ── Performance → Exercise trend (full-screen) ───────────────────────
      GoRoute(
        path: '/performance/exercise',
        name: RouteNames.exerciseTrend,
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>?;
          return ExerciseTrendScreen(
            exerciseId: extra?['id'] as String? ?? '',
            exerciseName: extra?['name'] as String? ?? '',
          );
        },
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('404', style: TextStyle(fontSize: 48, fontWeight: FontWeight.w800)),
            Text(state.error?.message ?? 'Page not found'),
            TextButton(onPressed: () => context.go('/'), child: const Text('Go home')),
          ],
        ),
      ),
    ),
  );
});
