import 'package:firebase_auth/firebase_auth.dart';
import 'api_service.dart';

class AuthService {
  final ApiService _api;

  AuthService(this._api);

  bool get isLoggedIn => FirebaseAuth.instance.currentUser != null;
  Map<String, dynamic>? get userData => _api.getUserData();

  /// Register a new user with name, email, and password
  Future<Map<String, dynamic>> register({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      // Create user with Firebase Auth
      final credential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Set the display name
      await credential.user?.updateDisplayName(name);

      // Get the Firebase ID token and save it
      final idToken = await credential.user?.getIdToken();
      if (idToken != null) {
        await _api.saveToken(idToken);
      }

      // Sync with backend - creates user in DB
      final syncResult = await _api.post('/auth/firebase-sync', {});
      if (syncResult['success'] == true && syncResult['user'] != null) {
        await _api.saveUserData(syncResult['user'] as Map<String, dynamic>);
      }

      return {'success': true};
    } on FirebaseAuthException catch (e) {
      return {'success': false, 'message': _mapFirebaseError(e.code)};
    } catch (e) {
      return {'success': false, 'message': 'Registration failed. Please try again'};
    }
  }

  /// Login with email and password
  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    try {
      // Sign in with Firebase Auth
      final credential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Get the Firebase ID token and save it
      final idToken = await credential.user?.getIdToken();
      if (idToken != null) {
        await _api.saveToken(idToken);
      }

      // Sync with backend
      final syncResult = await _api.post('/auth/firebase-sync', {});
      if (syncResult['success'] == true && syncResult['user'] != null) {
        await _api.saveUserData(syncResult['user'] as Map<String, dynamic>);
      }

      return {'success': true};
    } on FirebaseAuthException catch (e) {
      return {'success': false, 'message': _mapFirebaseError(e.code)};
    } catch (e) {
      return {'success': false, 'message': 'Login failed. Please try again'};
    }
  }

  /// Logout - sign out from Firebase and clear stored token
  Future<void> logout() async {
    await FirebaseAuth.instance.signOut();
    await _api.clearToken();
  }

  /// Get current user profile from server
  Future<Map<String, dynamic>> getProfile() async {
    return _api.get('/profiles/me');
  }

  /// Update user profile on server (name, classLevel, avatar, age, etc.)
  Future<Map<String, dynamic>> updateProfile({
    String? name,
    String? classLevel,
    String? avatar,
    int? age,
    String? pet,
    String? language,
  }) async {
    final body = <String, dynamic>{};
    if (name != null) body['name'] = name;
    if (classLevel != null) body['classLevel'] = classLevel;
    if (avatar != null) body['avatar'] = avatar;
    if (age != null) body['age'] = age;
    if (pet != null) body['pet'] = pet;
    if (language != null) body['language'] = language;

    return _api.put('/profiles/me', body);
  }

  /// Map Firebase Auth error codes to user-friendly messages
  String _mapFirebaseError(String code) {
    switch (code) {
      case 'email-already-in-use':
        return 'An account with this email already exists';
      case 'invalid-email':
        return 'Invalid email address';
      case 'weak-password':
        return 'Password is too weak. Use at least 6 characters';
      case 'user-not-found':
        return 'No account found with this email';
      case 'wrong-password':
        return 'Incorrect password';
      case 'invalid-credential':
        return 'Invalid email or password';
      case 'too-many-requests':
        return 'Too many attempts. Please try again later';
      default:
        return 'Authentication failed. Please try again';
    }
  }
}
