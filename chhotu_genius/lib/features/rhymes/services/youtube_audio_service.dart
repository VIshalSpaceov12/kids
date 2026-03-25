import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../core/config/app_config.dart';

class YouTubeAudioService {
  /// Fetches the audio URL for a YouTube video from our backend.
  /// The backend uses yt-dlp to extract audio URLs server-side,
  /// avoiding YouTube's rate limiting on mobile devices.
  Future<Uri?> getAudioUrl(String videoId) async {
    try {
      print('[YouTubeAudio] Requesting audio URL for: $videoId');
      final response = await http
          .get(Uri.parse('${AppConfig.baseUrl}/rhymes/audio-url/$videoId'))
          .timeout(const Duration(seconds: 30));

      if (response.statusCode != 200) {
        print('[YouTubeAudio] Server returned ${response.statusCode}');
        return null;
      }

      final data = jsonDecode(response.body) as Map<String, dynamic>;
      if (data['success'] != true || data['audioUrl'] == null) {
        print('[YouTubeAudio] Server error: ${data['message']}');
        return null;
      }

      final audioUrl = data['audioUrl'] as String;
      print('[YouTubeAudio] Got audio URL (${audioUrl.length} chars)');
      return Uri.parse(audioUrl);
    } catch (e) {
      print('[YouTubeAudio] ERROR: $e');
      return null;
    }
  }

  void dispose() {
    // No resources to clean up with HTTP approach
  }
}
