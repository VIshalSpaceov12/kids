import 'dart:convert';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/config/app_config.dart';

class ApiService {
  static const String _tokenKey = 'auth_token';
  static const String _userDataKey = 'user_data';

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
    await _prefs.remove(_userDataKey);
  }

  bool get isLoggedIn => FirebaseAuth.instance.currentUser != null;

  // User data
  Future<void> saveUserData(Map<String, dynamic> user) async {
    await _prefs.setString(_userDataKey, jsonEncode(user));
  }

  Map<String, dynamic>? getUserData() {
    final data = _prefs.getString(_userDataKey);
    if (data == null) return null;
    return jsonDecode(data) as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> put(String path, Map<String, dynamic> body) async {
    try {
      final headers = await _getHeaders();
      final response = await _client
          .put(Uri.parse('$baseUrl$path'), headers: headers, body: jsonEncode(body))
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

  // HTTP helpers
  Future<String?> _getFreshToken() async {
    return await FirebaseAuth.instance.currentUser?.getIdToken();
  }

  Future<Map<String, String>> _getHeaders() async {
    final headers = <String, String>{
      'Content-Type': 'application/json',
    };
    // Get fresh Firebase token; fall back to stored token
    final firebaseToken = await _getFreshToken();
    final authToken = firebaseToken ?? token;
    if (authToken != null) {
      headers['Authorization'] = 'Bearer $authToken';
    }
    return headers;
  }

  Future<Map<String, dynamic>> get(String path) async {
    try {
      final headers = await _getHeaders();
      final response = await _client
          .get(Uri.parse('$baseUrl$path'), headers: headers)
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
      final headers = await _getHeaders();
      final response = await _client
          .post(Uri.parse('$baseUrl$path'), headers: headers, body: jsonEncode(body))
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
