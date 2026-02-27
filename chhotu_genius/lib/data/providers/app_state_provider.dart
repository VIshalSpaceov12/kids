import 'package:flutter/foundation.dart';
import '../models/child_profile.dart';
import '../local/local_storage_service.dart';

class AppStateProvider extends ChangeNotifier {
  final LocalStorageService _storageService;

  ChildProfile? _profile;
  bool _isOnboarded = false;

  // Onboarding temporary state
  String _onboardingName = '';
  String _onboardingClassLevel = '';
  String _onboardingAvatar = '';

  AppStateProvider(this._storageService) {
    _loadFromStorage();
  }

  // Getters
  ChildProfile? get profile => _profile;
  bool get isOnboarded => _isOnboarded;
  String get onboardingName => _onboardingName;
  String get onboardingClassLevel => _onboardingClassLevel;
  String get onboardingAvatar => _onboardingAvatar;

  void _loadFromStorage() {
    _isOnboarded = _storageService.isOnboarded();
    _profile = _storageService.getProfile();
    notifyListeners();
  }

  // Onboarding setters
  void setOnboardingName(String name) {
    _onboardingName = name;
    notifyListeners();
  }

  void setOnboardingClassLevel(String classLevel) {
    _onboardingClassLevel = classLevel;
    notifyListeners();
  }

  void setOnboardingAvatar(String avatar) {
    _onboardingAvatar = avatar;
    notifyListeners();
  }

  // Complete onboarding and create profile
  Future<void> completeOnboarding() async {
    final profile = ChildProfile(
      name: _onboardingName,
      classLevel: _onboardingClassLevel,
      avatar: _onboardingAvatar,
    );
    _profile = profile;
    _isOnboarded = true;
    await _storageService.saveProfile(profile);
    await _storageService.trackActiveDay();
    notifyListeners();
  }

  // Update existing profile
  Future<void> updateProfile(ChildProfile updatedProfile) async {
    _profile = updatedProfile;
    await _storageService.saveProfile(updatedProfile);
    notifyListeners();
  }

  // Save parent PIN
  Future<void> saveParentPin(String pin) async {
    await _storageService.saveParentPin(pin);
    if (_profile != null) {
      _profile = _profile!.copyWith(parentPin: pin);
      notifyListeners();
    }
  }

  bool hasParentPin() {
    return _storageService.hasParentPin();
  }

  String? getParentPin() {
    return _storageService.getParentPin();
  }

  int getDaysActive() {
    return _storageService.getDaysActive();
  }

  Future<void> trackActiveDay() async {
    await _storageService.trackActiveDay();
  }
}
