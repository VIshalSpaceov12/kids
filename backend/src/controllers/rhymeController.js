const { spawn } = require('child_process');
const { execFile } = require('child_process');
const { promisify } = require('util');
const path = require('path');

const execFileAsync = promisify(execFile);

// Path to the bundled yt-dlp binary from youtube-dl-exec
const ytDlpPath = path.join(
  __dirname,
  '../../node_modules/youtube-dl-exec/bin/yt-dlp'
);

// Cache audio URLs for 1 hour
const urlCache = new Map();
const CACHE_TTL = 60 * 60 * 1000;

/**
 * GET /api/rhymes/audio-url/:videoId
 * Extract audio-only stream URL from a YouTube video.
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

    // Try bundled yt-dlp first, then system yt-dlp
    let audioUrl;
    for (const bin of [ytDlpPath, 'yt-dlp']) {
      try {
        const { stdout } = await execFileAsync(bin, [
          '-f', 'bestaudio',
          '-g',
          '--no-warnings',
          '--no-check-certificates',
          ytUrl,
        ], { timeout: 30000 });
        audioUrl = stdout.trim();
        if (audioUrl) break;
      } catch (e) {
        console.log(`yt-dlp (${bin}) failed:`, e.message.substring(0, 100));
        continue;
      }
    }

    if (!audioUrl) {
      return res.status(500).json({
        success: false,
        message: 'Failed to extract audio URL',
      });
    }

    // Cache it
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

/**
 * GET /api/rhymes/audio-stream/:videoId
 * Stream audio directly through the backend as a proxy.
 * Fallback when direct URL doesn't work (IP mismatch).
 */
async function streamAudio(req, res) {
  try {
    const { videoId } = req.params;

    if (!videoId || videoId.length < 5) {
      return res.status(400).json({
        success: false,
        message: 'Invalid video ID',
      });
    }

    const ytUrl = `https://www.youtube.com/watch?v=${videoId}`;

    // Try bundled yt-dlp first, then system
    let ytdlpBin = ytDlpPath;
    try {
      require('fs').accessSync(ytdlpBin, require('fs').constants.X_OK);
    } catch {
      ytdlpBin = 'yt-dlp';
    }

    const proc = spawn(ytdlpBin, [
      '-f', 'bestaudio',
      '-o', '-',
      '--no-warnings',
      '--no-check-certificates',
      ytUrl,
    ]);

    res.setHeader('Content-Type', 'audio/webm');
    res.setHeader('Transfer-Encoding', 'chunked');

    proc.stdout.pipe(res);

    proc.stderr.on('data', (data) => {
      console.error('yt-dlp stderr:', data.toString().substring(0, 200));
    });

    proc.on('error', (err) => {
      console.error('yt-dlp spawn error:', err.message);
      if (!res.headersSent) {
        res.status(500).json({ success: false, message: 'Stream failed' });
      }
    });

    proc.on('close', (code) => {
      if (code !== 0 && !res.headersSent) {
        res.status(500).json({ success: false, message: 'Stream failed' });
      }
    });

    // Clean up if client disconnects
    req.on('close', () => {
      proc.kill();
    });
  } catch (error) {
    console.error('Audio stream error:', error.message);
    if (!res.headersSent) {
      res.status(500).json({ success: false, message: 'Failed to stream audio' });
    }
  }
}

module.exports = { getAudioUrl, streamAudio };
