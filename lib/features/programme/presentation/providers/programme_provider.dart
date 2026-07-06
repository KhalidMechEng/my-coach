import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/providers/profile_provider.dart';
import '../../../../data/programme/programme_data.dart';
import '../../domain/models/programme_block.dart';
import '../../domain/models/workout_day.dart';

final programmeProvider = Provider<List<ProgrammeBlock>>((_) => kProgramme);

final currentBlockProvider = Provider<ProgrammeBlock>((ref) {
  final block = ref.watch(profileProvider).currentBlock;
  return kProgramme.firstWhere(
    (b) => b.blockNumber == block,
    orElse: () => kProgramme.first,
  );
});

final currentWeekProvider = Provider<int>((ref) {
  return ref.watch(profileProvider).currentWeek;
});

final todaysWorkoutProvider = Provider<WorkoutDay?>((ref) {
  final block = ref.watch(currentBlockProvider);
  final weekday = DateTime.now().weekdayKey;
  return block.dayFor(weekday);
});

extension _DateTimeWeekday on DateTime {
  String get weekdayKey {
    const keys = ['monday', 'tuesday', 'wednesday', 'thursday', 'friday', 'saturday', 'sunday'];
    return keys[weekday - 1];
  }
}
