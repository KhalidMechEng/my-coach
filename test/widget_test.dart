import 'package:flutter_test/flutter_test.dart';
import 'package:my_coach/features/exercise/domain/models/exercise.dart';

void main() {
  test('Exercise parses from map with localised fields', () {
    final e = Exercise.fromMap('bench_press', {
      'name': 'Barbell Bench Press',
      'nameAr': 'ضغط البار',
      'primaryMuscleGroup': 'Chest',
      'primaryMuscleGroupAr': 'الصدر',
      'gifUrl': 'https://example.com/a.gif',
      'category': 'push_horizontal',
      'status': 'yes',
    });
    expect(e.name, 'Barbell Bench Press');
    // Exercise names stay in English even in Arabic mode.
    expect(e.localizedName(true), 'Barbell Bench Press');
    expect(e.localizedPrimaryMuscle(true), 'الصدر');
    expect(e.gifUrl, isNotNull);
    expect(e.isSubstitute, isFalse);
  });
}
