class VolumeCalculator {
  VolumeCalculator._();

  /// Epley formula: estimated 1-rep max from a given weight × reps.
  static double estimatedOneRepMax(double weight, int reps) {
    if (reps <= 0 || weight <= 0) return 0;
    if (reps == 1) return weight;
    return weight * (1 + reps / 30);
  }

  /// Total volume for a set: weight × reps.
  static double setVolume(double weight, int reps) => weight * reps;

  /// Total volume for all sets.
  static double sessionVolume(List<({double weight, int reps})> sets) {
    return sets.fold(0.0, (sum, s) => sum + setVolume(s.weight, s.reps));
  }

  /// Format a volume number for display (e.g. 1250.0 → "1,250 kg").
  static String formatVolume(double volume, {String unit = 'kg'}) {
    final int rounded = volume.round();
    final String formatted = rounded.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (m) => '${m[1]},',
    );
    return '$formatted $unit';
  }

  /// Format duration seconds into "1h 23m" or "45m".
  static String formatDuration(int seconds) {
    final h = seconds ~/ 3600;
    final m = (seconds % 3600) ~/ 60;
    if (h > 0) return '${h}h ${m}m';
    return '${m}m';
  }
}
