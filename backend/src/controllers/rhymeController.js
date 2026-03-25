const youtubedl = require('youtube-dl-exec');

// Cache audio URLs for 1 hour (YouTube URLs expire after ~6 hours)
const urlCache = new Map();
const CACHE_TTL = 60 * 60 * 1000;

/**
 * GET /api/rhymes/audio-url/:videoId
 * Extract audio-only stream URL from a YouTube video.
 * Uses youtube-dl-exec which bundles yt-dlp binary (works on Render).
 */
async function getAudioUrl(req, res) {
  try {
    const { videoId } = req.params;

    if (!videoId || videoId.length < 5) {
      return res.status(400).json({
        success: false,
        message: 'Invalid video ID',
      });
    }

    // Check cache
    const cached = urlCache.get(videoId);
    if (cached && Date.now() - cached.timestamp < CACHE_TTL) {
      return res.status(200).json({
        success: true,
        audioUrl: cached.url,
      });
    }

    const url = `https://www.youtube.com/watch?v=${videoId}`;
    const output = await youtubedl(url, {
      dumpSingleJson: true,
      noCheckCertificates: true,
      noWarnings: true,
      preferFreeFormats: true,
    });

    // Get audio-only formats that have a URL
    const audioFormats = output.formats.filter(
      (f) => f.resolution === 'audio only' && f.url
    );

    if (!audioFormats.length) {
      return res.status(404).json({
        success: false,
        message: 'No audio streams found',
      });
    }

    // Pick highest quality (last in the sorted list)
    const best = audioFormats[audioFormats.length - 1];

    // Cache it
    urlCache.set(videoId, { url: best.url, timestamp: Date.now() });

    return res.status(200).json({
      success: true,
      audioUrl: best.url,
    });
  } catch (error) {
    console.error('Audio URL extraction error:', error.message);
    return res.status(500).json({
      success: false,
      message: 'Failed to extract audio URL',
    });
  }
}

module.exports = { getAudioUrl };
