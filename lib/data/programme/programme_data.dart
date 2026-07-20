import '../../features/programme/domain/models/exercise_prescription.dart';
import '../../features/programme/domain/models/workout_day.dart';
import '../../features/programme/domain/models/programme_block.dart';

// ─────────────────────────────────────────────────────────────────────────────
// KHALID'S UPPER / LOWER SPLIT  —  4 training days / week
// Mon  Upper A (Chest)   ·  Tue  Lower A (Quad)
// Thu  Upper B (Back)    ·  Fri  Lower B (Hamstring)
// Rest: Wednesday, Saturday & Sunday
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
        'Upper A (chest) · Lower A (quad) · Upper B (back) · Lower B (hamstring). Rest Wed, Sat & Sun.',
    rpeRange: '~8',
    workoutDays: [
      // ─── MON — UPPER A (Chest focused) ─────────────────────────────────────
      WorkoutDay(
        dayOfWeek: 'monday',
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
      // ─── TUE — LOWER A (Quad focused) ──────────────────────────────────────
      WorkoutDay(
        dayOfWeek: 'tuesday',
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
      // ─── THU — UPPER B (Back focused) ──────────────────────────────────────
      WorkoutDay(
        dayOfWeek: 'thursday',
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
      // ─── FRI — LOWER B (Hamstring focused) ─────────────────────────────────
      WorkoutDay(
        dayOfWeek: 'friday',
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
