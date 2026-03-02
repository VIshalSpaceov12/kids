class AppConfig {
  // For Android emulator: use 10.0.2.2
  // For iOS simulator: use localhost
  // For physical device: use your Mac's local IP
  static const String _devBaseUrl = 'http://172.16.17.94:3000/api';
  static const String _prodBaseUrl = 'http://172.16.17.94:3000/api'; // Update with production URL

  static const bool _isDev = true; // Toggle for dev/prod

  static String get baseUrl => _isDev ? _devBaseUrl : _prodBaseUrl;

  static const Duration connectTimeout = Duration(seconds: 15);
  static const Duration receiveTimeout = Duration(seconds: 15);
}
