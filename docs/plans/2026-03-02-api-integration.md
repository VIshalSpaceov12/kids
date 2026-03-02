# Flutter API Integration - Implementation Plan

> **For Claude:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task.

**Goal:** Connect the Flutter app to the backend API for parent email/password auth and progress sync, while keeping local content data intact.

**Architecture:** Hybrid approach - learning content (numbers, letters, animals, maths) stays as hardcoded local Dart data. API is used only for parent authentication (email/password login) and progress syncing. Flutter stores JWT token locally and syncs progress when online.

**Tech Stack:** Flutter (http package), Node.js/Express backend, PostgreSQL, JWT auth, SharedPreferences for token storage.

---

## Task 1: Backend - Add Parent Email/Password Login Endpoint

**Files:**
- Modify: `backend/src/routes/auth.js` (add login route + validation schema)
- Modify: `backend/src/controllers/authController.js` (add login function)

**Step 1: Add login function to authController.js**

Add this function before `module.exports` at the bottom of `backend/src/controllers/authController.js`:

```javascript
/**
 * POST /api/auth/login
 * Login a parent with email and password.
 */
async function login(req, res) {
  try {
    const { email, password } = req.body;

    const parent = await db('parents').where({ email }).first();

    if (!parent || !parent.password_hash) {
      return res.status(401).json({
        success: false,
        message: 'Invalid email or password.',
      });
    }

    const isValidPassword = await bcrypt.compare(password, parent.password_hash);
    if (!isValidPassword) {
      return res.status(401).json({
        success: false,
        message: 'Invalid email or password.',
      });
    }

    const token = jwt.sign(
      {
        id: parent.id,
        name: parent.name,
        email: parent.email,
        phone: parent.phone,
        type: 'parent',
      },
      env.JWT_SECRET,
      { expiresIn: env.JWT_EXPIRES_IN }
    );

    return res.status(200).json({
      success: true,
      token,
      parent: {
        id: parent.id,
        name: parent.name,
        email: parent.email,
        phone: parent.phone,
      },
    });
  } catch (error) {
    console.error('Login error:', error);
    return res.status(500).json({
      success: false,
      message: 'Internal server error',
    });
  }
}
```

Update the `module.exports` to include `login`:
```javascript
module.exports = { register, verifyOtpHandler, refresh, setPin, login };
```

**Step 2: Update register to also hash a password**

Modify the `register` function in `backend/src/controllers/authController.js` to accept and hash a password when creating new parents. In the "Create new parent" section, change the insert to:

```javascript
    // Create new parent
    const insertData = {
      name,
      phone: phone || null,
      email: email || null,
    };

    // Hash password if provided
    if (password) {
      insertData.password_hash = await bcrypt.hash(password, 10);
    }

    const [parent] = await db('parents')
      .insert(insertData)
      .returning('*');
```

**Step 3: Add login route and update register validation in auth.js**

Add to `backend/src/routes/auth.js`:

```javascript
const loginSchema = Joi.object({
  email: Joi.string().email().required().messages({
    'string.email': 'Email must be a valid email address',
    'any.required': 'Email is required',
  }),
  password: Joi.string().min(6).required().messages({
    'string.min': 'Password must be at least 6 characters',
    'any.required': 'Password is required',
  }),
});
```

Add a `password` field to the existing `registerSchema`:
```javascript
  password: Joi.string().min(6).optional().messages({
    'string.min': 'Password must be at least 6 characters',
  }),
```

Add the route before `module.exports`:
```javascript
router.post('/login', validate(loginSchema), authController.login);
```

**Step 4: Create backend .env file**

Create `backend/.env`:
```
PORT=3000
DB_HOST=localhost
DB_PORT=5432
DB_NAME=chhotu_genius
DB_USER=postgres
DB_PASSWORD=postgres
JWT_SECRET=dev-secret-key-change-in-production-abc123
JWT_EXPIRES_IN=7d
```

**Step 5: Verify backend .gitignore has .env**

Check `backend/.gitignore` includes `.env` (not `.env.example`).

**Step 6: Commit**
```
feat(backend): add parent email/password login endpoint
```

---

## Task 2: Flutter - Create Environment Config

**Files:**
- Create: `chhotu_genius/lib/core/config/app_config.dart`

**Step 1: Create the config file**

```dart
class AppConfig {
  static const String _devBaseUrl = 'http://10.0.2.2:3000/api';
  static const String _prodBaseUrl = 'http://10.0.2.2:3000/api'; // Update with production URL

  static const bool _isDev = true; // Toggle for dev/prod

  static String get baseUrl => _isDev ? _devBaseUrl : _prodBaseUrl;

  // For iOS simulator, use localhost. For Android emulator, use 10.0.2.2
  // For physical device, use your machine's local IP (e.g., 192.168.1.100)
  static const Duration connectTimeout = Duration(seconds: 10);
  static const Duration receiveTimeout = Duration(seconds: 10);
}
```

**Step 2: Commit**
```
feat(flutter): add environment config for API base URL
```

---

## Task 3: Flutter - Create API Service (HTTP Client)

**Files:**
- Create: `chhotu_genius/lib/data/services/api_service.dart`

**Step 1: Create the API service**

```dart
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/config/app_config.dart';

class ApiService {
  static const String _tokenKey = 'auth_token';
  static const String _parentKey = 'parent_data';

  final http.Client _client;
  final SharedPreferences _prefs;

  ApiService(this._prefs) : _client = http.Client();

  String get baseUrl => AppConfig.baseUrl;

  // Token management
  String? get token => _prefs.getString(_tokenKey);

  Future<void> saveToken(String token) async {
    await _prefs.setString(_tokenKey, token);
  }

  Future<void> clearToken() async {
    await _prefs.remove(_tokenKey);
    await _prefs.remove(_parentKey);
  }

  bool get isLoggedIn => token != null;

  // Parent data
  Future<void> saveParentData(Map<String, dynamic> parent) async {
    await _prefs.setString(_parentKey, jsonEncode(parent));
  }

  Map<String, dynamic>? getParentData() {
    final data = _prefs.getString(_parentKey);
    if (data == null) return null;
    return jsonDecode(data) as Map<String, dynamic>;
  }

  // HTTP helpers
  Map<String, String> get _headers {
    final headers = <String, String>{
      'Content-Type': 'application/json',
    };
    if (token != null) {
      headers['Authorization'] = 'Bearer $token';
    }
    return headers;
  }

  Future<Map<String, dynamic>> get(String path) async {
    try {
      final response = await _client
          .get(Uri.parse('$baseUrl$path'), headers: _headers)
          .timeout(AppConfig.connectTimeout);
      return _handleResponse(response);
    } on SocketException {
      return {'success': false, 'message': 'No internet connection', 'offline': true};
    } on http.ClientException {
      return {'success': false, 'message': 'Connection failed', 'offline': true};
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  Future<Map<String, dynamic>> post(String path, Map<String, dynamic> body) async {
    try {
      final response = await _client
          .post(Uri.parse('$baseUrl$path'), headers: _headers, body: jsonEncode(body))
          .timeout(AppConfig.connectTimeout);
      return _handleResponse(response);
    } on SocketException {
      return {'success': false, 'message': 'No internet connection', 'offline': true};
    } on http.ClientException {
      return {'success': false, 'message': 'Connection failed', 'offline': true};
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  Map<String, dynamic> _handleResponse(http.Response response) {
    final body = jsonDecode(response.body) as Map<String, dynamic>;
    if (response.statusCode == 401) {
      clearToken();
    }
    return body;
  }
}
```

**Step 2: Commit**
```
feat(flutter): add API service with HTTP client and token management
```

---

## Task 4: Flutter - Create Auth Service

**Files:**
- Create: `chhotu_genius/lib/data/services/auth_service.dart`

**Step 1: Create the auth service**

```dart
import 'api_service.dart';

class AuthService {
  final ApiService _api;

  AuthService(this._api);

  bool get isLoggedIn => _api.isLoggedIn;
  Map<String, dynamic>? get parentData => _api.getParentData();

  /// Register a new parent with name, email, and password
  Future<Map<String, dynamic>> register({
    required String name,
    required String email,
    required String password,
  }) async {
    final result = await _api.post('/auth/register', {
      'name': name,
      'email': email,
      'password': password,
    });

    return result;
  }

  /// Login with email and password
  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    final result = await _api.post('/auth/login', {
      'email': email,
      'password': password,
    });

    if (result['success'] == true) {
      await _api.saveToken(result['token'] as String);
      await _api.saveParentData(result['parent'] as Map<String, dynamic>);
    }

    return result;
  }

  /// Logout - clear stored token
  Future<void> logout() async {
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
}
```

**Step 2: Commit**
```
feat(flutter): add auth service for parent login/register
```

---

## Task 5: Flutter - Create Progress Sync Service

**Files:**
- Create: `chhotu_genius/lib/data/services/progress_sync_service.dart`

**Step 1: Create the progress sync service**

```dart
import 'api_service.dart';

class ProgressSyncService {
  final ApiService _api;

  ProgressSyncService(this._api);

  /// Save progress for a single lesson
  Future<Map<String, dynamic>> saveProgress({
    required String childId,
    required String lessonId,
    required int score,
    required int stars,
    bool completed = false,
  }) async {
    return _api.post('/progress', {
      'childId': childId,
      'lessonId': lessonId,
      'score': score,
      'stars': stars,
      'completed': completed,
    });
  }

  /// Get all progress for a child
  Future<Map<String, dynamic>> getChildProgress(String childId) async {
    return _api.get('/progress/$childId');
  }

  /// Get progress for a specific module
  Future<Map<String, dynamic>> getModuleProgress(String childId, String moduleSlug) async {
    return _api.get('/progress/$childId/module/$moduleSlug');
  }

  /// Bulk sync local progress to server
  Future<Map<String, dynamic>> syncBatch(List<Map<String, dynamic>> entries) async {
    return _api.post('/progress/sync', {'entries': entries});
  }
}
```

**Step 2: Commit**
```
feat(flutter): add progress sync service
```

---

## Task 6: Flutter - Wire Services Into App

**Files:**
- Modify: `chhotu_genius/lib/main.dart` (initialize ApiService, provide it)
- Modify: `chhotu_genius/lib/data/providers/app_state_provider.dart` (add auth methods)
- Modify: `chhotu_genius/lib/data/providers/progress_provider.dart` (add sync methods)

**Step 1: Update main.dart**

Update `main.dart` to initialize `ApiService` and pass it to providers:

```dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app.dart';
import 'data/local/local_storage_service.dart';
import 'data/providers/app_state_provider.dart';
import 'data/providers/progress_provider.dart';
import 'data/services/api_service.dart';
import 'data/services/auth_service.dart';
import 'data/services/progress_sync_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );

  final prefs = await SharedPreferences.getInstance();
  final storageService = LocalStorageService(prefs);
  final apiService = ApiService(prefs);
  final authService = AuthService(apiService);
  final progressSyncService = ProgressSyncService(apiService);

  runApp(
    MultiProvider(
      providers: [
        Provider<ApiService>.value(value: apiService),
        Provider<AuthService>.value(value: authService),
        Provider<ProgressSyncService>.value(value: progressSyncService),
        ChangeNotifierProvider(
          create: (_) => AppStateProvider(storageService, authService),
        ),
        ChangeNotifierProvider(
          create: (_) => ProgressProvider(storageService, progressSyncService),
        ),
      ],
      child: const ChhotuGeniusApp(),
    ),
  );
}
```

**Step 2: Update AppStateProvider**

Modify `chhotu_genius/lib/data/providers/app_state_provider.dart` to accept `AuthService` and expose auth methods:

```dart
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
      // Auto-login after registration
      return login(email, password);
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

    // If logged in, also create child on server (fire and forget)
    if (_isLoggedIn) {
      _authService.createChild(
        name: _onboardingName,
        age: profile.age,
        classLevel: _onboardingClassLevel,
        avatar: _onboardingAvatar,
      );
    }

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
```

**Step 3: Update ProgressProvider**

Modify `chhotu_genius/lib/data/providers/progress_provider.dart` to accept `ProgressSyncService`:

```dart
import 'package:flutter/foundation.dart';
import '../local/local_storage_service.dart';
import '../services/progress_sync_service.dart';

class ProgressProvider extends ChangeNotifier {
  final LocalStorageService _storageService;
  final ProgressSyncService _syncService;

  // module -> lesson -> score (stars 0-3)
  Map<String, Map<String, int>> _progress = {};

  ProgressProvider(this._storageService, this._syncService) {
    _loadFromStorage();
  }

  Map<String, Map<String, int>> get progress => _progress;

  void _loadFromStorage() {
    _progress = _storageService.getProgress();
    notifyListeners();
  }

  Future<void> recordProgress(String module, String lesson, int score) async {
    _progress.putIfAbsent(module, () => {});
    final currentScore = _progress[module]![lesson] ?? 0;
    // Only update if new score is higher
    if (score > currentScore) {
      _progress[module]![lesson] = score;
    }
    await _storageService.saveProgress(_progress);
    notifyListeners();
  }

  Map<String, int> getModuleProgress(String module) {
    return _progress[module] ?? {};
  }

  int getTotalStars() {
    int total = 0;
    for (final module in _progress.values) {
      for (final score in module.values) {
        total += score;
      }
    }
    return total;
  }

  int getCompletedLessonsCount() {
    int count = 0;
    for (final module in _progress.values) {
      for (final score in module.values) {
        if (score > 0) count++;
      }
    }
    return count;
  }

  double getModuleProgressPercent(String module, int totalLessons) {
    if (totalLessons == 0) return 0;
    final moduleProgress = _progress[module] ?? {};
    final completedLessons =
        moduleProgress.values.where((score) => score > 0).length;
    return (completedLessons / totalLessons).clamp(0.0, 1.0);
  }

  int getModuleStars(String module) {
    final moduleProgress = _progress[module] ?? {};
    int stars = 0;
    for (final score in moduleProgress.values) {
      stars += score;
    }
    return stars;
  }
}
```

**Step 4: Commit**
```
feat(flutter): wire API services into providers and main.dart
```

---

## Task 7: Flutter - Add Parent Login/Register Screen

**Files:**
- Create: `chhotu_genius/lib/features/parent/screens/parent_login_screen.dart`
- Modify: `chhotu_genius/lib/app.dart` (add login route)

**Step 1: Create the login/register screen**

```dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../data/providers/app_state_provider.dart';

class ParentLoginScreen extends StatefulWidget {
  const ParentLoginScreen({super.key});

  @override
  State<ParentLoginScreen> createState() => _ParentLoginScreenState();
}

class _ParentLoginScreenState extends State<ParentLoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLogin = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    final appState = context.read<AppStateProvider>();

    bool success;
    if (_isLogin) {
      success = await appState.login(
        _emailController.text.trim(),
        _passwordController.text,
      );
    } else {
      success = await appState.register(
        _nameController.text.trim(),
        _emailController.text.trim(),
        _passwordController.text,
      );
    }

    setState(() => _isLoading = false);

    if (success && mounted) {
      context.go('/parent/dashboard');
    }
  }

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppStateProvider>();

    return Scaffold(
      appBar: AppBar(
        title: Text(_isLogin ? 'Parent Login' : 'Parent Register'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/home'),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Icon(Icons.lock_outline, size: 64, color: Colors.deepPurple),
              const SizedBox(height: 16),
              Text(
                _isLogin ? 'Welcome Back!' : 'Create Account',
                style: Theme.of(context).textTheme.headlineSmall,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),

              if (!_isLogin)
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'Full Name',
                    prefixIcon: Icon(Icons.person),
                    border: OutlineInputBorder(),
                  ),
                  validator: (v) =>
                      (v == null || v.trim().length < 2) ? 'Name is required' : null,
                ),
              if (!_isLogin) const SizedBox(height: 16),

              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  prefixIcon: Icon(Icons.email),
                  border: OutlineInputBorder(),
                ),
                validator: (v) {
                  if (v == null || v.trim().isEmpty) return 'Email is required';
                  if (!v.contains('@')) return 'Enter a valid email';
                  return null;
                },
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Password',
                  prefixIcon: Icon(Icons.lock),
                  border: OutlineInputBorder(),
                ),
                validator: (v) {
                  if (v == null || v.length < 6) return 'Password must be at least 6 characters';
                  return null;
                },
              ),
              const SizedBox(height: 8),

              if (appState.authError != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Text(
                    appState.authError!,
                    style: const TextStyle(color: Colors.red),
                    textAlign: TextAlign.center,
                  ),
                ),

              const SizedBox(height: 16),

              ElevatedButton(
                onPressed: _isLoading ? null : _submit,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: Colors.deepPurple,
                  foregroundColor: Colors.white,
                ),
                child: _isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                      )
                    : Text(_isLogin ? 'Login' : 'Register'),
              ),

              const SizedBox(height: 16),

              TextButton(
                onPressed: () => setState(() {
                  _isLogin = !_isLogin;
                  _formKey.currentState?.reset();
                }),
                child: Text(
                  _isLogin
                      ? "Don't have an account? Register"
                      : 'Already have an account? Login',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
```

**Step 2: Add route in app.dart**

Add this import at the top of `chhotu_genius/lib/app.dart`:
```dart
import 'features/parent/screens/parent_login_screen.dart';
```

Add this route in the routes list (before the `/parent` route):
```dart
GoRoute(
  path: '/parent/login',
  builder: (context, state) => const ParentLoginScreen(),
),
```

**Step 3: Commit**
```
feat(flutter): add parent login/register screen with API auth
```

---

## Task 8: Update Parent Dashboard to Show Login State

**Files:**
- Modify: `chhotu_genius/lib/features/parent/screens/parent_pin_screen.dart` (add login option)

**Step 1: Add a "Login for cloud sync" button**

In `parent_pin_screen.dart`, add a button below the PIN entry that navigates to `/parent/login` if the parent isn't logged in. This is optional UX — the app still works fully without login.

Add somewhere in the build method after the existing PIN UI:

```dart
if (!context.read<AppStateProvider>().isLoggedIn)
  Padding(
    padding: const EdgeInsets.only(top: 16),
    child: TextButton.icon(
      onPressed: () => context.go('/parent/login'),
      icon: const Icon(Icons.cloud_sync),
      label: const Text('Login to sync progress across devices'),
    ),
  ),
```

**Step 2: Commit**
```
feat(flutter): add login prompt on parent PIN screen
```

---

## Summary of All Changes

### Backend (2 files modified, 1 file created)
1. `backend/src/controllers/authController.js` - Add `login()` function, update `register()` to accept password
2. `backend/src/routes/auth.js` - Add login route + validation, add password to register schema
3. `backend/.env` - Create from `.env.example`

### Flutter (8 files: 4 created, 4 modified)
1. `lib/core/config/app_config.dart` - NEW: Environment config
2. `lib/data/services/api_service.dart` - NEW: HTTP client + token management
3. `lib/data/services/auth_service.dart` - NEW: Login/register service
4. `lib/data/services/progress_sync_service.dart` - NEW: Progress sync service
5. `lib/main.dart` - MODIFIED: Initialize and provide services
6. `lib/data/providers/app_state_provider.dart` - MODIFIED: Add auth methods
7. `lib/data/providers/progress_provider.dart` - MODIFIED: Accept sync service
8. `lib/features/parent/screens/parent_login_screen.dart` - NEW: Login UI
9. `lib/app.dart` - MODIFIED: Add login route

### What stays untouched
- All learning content data files (numbers, letters, gujarati, animals, maths)
- All learning screens (they keep using local data)
- Home/world map screen
- Onboarding flow
