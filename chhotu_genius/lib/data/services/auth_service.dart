import 'package:firebase_auth/firebase_auth.dart';
import 'api_service.dart';

class AuthService {
  final ApiService _api;

  AuthService(this._api);

  bool get isLoggedIn => FirebaseAuth.instance.currentUser != null;
  Map<String, dynamic>? get parentData => _api.getParentData();

  /// Register a new parent with name, email, and password
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

      // Sync with backend and save parent data
      final syncResult = await _api.post('/auth/firebase-sync', {});
      if (syncResult['success'] == true && syncResult['parent'] != null) {
        await _api.saveParentData(syncResult['parent'] as Map<String, dynamic>);
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

      // Sync with backend and save parent data
      final syncResult = await _api.post('/auth/firebase-sync', {});
      if (syncResult['success'] == true && syncResult['parent'] != null) {
        await _api.saveParentData(syncResult['parent'] as Map<String, dynamic>);
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

  /// Get current parent profile
  Future<Map<String, dynamic>> getProfile() async {
    return _api.get('/profiles/me');
  }

  /// Create a child profile on the server
  Future<Map<String, dynamic>> createChild({
    required String name,
    required int age,
    required String classLevel,
    required String avatar,
  }) async {
    return _api.post('/profiles/children', {
      'name': name,
      'age': age,
      'classLevel': classLevel,
      'avatar': avatar,
    });
  }

  /// Get children profiles for the current parent
  Future<Map<String, dynamic>> getChildren() async {
    return _api.get('/profiles/children');
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
