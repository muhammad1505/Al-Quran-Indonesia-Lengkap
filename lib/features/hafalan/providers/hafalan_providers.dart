import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:quran_app/core/providers/settings_provider.dart';
import 'package:quran_app/features/hafalan/domain/entities/hafalan_progress.dart';

class HafalanNotifier extends StateNotifier<List<HafalanProgress>> {
  final SharedPreferences _prefs;
  static const _key = 'hafalan_list';

  HafalanNotifier(this._prefs) : super([]) {
    _load();
  }

  void _load() {
    final raw = _prefs.getString(_key);
    if (raw != null && raw.isNotEmpty) {
      state = HafalanProgress.decodeList(raw);
    }
  }

  Future<void> _save() async {
    await _prefs.setString(_key, HafalanProgress.encodeList(state));
  }

  Future<void> add(HafalanProgress item) async {
    state = [...state, item];
    await _save();
  }

  Future<void> update(HafalanProgress updated) async {
    state = state.map((e) => e.id == updated.id ? updated : e).toList();
    await _save();
  }

  Future<void> remove(String id) async {
    state = state.where((e) => e.id != id).toList();
    await _save();
  }

  Future<void> updateStatus(String id, HafalanStatus status) async {
    state = state.map((e) {
      if (e.id == id) {
        return e.copyWith(
          status: status,
          completedAt:
              status == HafalanStatus.selesai ? DateTime.now() : null,
        );
      }
      return e;
    }).toList();
    await _save();
  }
}

final hafalanProvider =
    StateNotifierProvider<HafalanNotifier, List<HafalanProgress>>((ref) {
  final prefs = ref.watch(sharedPrefsProvider);
  return HafalanNotifier(prefs);
});
