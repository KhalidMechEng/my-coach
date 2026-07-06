import '../../features/programme/domain/models/exercise_prescription.dart';
import '../../features/programme/domain/models/workout_day.dart';
import '../../features/programme/domain/models/programme_block.dart';

// ─────────────────────────────────────────────────────────────────────────────
// KHALID'S 12-WEEK BLOCK PERIODISATION PROGRAMME
// Upper / Lower / Push / Pull / Legs  |  Mon – Fri
// Source of truth — never generated, never modified by the app.
// ─────────────────────────────────────────────────────────────────────────────

const List<ProgrammeBlock> kProgramme = [
  // ──────────────────────────────────────────────────────────────────────────
  // BLOCK 1  |  Weeks 1–4  |  Volume / Accumulation  |  RPE 7–8
  // ──────────────────────────────────────────────────────────────────────────
  ProgrammeBlock(
    blockNumber: 1,
    name: 'Accumulation',
    startWeek: 1,
    endWeek: 4,
    focusDescription: 'Build work capacity. Higher reps, more sets. Week 1 = calibration.',
    rpeRange: '7–8',
    workoutDays: [
      // MON — UPPER
      WorkoutDay(
        dayOfWeek: 'monday',
        sessionType: 'upper',
        sessionLabel: 'Upper Body',
        exercises: [
          ExercisePrescription(exerciseId: 'bench_press',       exerciseName: 'Barbell Bench Press',         sets: 4, repRange: '6',     targetRpe: 8.0, restSeconds: 180, orderIndex: 0),
          ExercisePrescription(exerciseId: 'bent_over_row',     exerciseName: 'Barbell Bent-Over Row',       sets: 4, repRange: '8',     targetRpe: 7.5, restSeconds: 150, orderIndex: 1),
          ExercisePrescription(exerciseId: 'incline_db_press',  exerciseName: 'Incline DB Press',            sets: 3, repRange: '10',    targetRpe: 7.5, restSeconds: 120, orderIndex: 2),
          ExercisePrescription(exerciseId: 'lat_pulldown_neutral', exerciseName: 'Lat Pulldown (Neutral Grip)', sets: 3, repRange: '12', targetRpe: 7.5, restSeconds: 120, orderIndex: 3),
          ExercisePrescription(exerciseId: 'lateral_raise_db',  exerciseName: 'Lateral Raise (DB)',          sets: 3, repRange: '15',    targetRpe: 7.0, restSeconds: 90,  orderIndex: 4),
          ExercisePrescription(exerciseId: 'barbell_curl',      exerciseName: 'Barbell Curl',                sets: 3, repRange: '10',    targetRpe: 7.5, restSeconds: 90,  orderIndex: 5),
        ],
      ),
      // TUE — LOWER
      WorkoutDay(
        dayOfWeek: 'tuesday',
        sessionType: 'lower',
        sessionLabel: 'Lower Body',
        exercises: [
          ExercisePrescription(exerciseId: 'back_squat',        exerciseName: 'Barbell Back Squat',          sets: 4, repRange: '6',     targetRpe: 8.0, restSeconds: 240, orderIndex: 0),
          ExercisePrescription(exerciseId: 'romanian_deadlift', exerciseName: 'Romanian Deadlift',           sets: 3, repRange: '8',     targetRpe: 7.5, restSeconds: 180, orderIndex: 1),
          ExercisePrescription(exerciseId: 'leg_press',         exerciseName: 'Leg Press',                   sets: 3, repRange: '12',    targetRpe: 7.5, restSeconds: 120, orderIndex: 2),
          ExercisePrescription(exerciseId: 'seated_leg_curl',   exerciseName: 'Seated Leg Curl',             sets: 3, repRange: '12',    targetRpe: 7.5, restSeconds: 90,  orderIndex: 3),
          ExercisePrescription(exerciseId: 'standing_calf_raise', exerciseName: 'Standing Calf Raise',      sets: 4, repRange: '12',    targetRpe: 7.5, restSeconds: 90,  orderIndex: 4),
          ExercisePrescription(exerciseId: 'hanging_leg_raise', exerciseName: 'Hanging Leg Raise',          sets: 3, repRange: '12',    targetRpe: 7.0, restSeconds: 90,  orderIndex: 5, isBodyweight: true),
        ],
      ),
      // WED — PUSH
      WorkoutDay(
        dayOfWeek: 'wednesday',
        sessionType: 'push',
        sessionLabel: 'Push',
        exercises: [
          ExercisePrescription(exerciseId: 'incline_barbell_press', exerciseName: 'Incline Barbell Press',  sets: 4, repRange: '8',     targetRpe: 7.5, restSeconds: 180, orderIndex: 0),
          ExercisePrescription(exerciseId: 'seated_db_ohp',      exerciseName: 'Seated DB Overhead Press',  sets: 3, repRange: '10',    targetRpe: 7.5, restSeconds: 150, orderIndex: 1),
          ExercisePrescription(exerciseId: 'machine_chest_press', exerciseName: 'Machine Chest Press',     sets: 3, repRange: '12',    targetRpe: 7.5, restSeconds: 120, orderIndex: 2),
          ExercisePrescription(exerciseId: 'lateral_raise_cable', exerciseName: 'Lateral Raise (Cable)',   sets: 3, repRange: '15',    targetRpe: 7.5, restSeconds: 90,  orderIndex: 3),
          ExercisePrescription(exerciseId: 'tricep_pushdown',    exerciseName: 'Tricep Pushdown',           sets: 3, repRange: '12',    targetRpe: 7.5, restSeconds: 90,  orderIndex: 4),
          ExercisePrescription(exerciseId: 'overhead_tricep_ext', exerciseName: 'Overhead Tricep Extension (Cable)', sets: 3, repRange: '12', targetRpe: 7.5, restSeconds: 90, orderIndex: 5),
        ],
      ),
      // THU — PULL
      WorkoutDay(
        dayOfWeek: 'thursday',
        sessionType: 'pull',
        sessionLabel: 'Pull',
        exercises: [
          ExercisePrescription(exerciseId: 'pull_up',            exerciseName: 'Pull-Up (Bodyweight)',       sets: 4, repRange: '6–8',   targetRpe: 8.0, restSeconds: 180, orderIndex: 0, isBodyweight: true),
          ExercisePrescription(exerciseId: 'seated_cable_row',   exerciseName: 'Seated Cable Row',           sets: 4, repRange: '10',    targetRpe: 7.5, restSeconds: 150, orderIndex: 1),
          ExercisePrescription(exerciseId: 'lat_pulldown_bar',   exerciseName: 'Lat Pulldown (Bar)',         sets: 3, repRange: '12',    targetRpe: 7.5, restSeconds: 120, orderIndex: 2),
          ExercisePrescription(exerciseId: 'rear_delt_fly',      exerciseName: 'Rear Delt Fly (Machine)',    sets: 3, repRange: '15',    targetRpe: 7.5, restSeconds: 90,  orderIndex: 3),
          ExercisePrescription(exerciseId: 'incline_db_curl',    exerciseName: 'Incline DB Curl',            sets: 3, repRange: '10',    targetRpe: 7.5, restSeconds: 90,  orderIndex: 4),
          ExercisePrescription(exerciseId: 'hammer_curl',        exerciseName: 'Hammer Curl',                sets: 3, repRange: '12',    targetRpe: 7.0, restSeconds: 90,  orderIndex: 5),
        ],
      ),
      // FRI — LEGS
      WorkoutDay(
        dayOfWeek: 'friday',
        sessionType: 'legs',
        sessionLabel: 'Legs',
        exercises: [
          ExercisePrescription(exerciseId: 'hack_squat',         exerciseName: 'Hack Squat',                 sets: 4, repRange: '8',     targetRpe: 7.5, restSeconds: 180, orderIndex: 0),
          ExercisePrescription(exerciseId: 'stiff_leg_deadlift', exerciseName: 'Stiff Leg Deadlift',         sets: 3, repRange: '10',    targetRpe: 7.5, restSeconds: 180, orderIndex: 1),
          ExercisePrescription(exerciseId: 'hip_thrust',         exerciseName: 'Barbell Hip Thrust',         sets: 3, repRange: '10',    targetRpe: 7.5, restSeconds: 150, orderIndex: 2),
          ExercisePrescription(exerciseId: 'bulgarian_split_squat', exerciseName: 'Bulgarian Split Squat',  sets: 3, repRange: '10',    targetRpe: 7.5, restSeconds: 150, orderIndex: 3),
          ExercisePrescription(exerciseId: 'leg_extension',      exerciseName: 'Leg Extension',              sets: 3, repRange: '15',    targetRpe: 7.5, restSeconds: 90,  orderIndex: 4),
          ExercisePrescription(exerciseId: 'seated_calf_raise',  exerciseName: 'Seated Calf Raise',          sets: 4, repRange: '15',    targetRpe: 7.5, restSeconds: 90,  orderIndex: 5),
        ],
      ),
    ],
  ),

  // ──────────────────────────────────────────────────────────────────────────
  // BLOCK 2  |  Weeks 5–8  |  Intensity  |  RPE 8–9
  // ──────────────────────────────────────────────────────────────────────────
  ProgrammeBlock(
    blockNumber: 2,
    name: 'Intensity',
    startWeek: 5,
    endWeek: 8,
    focusDescription: 'Reps drop, load climbs. Volume trims to fund heavier work.',
    rpeRange: '8–9',
    workoutDays: [
      // MON — UPPER
      WorkoutDay(
        dayOfWeek: 'monday',
        sessionType: 'upper',
        sessionLabel: 'Upper Body',
        exercises: [
          ExercisePrescription(exerciseId: 'bench_press',       exerciseName: 'Barbell Bench Press',         sets: 5, repRange: '4',     targetRpe: 8.5, restSeconds: 240, orderIndex: 0),
          ExercisePrescription(exerciseId: 'bent_over_row',     exerciseName: 'Barbell Bent-Over Row',       sets: 4, repRange: '6',     targetRpe: 8.0, restSeconds: 180, orderIndex: 1),
          ExercisePrescription(exerciseId: 'incline_db_press',  exerciseName: 'Incline DB Press',            sets: 3, repRange: '8',     targetRpe: 8.0, restSeconds: 150, orderIndex: 2),
          ExercisePrescription(exerciseId: 'lat_pulldown_neutral', exerciseName: 'Lat Pulldown (Neutral Grip)', sets: 3, repRange: '10', targetRpe: 8.0, restSeconds: 120, orderIndex: 3),
          ExercisePrescription(exerciseId: 'lateral_raise_db',  exerciseName: 'Lateral Raise (DB)',          sets: 3, repRange: '12',    targetRpe: 8.0, restSeconds: 90,  orderIndex: 4),
          ExercisePrescription(exerciseId: 'barbell_curl',      exerciseName: 'Barbell Curl',                sets: 3, repRange: '8',     targetRpe: 8.0, restSeconds: 90,  orderIndex: 5),
        ],
      ),
      // TUE — LOWER
      WorkoutDay(
        dayOfWeek: 'tuesday',
        sessionType: 'lower',
        sessionLabel: 'Lower Body',
        exercises: [
          ExercisePrescription(exerciseId: 'back_squat',        exerciseName: 'Barbell Back Squat',          sets: 5, repRange: '4',     targetRpe: 8.5, restSeconds: 300, orderIndex: 0),
          ExercisePrescription(exerciseId: 'romanian_deadlift', exerciseName: 'Romanian Deadlift',           sets: 4, repRange: '6',     targetRpe: 8.0, restSeconds: 210, orderIndex: 1),
          ExercisePrescription(exerciseId: 'leg_press',         exerciseName: 'Leg Press',                   sets: 3, repRange: '10',    targetRpe: 8.0, restSeconds: 150, orderIndex: 2),
          ExercisePrescription(exerciseId: 'seated_leg_curl',   exerciseName: 'Seated Leg Curl',             sets: 3, repRange: '10',    targetRpe: 8.0, restSeconds: 120, orderIndex: 3),
          ExercisePrescription(exerciseId: 'standing_calf_raise', exerciseName: 'Standing Calf Raise',      sets: 4, repRange: '10',    targetRpe: 8.0, restSeconds: 90,  orderIndex: 4),
          ExercisePrescription(exerciseId: 'hanging_leg_raise', exerciseName: 'Hanging Leg Raise',          sets: 3, repRange: '12',    targetRpe: 8.0, restSeconds: 90,  orderIndex: 5, isBodyweight: true),
        ],
      ),
      // WED — PUSH
      WorkoutDay(
        dayOfWeek: 'wednesday',
        sessionType: 'push',
        sessionLabel: 'Push',
        exercises: [
          ExercisePrescription(exerciseId: 'incline_barbell_press', exerciseName: 'Incline Barbell Press',  sets: 4, repRange: '5',     targetRpe: 8.5, restSeconds: 240, orderIndex: 0),
          ExercisePrescription(exerciseId: 'seated_db_ohp',      exerciseName: 'Seated DB Overhead Press',  sets: 4, repRange: '8',     targetRpe: 8.0, restSeconds: 180, orderIndex: 1),
          ExercisePrescription(exerciseId: 'machine_chest_press', exerciseName: 'Machine Chest Press',     sets: 3, repRange: '10',    targetRpe: 8.0, restSeconds: 150, orderIndex: 2),
          ExercisePrescription(exerciseId: 'lateral_raise_cable', exerciseName: 'Lateral Raise (Cable)',   sets: 3, repRange: '12',    targetRpe: 8.0, restSeconds: 90,  orderIndex: 3),
          ExercisePrescription(exerciseId: 'tricep_pushdown',    exerciseName: 'Tricep Pushdown',           sets: 3, repRange: '10',    targetRpe: 8.0, restSeconds: 90,  orderIndex: 4),
          ExercisePrescription(exerciseId: 'overhead_tricep_ext', exerciseName: 'Overhead Tricep Extension (Cable)', sets: 3, repRange: '10', targetRpe: 8.0, restSeconds: 90, orderIndex: 5),
        ],
      ),
      // THU — PULL
      WorkoutDay(
        dayOfWeek: 'thursday',
        sessionType: 'pull',
        sessionLabel: 'Pull',
        exercises: [
          ExercisePrescription(exerciseId: 'pull_up',            exerciseName: 'Pull-Up (Bodyweight)',       sets: 5, repRange: '6–8',   targetRpe: 8.5, restSeconds: 210, orderIndex: 0, isBodyweight: true),
          ExercisePrescription(exerciseId: 'seated_cable_row',   exerciseName: 'Seated Cable Row',           sets: 4, repRange: '8',     targetRpe: 8.0, restSeconds: 180, orderIndex: 1),
          ExercisePrescription(exerciseId: 'lat_pulldown_bar',   exerciseName: 'Lat Pulldown (Bar)',         sets: 3, repRange: '10',    targetRpe: 8.0, restSeconds: 150, orderIndex: 2),
          ExercisePrescription(exerciseId: 'rear_delt_fly',      exerciseName: 'Rear Delt Fly (Machine)',    sets: 3, repRange: '12',    targetRpe: 8.0, restSeconds: 90,  orderIndex: 3),
          ExercisePrescription(exerciseId: 'incline_db_curl',    exerciseName: 'Incline DB Curl',            sets: 3, repRange: '8',     targetRpe: 8.0, restSeconds: 90,  orderIndex: 4),
          ExercisePrescription(exerciseId: 'hammer_curl',        exerciseName: 'Hammer Curl',                sets: 3, repRange: '10',    targetRpe: 8.0, restSeconds: 90,  orderIndex: 5),
        ],
      ),
      // FRI — LEGS
      WorkoutDay(
        dayOfWeek: 'friday',
        sessionType: 'legs',
        sessionLabel: 'Legs',
        exercises: [
          ExercisePrescription(exerciseId: 'hack_squat',         exerciseName: 'Hack Squat',                 sets: 4, repRange: '6',     targetRpe: 8.0, restSeconds: 210, orderIndex: 0),
          ExercisePrescription(exerciseId: 'stiff_leg_deadlift', exerciseName: 'Stiff Leg Deadlift',         sets: 4, repRange: '8',     targetRpe: 8.0, restSeconds: 210, orderIndex: 1),
          ExercisePrescription(exerciseId: 'hip_thrust',         exerciseName: 'Barbell Hip Thrust',         sets: 4, repRange: '8',     targetRpe: 8.0, restSeconds: 180, orderIndex: 2),
          ExercisePrescription(exerciseId: 'bulgarian_split_squat', exerciseName: 'Bulgarian Split Squat',  sets: 3, repRange: '8',     targetRpe: 8.0, restSeconds: 180, orderIndex: 3),
          ExercisePrescription(exerciseId: 'leg_extension',      exerciseName: 'Leg Extension',              sets: 3, repRange: '12',    targetRpe: 8.0, restSeconds: 90,  orderIndex: 4),
          ExercisePrescription(exerciseId: 'seated_calf_raise',  exerciseName: 'Seated Calf Raise',          sets: 4, repRange: '12',    targetRpe: 8.0, restSeconds: 90,  orderIndex: 5),
        ],
      ),
    ],
  ),

  // ──────────────────────────────────────────────────────────────────────────
  // BLOCK 3  |  Weeks 9–11  |  Peak Strength  |  RPE 9–9.5
  // ──────────────────────────────────────────────────────────────────────────
  ProgrammeBlock(
    blockNumber: 3,
    name: 'Peak Strength',
    startWeek: 9,
    endWeek: 11,
    focusDescription: 'Heaviest loads, lowest reps. Express top-end strength.',
    rpeRange: '9–9.5',
    workoutDays: [
      // MON — UPPER
      WorkoutDay(
        dayOfWeek: 'monday',
        sessionType: 'upper',
        sessionLabel: 'Upper Body',
        exercises: [
          ExercisePrescription(exerciseId: 'bench_press',       exerciseName: 'Barbell Bench Press',         sets: 4, repRange: '3',     targetRpe: 9.0, restSeconds: 300, orderIndex: 0),
          ExercisePrescription(exerciseId: 'bent_over_row',     exerciseName: 'Barbell Bent-Over Row',       sets: 4, repRange: '5',     targetRpe: 8.5, restSeconds: 210, orderIndex: 1),
          ExercisePrescription(exerciseId: 'incline_db_press',  exerciseName: 'Incline DB Press',            sets: 3, repRange: '6',     targetRpe: 8.5, restSeconds: 180, orderIndex: 2),
          ExercisePrescription(exerciseId: 'lat_pulldown_neutral', exerciseName: 'Lat Pulldown (Neutral Grip)', sets: 3, repRange: '8', targetRpe: 8.0, restSeconds: 150, orderIndex: 3),
          ExercisePrescription(exerciseId: 'lateral_raise_db',  exerciseName: 'Lateral Raise (DB)',          sets: 3, repRange: '12',    targetRpe: 8.0, restSeconds: 90,  orderIndex: 4),
          ExercisePrescription(exerciseId: 'barbell_curl',      exerciseName: 'Barbell Curl',                sets: 3, repRange: '8',     targetRpe: 8.0, restSeconds: 90,  orderIndex: 5),
        ],
      ),
      // TUE — LOWER
      WorkoutDay(
        dayOfWeek: 'tuesday',
        sessionType: 'lower',
        sessionLabel: 'Lower Body',
        exercises: [
          ExercisePrescription(exerciseId: 'back_squat',        exerciseName: 'Barbell Back Squat',          sets: 4, repRange: '3',     targetRpe: 9.0, restSeconds: 360, orderIndex: 0),
          ExercisePrescription(exerciseId: 'romanian_deadlift', exerciseName: 'Romanian Deadlift',           sets: 4, repRange: '5',     targetRpe: 8.5, restSeconds: 240, orderIndex: 1),
          ExercisePrescription(exerciseId: 'leg_press',         exerciseName: 'Leg Press',                   sets: 3, repRange: '8',     targetRpe: 8.0, restSeconds: 180, orderIndex: 2),
          ExercisePrescription(exerciseId: 'seated_leg_curl',   exerciseName: 'Seated Leg Curl',             sets: 3, repRange: '8',     targetRpe: 8.0, restSeconds: 150, orderIndex: 3),
          ExercisePrescription(exerciseId: 'standing_calf_raise', exerciseName: 'Standing Calf Raise',      sets: 4, repRange: '10',    targetRpe: 8.0, restSeconds: 90,  orderIndex: 4),
          ExercisePrescription(exerciseId: 'hanging_leg_raise', exerciseName: 'Hanging Leg Raise',          sets: 3, repRange: '12',    targetRpe: 8.0, restSeconds: 90,  orderIndex: 5, isBodyweight: true),
        ],
      ),
      // WED — PUSH
      WorkoutDay(
        dayOfWeek: 'wednesday',
        sessionType: 'push',
        sessionLabel: 'Push',
        exercises: [
          ExercisePrescription(exerciseId: 'incline_barbell_press', exerciseName: 'Incline Barbell Press',  sets: 4, repRange: '4',     targetRpe: 9.0, restSeconds: 300, orderIndex: 0),
          ExercisePrescription(exerciseId: 'seated_db_ohp',      exerciseName: 'Seated DB Overhead Press',  sets: 4, repRange: '6',     targetRpe: 8.5, restSeconds: 210, orderIndex: 1),
          ExercisePrescription(exerciseId: 'machine_chest_press', exerciseName: 'Machine Chest Press',     sets: 3, repRange: '8',     targetRpe: 8.0, restSeconds: 180, orderIndex: 2),
          ExercisePrescription(exerciseId: 'lateral_raise_cable', exerciseName: 'Lateral Raise (Cable)',   sets: 3, repRange: '12',    targetRpe: 8.0, restSeconds: 90,  orderIndex: 3),
          ExercisePrescription(exerciseId: 'tricep_pushdown',    exerciseName: 'Tricep Pushdown',           sets: 3, repRange: '8',     targetRpe: 8.0, restSeconds: 90,  orderIndex: 4),
          ExercisePrescription(exerciseId: 'overhead_tricep_ext', exerciseName: 'Overhead Tricep Extension (Cable)', sets: 3, repRange: '10', targetRpe: 8.0, restSeconds: 90, orderIndex: 5),
        ],
      ),
      // THU — PULL
      WorkoutDay(
        dayOfWeek: 'thursday',
        sessionType: 'pull',
        sessionLabel: 'Pull',
        exercises: [
          ExercisePrescription(exerciseId: 'pull_up',            exerciseName: 'Pull-Up (Bodyweight)',       sets: 5, repRange: '8–10',  targetRpe: 9.0, restSeconds: 240, orderIndex: 0, isBodyweight: true),
          ExercisePrescription(exerciseId: 'seated_cable_row',   exerciseName: 'Seated Cable Row',           sets: 4, repRange: '6',     targetRpe: 8.5, restSeconds: 210, orderIndex: 1),
          ExercisePrescription(exerciseId: 'lat_pulldown_bar',   exerciseName: 'Lat Pulldown (Bar)',         sets: 3, repRange: '8',     targetRpe: 8.0, restSeconds: 180, orderIndex: 2),
          ExercisePrescription(exerciseId: 'rear_delt_fly',      exerciseName: 'Rear Delt Fly (Machine)',    sets: 3, repRange: '12',    targetRpe: 8.0, restSeconds: 90,  orderIndex: 3),
          ExercisePrescription(exerciseId: 'incline_db_curl',    exerciseName: 'Incline DB Curl',            sets: 3, repRange: '8',     targetRpe: 8.0, restSeconds: 90,  orderIndex: 4),
          ExercisePrescription(exerciseId: 'hammer_curl',        exerciseName: 'Hammer Curl',                sets: 3, repRange: '10',    targetRpe: 8.0, restSeconds: 90,  orderIndex: 5),
        ],
      ),
      // FRI — LEGS
      WorkoutDay(
        dayOfWeek: 'friday',
        sessionType: 'legs',
        sessionLabel: 'Legs',
        exercises: [
          ExercisePrescription(exerciseId: 'hack_squat',         exerciseName: 'Hack Squat',                 sets: 4, repRange: '5',     targetRpe: 8.5, restSeconds: 240, orderIndex: 0),
          ExercisePrescription(exerciseId: 'stiff_leg_deadlift', exerciseName: 'Stiff Leg Deadlift',         sets: 4, repRange: '5',     targetRpe: 8.5, restSeconds: 240, orderIndex: 1),
          ExercisePrescription(exerciseId: 'hip_thrust',         exerciseName: 'Barbell Hip Thrust',         sets: 4, repRange: '6',     targetRpe: 8.5, restSeconds: 210, orderIndex: 2),
          ExercisePrescription(exerciseId: 'bulgarian_split_squat', exerciseName: 'Bulgarian Split Squat',  sets: 3, repRange: '8',     targetRpe: 8.0, restSeconds: 180, orderIndex: 3),
          ExercisePrescription(exerciseId: 'leg_extension',      exerciseName: 'Leg Extension',              sets: 3, repRange: '10',    targetRpe: 8.0, restSeconds: 90,  orderIndex: 4),
          ExercisePrescription(exerciseId: 'seated_calf_raise',  exerciseName: 'Seated Calf Raise',          sets: 4, repRange: '12',    targetRpe: 8.0, restSeconds: 90,  orderIndex: 5),
        ],
      ),
    ],
  ),

  // ──────────────────────────────────────────────────────────────────────────
  // BLOCK 4 (DELOAD)  |  Week 12  |  Recovery  |  RPE ~6
  // ──────────────────────────────────────────────────────────────────────────
  ProgrammeBlock(
    blockNumber: 4,
    name: 'Deload',
    startWeek: 12,
    endWeek: 12,
    focusDescription: 'Cut volume + intensity. Reset for the next cycle.',
    rpeRange: '~6',
    workoutDays: [
      // MON — UPPER
      WorkoutDay(
        dayOfWeek: 'monday',
        sessionType: 'upper',
        sessionLabel: 'Upper Body',
        exercises: [
          ExercisePrescription(exerciseId: 'bench_press',       exerciseName: 'Barbell Bench Press',         sets: 3, repRange: '5',     targetRpe: 6.0, restSeconds: 180, orderIndex: 0),
          ExercisePrescription(exerciseId: 'bent_over_row',     exerciseName: 'Barbell Bent-Over Row',       sets: 3, repRange: '6',     targetRpe: 6.0, restSeconds: 150, orderIndex: 1),
          ExercisePrescription(exerciseId: 'incline_db_press',  exerciseName: 'Incline DB Press',            sets: 2, repRange: '8',     targetRpe: 6.0, restSeconds: 120, orderIndex: 2),
          ExercisePrescription(exerciseId: 'lat_pulldown_neutral', exerciseName: 'Lat Pulldown (Neutral Grip)', sets: 2, repRange: '10', targetRpe: 6.0, restSeconds: 120, orderIndex: 3),
          ExercisePrescription(exerciseId: 'lateral_raise_db',  exerciseName: 'Lateral Raise (DB)',          sets: 2, repRange: '12',    targetRpe: 6.0, restSeconds: 90,  orderIndex: 4),
          ExercisePrescription(exerciseId: 'barbell_curl',      exerciseName: 'Barbell Curl',                sets: 2, repRange: '10',    targetRpe: 6.0, restSeconds: 90,  orderIndex: 5),
        ],
      ),
      // TUE — LOWER
      WorkoutDay(
        dayOfWeek: 'tuesday',
        sessionType: 'lower',
        sessionLabel: 'Lower Body',
        exercises: [
          ExercisePrescription(exerciseId: 'back_squat',        exerciseName: 'Barbell Back Squat',          sets: 3, repRange: '5',     targetRpe: 6.0, restSeconds: 240, orderIndex: 0),
          ExercisePrescription(exerciseId: 'romanian_deadlift', exerciseName: 'Romanian Deadlift',           sets: 2, repRange: '6',     targetRpe: 6.0, restSeconds: 180, orderIndex: 1),
          ExercisePrescription(exerciseId: 'leg_press',         exerciseName: 'Leg Press',                   sets: 2, repRange: '10',    targetRpe: 6.0, restSeconds: 120, orderIndex: 2),
          ExercisePrescription(exerciseId: 'seated_leg_curl',   exerciseName: 'Seated Leg Curl',             sets: 2, repRange: '10',    targetRpe: 6.0, restSeconds: 90,  orderIndex: 3),
          ExercisePrescription(exerciseId: 'standing_calf_raise', exerciseName: 'Standing Calf Raise',      sets: 2, repRange: '12',    targetRpe: 6.0, restSeconds: 90,  orderIndex: 4),
          ExercisePrescription(exerciseId: 'hanging_leg_raise', exerciseName: 'Hanging Leg Raise',          sets: 2, repRange: '12',    targetRpe: 6.0, restSeconds: 90,  orderIndex: 5, isBodyweight: true),
        ],
      ),
      // WED — PUSH
      WorkoutDay(
        dayOfWeek: 'wednesday',
        sessionType: 'push',
        sessionLabel: 'Push',
        exercises: [
          ExercisePrescription(exerciseId: 'incline_barbell_press', exerciseName: 'Incline Barbell Press',  sets: 3, repRange: '6',     targetRpe: 6.0, restSeconds: 180, orderIndex: 0),
          ExercisePrescription(exerciseId: 'seated_db_ohp',      exerciseName: 'Seated DB Overhead Press',  sets: 2, repRange: '8',     targetRpe: 6.0, restSeconds: 150, orderIndex: 1),
          ExercisePrescription(exerciseId: 'machine_chest_press', exerciseName: 'Machine Chest Press',     sets: 2, repRange: '10',    targetRpe: 6.0, restSeconds: 120, orderIndex: 2),
          ExercisePrescription(exerciseId: 'lateral_raise_cable', exerciseName: 'Lateral Raise (Cable)',   sets: 2, repRange: '12',    targetRpe: 6.0, restSeconds: 90,  orderIndex: 3),
          ExercisePrescription(exerciseId: 'tricep_pushdown',    exerciseName: 'Tricep Pushdown',           sets: 2, repRange: '10',    targetRpe: 6.0, restSeconds: 90,  orderIndex: 4),
          ExercisePrescription(exerciseId: 'overhead_tricep_ext', exerciseName: 'Overhead Tricep Extension (Cable)', sets: 2, repRange: '10', targetRpe: 6.0, restSeconds: 90, orderIndex: 5),
        ],
      ),
      // THU — PULL
      WorkoutDay(
        dayOfWeek: 'thursday',
        sessionType: 'pull',
        sessionLabel: 'Pull',
        exercises: [
          ExercisePrescription(exerciseId: 'pull_up',            exerciseName: 'Pull-Up (Bodyweight)',       sets: 3, repRange: '6',     targetRpe: 6.0, restSeconds: 180, orderIndex: 0, isBodyweight: true),
          ExercisePrescription(exerciseId: 'seated_cable_row',   exerciseName: 'Seated Cable Row',           sets: 2, repRange: '8',     targetRpe: 6.0, restSeconds: 150, orderIndex: 1),
          ExercisePrescription(exerciseId: 'lat_pulldown_bar',   exerciseName: 'Lat Pulldown (Bar)',         sets: 2, repRange: '10',    targetRpe: 6.0, restSeconds: 120, orderIndex: 2),
          ExercisePrescription(exerciseId: 'rear_delt_fly',      exerciseName: 'Rear Delt Fly (Machine)',    sets: 2, repRange: '12',    targetRpe: 6.0, restSeconds: 90,  orderIndex: 3),
          ExercisePrescription(exerciseId: 'incline_db_curl',    exerciseName: 'Incline DB Curl',            sets: 2, repRange: '10',    targetRpe: 6.0, restSeconds: 90,  orderIndex: 4),
          ExercisePrescription(exerciseId: 'hammer_curl',        exerciseName: 'Hammer Curl',                sets: 2, repRange: '10',    targetRpe: 6.0, restSeconds: 90,  orderIndex: 5),
        ],
      ),
      // FRI — LEGS
      WorkoutDay(
        dayOfWeek: 'friday',
        sessionType: 'legs',
        sessionLabel: 'Legs',
        exercises: [
          ExercisePrescription(exerciseId: 'hack_squat',         exerciseName: 'Hack Squat',                 sets: 3, repRange: '6',     targetRpe: 6.0, restSeconds: 180, orderIndex: 0),
          ExercisePrescription(exerciseId: 'stiff_leg_deadlift', exerciseName: 'Stiff Leg Deadlift',         sets: 2, repRange: '8',     targetRpe: 6.0, restSeconds: 150, orderIndex: 1),
          ExercisePrescription(exerciseId: 'hip_thrust',         exerciseName: 'Barbell Hip Thrust',         sets: 2, repRange: '8',     targetRpe: 6.0, restSeconds: 150, orderIndex: 2),
          ExercisePrescription(exerciseId: 'bulgarian_split_squat', exerciseName: 'Bulgarian Split Squat',  sets: 2, repRange: '8',     targetRpe: 6.0, restSeconds: 150, orderIndex: 3),
          ExercisePrescription(exerciseId: 'leg_extension',      exerciseName: 'Leg Extension',              sets: 2, repRange: '12',    targetRpe: 6.0, restSeconds: 90,  orderIndex: 4),
          ExercisePrescription(exerciseId: 'seated_calf_raise',  exerciseName: 'Seated Calf Raise',          sets: 2, repRange: '12',    targetRpe: 6.0, restSeconds: 90,  orderIndex: 5),
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
/// Returns null for weekends.
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
