import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/child_profile.dart';

class LocalStorageService {
  static const String _profileKey = 'child_profile';
  static const String _progressKey = 'progress_data';
  static const String _onboardedKey = 'is_onboarded';
  static const String _parentPinKey = 'parent_pin';
  static const String _daysActiveKey = 'days_active';
  static const String _lastActiveDateKey = 'last_active_date';

  final SharedPreferences _prefs;

  LocalStorageService(this._prefs);

  // Profile methods
  Future<void> saveProfile(ChildProfile profile) async {
    await _prefs.setString(_profileKey, profile.toJsonString());
    await _prefs.setBool(_onboardedKey, true);
  }

  ChildProfile? getProfile() {
    final jsonString = _prefs.getString(_profileKey);
    if (jsonString == null) return null;
    return ChildProfile.fromJsonString(jsonString);
  }

  bool hasProfile() {
    return _prefs.containsKey(_profileKey);
  }

  bool isOnboarded() {
    return _prefs.getBool(_onboardedKey) ?? false;
  }

  // Progress methods
  Future<void> saveProgress(Map<String, Map<String, int>> progress) async {
    final encoded = jsonEncode(
      progress.map(
        (key, value) => MapEntry(key, value.map(
          (k, v) => MapEntry(k, v),
        )),
      ),
    );
    await _prefs.setString(_progressKey, encoded);
  }

  Map<String, Map<String, int>> getProgress() {
    final jsonString = _prefs.getString(_progressKey);
    if (jsonString == null) return {};
    final decoded = jsonDecode(jsonString) as Map<String, dynamic>;
    return decoded.map(
      (key, value) => MapEntry(
        key,
        (value as Map<String, dynamic>).map(
          (k, v) => MapEntry(k, v as int),
        ),
      ),
    );
  }

  // Parent PIN methods
  Future<void> saveParentPin(String pin) async {
    await _prefs.setString(_parentPinKey, pin);
    // Also update profile if exists
    final profile = getProfile();
    if (profile != null) {
      await saveProfile(profile.copyWith(parentPin: pin));
    }
  }

  String? getParentPin() {
    return _prefs.getString(_parentPinKey);
  }

  bool hasParentPin() {
    return _prefs.containsKey(_parentPinKey) &&
        (_prefs.getString(_parentPinKey)?.isNotEmpty ?? false);
  }

  // Days active tracking
  Future<void> trackActiveDay() async {
    final today = DateTime.now().toIso8601String().substring(0, 10);
    final lastActive = _prefs.getString(_lastActiveDateKey);
    if (lastActive != today) {
      final days = _prefs.getInt(_daysActiveKey) ?? 0;
      await _prefs.setInt(_daysActiveKey, days + 1);
      await _prefs.setString(_lastActiveDateKey, today);
    }
  }

  int getDaysActive() {
    return _prefs.getInt(_daysActiveKey) ?? 1;
  }

  /// Clear onboarded state and profile (used on logout)
  Future<void> clearOnboarded() async {
    await _prefs.remove(_onboardedKey);
    await _prefs.remove(_profileKey);
  }
}
