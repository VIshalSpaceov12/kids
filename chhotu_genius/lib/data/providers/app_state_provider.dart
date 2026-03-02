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
    _tryRestoreFromServer();
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

  /// On app start, if logged in but not onboarded locally, try fetching profile
  Future<void> _tryRestoreFromServer() async {
    if (_isLoggedIn && !_isOnboarded) {
      await fetchAndRestoreProfile();
      notifyListeners();
    }
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
      await fetchAndRestoreProfile();

      // If profile wasn't fully restored (no class_level), pre-populate
      // onboarding name from Firebase display name so it's not blank
      if (!_isOnboarded && _onboardingName.isEmpty) {
        final user = _authService.userData;
        if (user != null) {
          _onboardingName = user['name'] as String? ?? '';
        }
      }

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
      _onboardingName = name;
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
    _isOnboarded = false;
    _profile = null;
    _onboardingName = '';
    _onboardingClassLevel = '';
    _onboardingAvatar = '';
    await _storageService.clearOnboarded();
    notifyListeners();
  }

  /// Fetch user profile from server and restore locally
  Future<void> fetchAndRestoreProfile() async {
    try {
      final result = await _authService.getProfile();
      if (result['success'] == true && result['user'] != null) {
        final userData = result['user'] as Map<String, dynamic>;
        final name = userData['name'] as String? ?? '';
        final classLevel = userData['class_level'] as String? ?? '';
        final avatar = userData['avatar'] as String? ?? 'lion';

        // Always pre-populate onboarding fields from server
        // so name/avatar aren't blank if user needs to re-onboard
        if (name.isNotEmpty) _onboardingName = name;
        if (avatar.isNotEmpty) _onboardingAvatar = avatar;

        // Only fully restore if user has completed onboarding (has classLevel)
        if (classLevel.isNotEmpty) {
          _onboardingClassLevel = classLevel;
          final profile = ChildProfile(
            name: name,
            age: userData['age'] as int? ?? 5,
            classLevel: classLevel,
            avatar: avatar,
            pet: userData['pet'] as String? ?? 'cat',
            language: userData['language'] as String? ?? 'en',
            serverId: userData['id'] as String? ?? '',
          );
          _profile = profile;
          _isOnboarded = true;
          await _storageService.saveProfile(profile);
        }
      }
    } catch (_) {
      // If fetch fails, user will go through onboarding
    }
  }

  // Complete onboarding - save profile to server and locally
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

    // Save to server BEFORE notifyListeners to ensure it completes
    // before GoRouter redirects away
    if (_isLoggedIn) {
      try {
        final result = await _authService.updateProfile(
          name: _onboardingName,
          classLevel: _onboardingClassLevel,
          avatar: _onboardingAvatar,
        );
        if (result['success'] == true && result['user'] != null) {
          final serverUser = result['user'] as Map<String, dynamic>;
          _profile = _profile!.copyWith(serverId: serverUser['id'] as String? ?? '');
          await _storageService.saveProfile(_profile!);
        }
      } catch (_) {
        // Server sync failed — profile is saved locally, will retry on next app open
      }
    }

    notifyListeners();
  }

  // Update class level on existing profile
  Future<void> updateClassLevel(String classLevel) async {
    if (_profile != null) {
      _profile = _profile!.copyWith(classLevel: classLevel);
      await _storageService.saveProfile(_profile!);
      notifyListeners();

      // Sync to server
      if (_isLoggedIn) {
        await _authService.updateProfile(classLevel: classLevel);
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
