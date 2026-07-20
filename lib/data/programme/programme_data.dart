import '../../features/programme/domain/models/exercise_prescription.dart';
import '../../features/programme/domain/models/workout_day.dart';
import '../../features/programme/domain/models/programme_block.dart';

// ─────────────────────────────────────────────────────────────────────────────
// KHALID'S UPPER / LOWER SPLIT  —  Sun–Thu
// Sun  Upper A (Chest)   ·  Mon  Lower A (Quad)
// Tue  Upper B (Back)    ·  Wed  Lower B (Hamstring)   ·  Thu  Cardio only
// Rest: Friday & Saturday
// Working sets @ RPE ~8. Rest times are sensible defaults (not on the card).
// Source of truth — never generated, never modified by the app.
// ─────────────────────────────────────────────────────────────────────────────

const List<ProgrammeBlock> kProgramme = [
  ProgrammeBlock(
    blockNumber: 1,
    name: 'Upper / Lower Split',
    startWeek: 1,
    endWeek: 12,
    focusDescription:
        'Sun Upper A (chest) · Mon Lower A (quad) · Tue Upper B (back) · Wed Lower B (hamstring) · Thu Cardio. Rest Fri & Sat.',
    rpeRange: '~8',
    workoutDays: [
      // ─── SUN — UPPER A (Chest focused) ─────────────────────────────────────
      WorkoutDay(
        dayOfWeek: 'sunday',
        sessionType: 'upper_a',
        sessionLabel: 'Upper A — Chest',
        exercises: [
          ExercisePrescription(exerciseId: 'incline_db_press',  exerciseName: 'Incline Bench Press (Smith / DB)', sets: 2, repRange: '5–8',  targetRpe: 8.0, restSeconds: 150, orderIndex: 0),
          ExercisePrescription(exerciseId: 'lat_pulldown_bar',  exerciseName: 'Lat Pulldown',                     sets: 2, repRange: '5–8',  targetRpe: 8.0, restSeconds: 120, orderIndex: 1),
          ExercisePrescription(exerciseId: 'pec_dec',           exerciseName: 'Pec Deck Fly',                     sets: 2, repRange: '5–8',  targetRpe: 8.0, restSeconds: 90,  orderIndex: 2),
          ExercisePrescription(exerciseId: 'rear_delt_fly',     exerciseName: 'Rear Deltoid Fly',                 sets: 3, repRange: '8–10', targetRpe: 8.0, restSeconds: 90,  orderIndex: 3),
          ExercisePrescription(exerciseId: 'tricep_pushdown',   exerciseName: 'Tricep Extension',                 sets: 2, repRange: '8–10', targetRpe: 8.0, restSeconds: 90,  orderIndex: 4),
          ExercisePrescription(exerciseId: 'barbell_curl',      exerciseName: 'Bicep Curl',                       sets: 2, repRange: '8–10', targetRpe: 8.0, restSeconds: 90,  orderIndex: 5),
        ],
      ),
      // ─── MON — LOWER A (Quad focused) ──────────────────────────────────────
      WorkoutDay(
        dayOfWeek: 'monday',
        sessionType: 'lower_a',
        sessionLabel: 'Lower A — Quad',
        exercises: [
          ExercisePrescription(exerciseId: 'back_squat',          exerciseName: 'Squat (Machine or Free Weight)', sets: 2, repRange: '5–8',  targetRpe: 8.0, restSeconds: 180, orderIndex: 0),
          ExercisePrescription(exerciseId: 'seated_leg_curl',     exerciseName: 'Hamstring / Leg Curl',           sets: 2, repRange: '5–8',  targetRpe: 8.0, restSeconds: 120, orderIndex: 1),
          ExercisePrescription(exerciseId: 'leg_extension',       exerciseName: 'Leg Extension',                  sets: 2, repRange: '5–8',  targetRpe: 8.0, restSeconds: 120, orderIndex: 2),
          ExercisePrescription(exerciseId: 'hip_thrust',          exerciseName: 'Hip Thrust',                     sets: 2, repRange: '5–8',  targetRpe: 8.0, restSeconds: 150, orderIndex: 3),
          ExercisePrescription(exerciseId: 'standing_calf_raise', exerciseName: 'Calf Raise',                     sets: 2, repRange: '8–10', targetRpe: 8.0, restSeconds: 90,  orderIndex: 4),
          ExercisePrescription(exerciseId: 'cable_crunch',        exerciseName: 'Decline Abs Crunch (Weighted or Not)', sets: 3, repRange: '10', targetRpe: 8.0, restSeconds: 90, orderIndex: 5),
        ],
      ),
      // ─── TUE — UPPER B (Back focused) ──────────────────────────────────────
      WorkoutDay(
        dayOfWeek: 'tuesday',
        sessionType: 'upper_b',
        sessionLabel: 'Upper B — Back',
        exercises: [
          ExercisePrescription(exerciseId: 'chest_supported_row', exerciseName: 'Chest Supported Row',           sets: 2, repRange: '5–8',  targetRpe: 8.0, restSeconds: 150, orderIndex: 0),
          ExercisePrescription(exerciseId: 'seated_db_ohp',       exerciseName: 'Shoulder Press',                sets: 2, repRange: '5–8',  targetRpe: 8.0, restSeconds: 150, orderIndex: 1),
          ExercisePrescription(exerciseId: 'lat_pulldown_bar',    exerciseName: 'Lat Pulldown',                  sets: 2, repRange: '5–8',  targetRpe: 8.0, restSeconds: 120, orderIndex: 2),
          ExercisePrescription(exerciseId: 'lateral_raise_db',    exerciseName: 'Lateral Raise',                 sets: 3, repRange: '8–10', targetRpe: 8.0, restSeconds: 90,  orderIndex: 3),
          ExercisePrescription(exerciseId: 'barbell_curl',        exerciseName: 'Bicep Curl',                    sets: 2, repRange: '5–8',  targetRpe: 8.0, restSeconds: 90,  orderIndex: 4),
          ExercisePrescription(exerciseId: 'tricep_pushdown',     exerciseName: 'Tricep Extension',              sets: 2, repRange: '5–8',  targetRpe: 8.0, restSeconds: 90,  orderIndex: 5),
        ],
      ),
      // ─── WED — LOWER B (Hamstring focused) ─────────────────────────────────
      WorkoutDay(
        dayOfWeek: 'wednesday',
        sessionType: 'lower_b',
        sessionLabel: 'Lower B — Hamstring',
        exercises: [
          ExercisePrescription(exerciseId: 'romanian_deadlift',   exerciseName: 'Romanian Deadlift (RDL)',       sets: 2, repRange: '5–8',  targetRpe: 8.0, restSeconds: 180, orderIndex: 0),
          ExercisePrescription(exerciseId: 'leg_extension',       exerciseName: 'Leg Extension',                 sets: 2, repRange: '5–8',  targetRpe: 8.0, restSeconds: 120, orderIndex: 1),
          ExercisePrescription(exerciseId: 'seated_leg_curl',     exerciseName: 'Hamstring / Leg Curl',          sets: 2, repRange: '5–8',  targetRpe: 8.0, restSeconds: 120, orderIndex: 2),
          ExercisePrescription(exerciseId: 'hip_thrust',          exerciseName: 'Hip Thrust',                    sets: 2, repRange: '5–8',  targetRpe: 8.0, restSeconds: 150, orderIndex: 3),
          ExercisePrescription(exerciseId: 'standing_calf_raise', exerciseName: 'Calf Raise',                    sets: 2, repRange: '8–10', targetRpe: 8.0, restSeconds: 90,  orderIndex: 4),
          ExercisePrescription(exerciseId: 'cable_crunch',        exerciseName: 'Decline Abs Crunch (Weighted or Not)', sets: 3, repRange: '10', targetRpe: 8.0, restSeconds: 90, orderIndex: 5),
        ],
      ),
      // ─── THU — CARDIO ONLY ─────────────────────────────────────────────────
      WorkoutDay(
        dayOfWeek: 'thursday',
        sessionType: 'cardio',
        sessionLabel: 'Cardio',
        exercises: [
          ExercisePrescription(exerciseId: 'cardio_session', exerciseName: 'Steady-State Cardio', sets: 1, repRange: '25–40 min', targetRpe: 6.0, restSeconds: 0, orderIndex: 0, isBodyweight: true),
        ],
      ),
    ],
  ),
];

// ─────────────────────────────────────────────────────────────────────────────
// Helpers
// ─────────────────────────────────────────────────────────────────────────────

/// Returns the block for a given week number (1–12).
ProgrammeBlock blockForWeek(int week) {
  return kProgramme.firstWhere(
    (b) => week >= b.startWeek && week <= b.endWeek,
    orElse: () => kProgramme.last,
  );
}

/// Returns the workout day for a given weekday key within a block.
/// Returns null for rest days (Wed, Sat, Sun).
WorkoutDay? workoutDayFor(ProgrammeBlock block, String weekdayKey) {
  try {
    return block.workoutDays.firstWhere((d) => d.dayOfWeek == weekdayKey);
  } catch (_) {
    return null;
  }
}

/// All unique exercise IDs across the full programme.
Set<String> get allExerciseIds =>
    kProgramme.expand((b) => b.workoutDays).expand((d) => d.exercises).map((e) => e.exerciseId).toSet();
