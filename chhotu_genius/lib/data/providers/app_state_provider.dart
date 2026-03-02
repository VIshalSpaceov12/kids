import 'package:flutter/foundation.dart';
import '../models/child_profile.dart';
import '../local/local_storage_service.dart';
import '../services/auth_service.dart';

class AppStateProvider extends ChangeNotifier {
  final LocalStorageService _storageService;
  final AuthService _authService;

  ChildProfile? _profile;
  bool _isOnboarded = false;
  bool _isLoggedIn = false;
  String? _authError;

  // Onboarding temporary state
  String _onboardingName = '';
  String _onboardingClassLevel = '';
  String _onboardingAvatar = '';

  AppStateProvider(this._storageService, this._authService) {
    _loadFromStorage();
  }

  // Getters
  ChildProfile? get profile => _profile;
  bool get isOnboarded => _isOnboarded;
  bool get isLoggedIn => _isLoggedIn;
  String? get authError => _authError;
  String get onboardingName => _onboardingName;
  String get onboardingClassLevel => _onboardingClassLevel;
  String get onboardingAvatar => _onboardingAvatar;

  void _loadFromStorage() {
    _isOnboarded = _storageService.isOnboarded();
    _profile = _storageService.getProfile();
    _isLoggedIn = _authService.isLoggedIn;
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

  // Auth methods
  Future<bool> login(String email, String password) async {
    _authError = null;
    notifyListeners();

    final result = await _authService.login(email: email, password: password);
    if (result['success'] == true) {
      _isLoggedIn = true;
      _authError = null;
      notifyListeners();
      return true;
    } else {
      _authError = result['message'] as String? ?? 'Login failed';
      notifyListeners();
      return false;
    }
  }

  Future<bool> register(String name, String email, String password) async {
    _authError = null;
    notifyListeners();

    final result = await _authService.register(
      name: name,
      email: email,
      password: password,
    );
    if (result['success'] == true) {
      _isLoggedIn = true;
      _authError = null;
      notifyListeners();
      return true;
    } else {
      _authError = result['message'] as String? ?? 'Registration failed';
      notifyListeners();
      return false;
    }
  }

  Future<void> logout() async {
    await _authService.logout();
    _isLoggedIn = false;
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

    // If logged in, create child on server and save the server ID
    if (_isLoggedIn) {
      final result = await _authService.createChild(
        name: _onboardingName,
        age: profile.age,
        classLevel: _onboardingClassLevel,
        avatar: _onboardingAvatar,
      );
      if (result['success'] == true && result['child'] != null) {
        final serverChildId = (result['child'] as Map<String, dynamic>)['id'] as String;
        _profile = _profile!.copyWith(serverId: serverChildId);
        await _storageService.saveProfile(_profile!);
        notifyListeners();
      }
    }
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
