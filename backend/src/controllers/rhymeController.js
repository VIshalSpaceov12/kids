const { execFile } = require('child_process');
const { promisify } = require('util');

const execFileAsync = promisify(execFile);

// Cache audio URLs for 1 hour (YouTube URLs expire after ~6 hours)
const urlCache = new Map();
const CACHE_TTL = 60 * 60 * 1000; // 1 hour

/**
 * GET /api/rhymes/audio-url/:videoId
 * Extract audio-only stream URL from a YouTube video using yt-dlp.
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

    const ytUrl = `https://www.youtube.com/watch?v=${videoId}`;
    const { stdout } = await execFileAsync('yt-dlp', [
      '-f', 'bestaudio',
      '-g',
      '--no-warnings',
      ytUrl,
    ], { timeout: 30000 });

    const audioUrl = stdout.trim();

    if (!audioUrl) {
      return res.status(404).json({
        success: false,
        message: 'No audio stream found',
      });
    }

    // Cache the result
    urlCache.set(videoId, { url: audioUrl, timestamp: Date.now() });

    return res.status(200).json({
      success: true,
      audioUrl,
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
