import '../../../core/config/app_config.dart';

class YouTubeAudioService {
  /// Returns a URL that streams audio through our backend.
  /// The backend uses yt-dlp to fetch audio from YouTube and proxies it,
  /// avoiding rate limiting and IP-lock issues on mobile devices.
  Future<Uri?> getAudioUrl(String videoId) async {
    // Use the backend stream endpoint directly — audio is proxied through
    // our server, so no YouTube rate-limiting or IP mismatch issues.
    final streamUrl = '${AppConfig.baseUrl}/rhymes/audio-stream/$videoId';
    print('[YouTubeAudio] Using stream URL: $streamUrl');
    return Uri.parse(streamUrl);
  }

  void dispose() {}
}
