import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/local_store.dart';
import '../../data/programme/programme_data.dart';

const _profileKey = 'user_profile';

/// The single local user of this personal, offline app. Replaces the old
/// Firebase-backed auth user. Stored on device via SharedPreferences.
class UserProfile {
  /// Fixed local id — the app has one user and no accounts.
  final String uid;
  final int currentBlock;
  final int currentWeek;
  final String unitPreference; // 'kg' or 'lbs'

  const UserProfile({
    this.uid = 'local',
    this.currentBlock = 1,
    this.currentWeek = 1,
    this.unitPreference = 'kg',
  });

  String get unit => unitPreference;

  UserProfile copyWith({int? currentBlock, int? currentWeek, String? unitPreference}) {
    return UserProfile(
      uid: uid,
      currentBlock: currentBlock ?? this.currentBlock,
      currentWeek: currentWeek ?? this.currentWeek,
      unitPreference: unitPreference ?? this.unitPreference,
    );
  }

  factory UserProfile.fromMap(Map<String, dynamic> map) {
    return UserProfile(
      currentBlock: (map['currentBlock'] as num?)?.toInt() ?? 1,
      currentWeek: (map['currentWeek'] as num?)?.toInt() ?? 1,
      unitPreference: map['unitPreference'] as String? ?? 'kg',
    );
  }

  Map<String, dynamic> toMap() => {
        'currentBlock': currentBlock,
        'currentWeek': currentWeek,
        'unitPreference': unitPreference,
      };
}

class ProfileNotifier extends StateNotifier<UserProfile> {
  final LocalStore _store;

  ProfileNotifier(this._store) : super(const UserProfile()) {
    final saved = _store.getJson(_profileKey);
    if (saved != null) state = UserProfile.fromMap(saved);
  }

  Future<void> _persist() => _store.setJson(_profileKey, state.toMap());

  Future<void> setCurrentWeek(int week) async {
    state = state.copyWith(currentWeek: week, currentBlock: _blockForWeek(week));
    await _persist();
  }

  Future<void> setUnit(String unit) async {
    state = state.copyWith(unitPreference: unit);
    await _persist();
  }

  int _blockForWeek(int week) {
    // Single Upper/Lower block spans all 12 weeks.
    return blockForWeek(week).blockNumber;
  }
}

final profileProvider = StateNotifierProvider<ProfileNotifier, UserProfile>(
  (ref) => ProfileNotifier(ref.watch(localStoreProvider)),
);
