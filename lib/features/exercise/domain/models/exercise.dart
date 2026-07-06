class Exercise {
  final String id;
  final String name;
  final String nameAr;
  final String primaryMuscleGroup;
  final String primaryMuscleGroupAr;
  final List<String> secondaryMuscleGroups;
  final List<String> secondaryMuscleGroupsAr;
  final List<String> equipment;
  final List<String> equipmentAr;
  final String? youtubeVideoId;
  final String? gifUrl;
  final String? thumbnailUrl;
  final List<String> stepByStepInstructions;
  final List<String> stepByStepInstructionsAr;
  final List<String> commonMistakes;
  final List<String> commonMistakesAr;
  final String breathingCue;
  final String breathingCueAr;
  final String safetyNote;
  final String safetyNoteAr;
  final String difficulty;

  /// Muscle-group category from the athlete's exercise library
  /// (e.g. 'push_horizontal', 'lower_quad', 'arms').
  final String category;

  /// Availability from the athlete's library: 'yes' (preferred) or 'sub'
  /// (can do but prefers a substitute).
  final String status;

  const Exercise({
    required this.id,
    required this.name,
    this.nameAr = '',
    required this.primaryMuscleGroup,
    this.primaryMuscleGroupAr = '',
    this.secondaryMuscleGroups = const [],
    this.secondaryMuscleGroupsAr = const [],
    this.equipment = const [],
    this.equipmentAr = const [],
    this.youtubeVideoId,
    this.gifUrl,
    this.thumbnailUrl,
    this.stepByStepInstructions = const [],
    this.stepByStepInstructionsAr = const [],
    this.commonMistakes = const [],
    this.commonMistakesAr = const [],
    this.breathingCue = '',
    this.breathingCueAr = '',
    this.safetyNote = '',
    this.safetyNoteAr = '',
    this.difficulty = 'intermediate',
    this.category = '',
    this.status = 'yes',
  });

  bool get isSubstitute => status == 'sub';

  String get youtubeUrl =>
      youtubeVideoId != null ? 'https://www.youtube.com/watch?v=$youtubeVideoId' : '';

  String get youtubeThumbnailUrl => youtubeVideoId != null
      ? 'https://img.youtube.com/vi/$youtubeVideoId/hqdefault.jpg'
      : '';

  // ── Localised accessors ────────────────────────────────────────────────────
  // Exercise NAMES stay in English by request; other content is localised.
  String localizedName(bool ar) => name;

  String localizedPrimaryMuscle(bool ar) =>
      ar && primaryMuscleGroupAr.isNotEmpty ? primaryMuscleGroupAr : primaryMuscleGroup;

  List<String> localizedSecondaryMuscles(bool ar) =>
      ar && secondaryMuscleGroupsAr.isNotEmpty ? secondaryMuscleGroupsAr : secondaryMuscleGroups;

  List<String> localizedEquipment(bool ar) =>
      ar && equipmentAr.isNotEmpty ? equipmentAr : equipment;

  List<String> localizedInstructions(bool ar) =>
      ar && stepByStepInstructionsAr.isNotEmpty ? stepByStepInstructionsAr : stepByStepInstructions;

  List<String> localizedMistakes(bool ar) =>
      ar && commonMistakesAr.isNotEmpty ? commonMistakesAr : commonMistakes;

  String localizedBreathing(bool ar) =>
      ar && breathingCueAr.isNotEmpty ? breathingCueAr : breathingCue;

  String localizedSafety(bool ar) =>
      ar && safetyNoteAr.isNotEmpty ? safetyNoteAr : safetyNote;

  factory Exercise.fromMap(String id, Map<String, dynamic> map) {
    return Exercise(
      id: id,
      name: map['name'] as String? ?? '',
      nameAr: map['nameAr'] as String? ?? '',
      primaryMuscleGroup: map['primaryMuscleGroup'] as String? ?? '',
      primaryMuscleGroupAr: map['primaryMuscleGroupAr'] as String? ?? '',
      secondaryMuscleGroups: List<String>.from(map['secondaryMuscleGroups'] ?? []),
      secondaryMuscleGroupsAr: List<String>.from(map['secondaryMuscleGroupsAr'] ?? []),
      equipment: List<String>.from(map['equipment'] ?? []),
      equipmentAr: List<String>.from(map['equipmentAr'] ?? []),
      youtubeVideoId: map['youtubeVideoId'] as String?,
      gifUrl: map['gifUrl'] as String?,
      thumbnailUrl: map['thumbnailUrl'] as String?,
      stepByStepInstructions: List<String>.from(map['stepByStepInstructions'] ?? []),
      stepByStepInstructionsAr: List<String>.from(map['stepByStepInstructionsAr'] ?? []),
      commonMistakes: List<String>.from(map['commonMistakes'] ?? []),
      commonMistakesAr: List<String>.from(map['commonMistakesAr'] ?? []),
      breathingCue: map['breathingCue'] as String? ?? '',
      breathingCueAr: map['breathingCueAr'] as String? ?? '',
      safetyNote: map['safetyNote'] as String? ?? '',
      safetyNoteAr: map['safetyNoteAr'] as String? ?? '',
      difficulty: map['difficulty'] as String? ?? 'intermediate',
      category: map['category'] as String? ?? '',
      status: map['status'] as String? ?? 'yes',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'nameAr': nameAr,
      'primaryMuscleGroup': primaryMuscleGroup,
      'primaryMuscleGroupAr': primaryMuscleGroupAr,
      'secondaryMuscleGroups': secondaryMuscleGroups,
      'secondaryMuscleGroupsAr': secondaryMuscleGroupsAr,
      'equipment': equipment,
      'equipmentAr': equipmentAr,
      if (youtubeVideoId != null) 'youtubeVideoId': youtubeVideoId,
      if (gifUrl != null) 'gifUrl': gifUrl,
      if (thumbnailUrl != null) 'thumbnailUrl': thumbnailUrl,
      'stepByStepInstructions': stepByStepInstructions,
      'stepByStepInstructionsAr': stepByStepInstructionsAr,
      'commonMistakes': commonMistakes,
      'commonMistakesAr': commonMistakesAr,
      'breathingCue': breathingCue,
      'breathingCueAr': breathingCueAr,
      'safetyNote': safetyNote,
      'safetyNoteAr': safetyNoteAr,
      'difficulty': difficulty,
      'category': category,
      'status': status,
    };
  }
}
