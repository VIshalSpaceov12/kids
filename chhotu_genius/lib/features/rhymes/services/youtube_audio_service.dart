import 'package:youtube_explode_dart/youtube_explode_dart.dart';

class YouTubeAudioService {
  final _yt = YoutubeExplode();

  /// Extracts the best audio-only stream URL for a YouTube video.
  /// Returns null if extraction fails.
  Future<Uri?> getAudioUrl(String videoId) async {
    try {
      final manifest = await _yt.videos.streamsClient.getManifest(videoId);
      final audioOnly = manifest.audioOnly;
      if (audioOnly.isEmpty) return null;
      // Pick highest bitrate audio stream
      final best = audioOnly.withHighestBitrate();
      return best.url;
    } catch (e) {
      return null;
    }
  }

  void dispose() {
    _yt.close();
  }
}
