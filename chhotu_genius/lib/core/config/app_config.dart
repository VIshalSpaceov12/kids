class AppConfig {
  // For Android emulator: use 10.0.2.2
  // For iOS simulator: use localhost
  // For physical device: use your Mac's local IP
  static const String _devBaseUrl = 'http://172.16.17.94:3000/api';
  static const String _prodBaseUrl = 'https://chhotu-genius-api.onrender.com/api';

  static const bool _isDev = false; // Toggle for dev/prod

  static String get baseUrl => _isDev ? _devBaseUrl : _prodBaseUrl;

  // Longer timeouts for Render free tier (cold starts can take ~30s)
  static const Duration connectTimeout = Duration(seconds: 45);
  static const Duration receiveTimeout = Duration(seconds: 45);
}
