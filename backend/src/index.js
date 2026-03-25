const express = require('express');
const helmet = require('helmet');
const cors = require('cors');
const rateLimit = require('express-rate-limit');
const env = require('./config/env');

// Import routes
const authRoutes = require('./routes/auth');
const profileRoutes = require('./routes/profiles');
const contentRoutes = require('./routes/content');
const progressRoutes = require('./routes/progress');
const adminRoutes = require('./routes/admin');
const rhymeController = require('./controllers/rhymeController');

const app = express();

// Trust proxy (required for Render, rate limiter needs real client IP)
if (env.NODE_ENV === 'production') {
  app.set('trust proxy', 1);
}

// ---------------------
// Security Middleware
// ---------------------
app.use(helmet());

// CORS configuration
const corsOptions = {
  origin: env.CORS_ORIGIN === '*'
    ? '*'
    : env.CORS_ORIGIN.split(',').map((o) => o.trim()),
  credentials: true,
};
app.use(cors(corsOptions));

// ---------------------
// Body Parsing
// ---------------------
app.use(express.json({ limit: '10mb' }));
app.use(express.urlencoded({ extended: true }));

// ---------------------
// Rate Limiting
// ---------------------
const limiter = rateLimit({
  windowMs: 15 * 60 * 1000, // 15 minutes
  max: 100, // Limit each IP to 100 requests per window
  standardHeaders: true,
  legacyHeaders: false,
  message: {
    success: false,
    message: 'Too many requests, please try again later.',
  },
});
app.use('/api/', limiter);

// ---------------------
// Health Check
// ---------------------
app.get('/health', (req, res) => {
  res.status(200).json({
    status: 'ok',
    timestamp: new Date().toISOString(),
    uptime: process.uptime(),
  });
});

// ---------------------
// Mount Routes
// ---------------------
app.use('/api/auth', authRoutes);
app.use('/api/profiles', profileRoutes);
app.use('/api/content', contentRoutes);
app.use('/api/progress', progressRoutes);
app.use('/api/admin', adminRoutes);
app.get('/api/rhymes/audio-url/:videoId', rhymeController.getAudioUrl);
app.get('/api/rhymes/audio-stream/:videoId', rhymeController.streamAudio);

// ---------------------
// 404 Handler
// ---------------------
app.use((req, res) => {
  res.status(404).json({
    success: false,
    message: `Route ${req.method} ${req.originalUrl} not found.`,
  });
});

// ---------------------
// Global Error Handler
// ---------------------
app.use((err, req, res, _next) => {
  console.error('Unhandled error:', err);

  const statusCode = err.statusCode || 500;
  const message =
    env.NODE_ENV === 'production' ? 'Internal server error' : err.message || 'Internal server error';

  res.status(statusCode).json({
    success: false,
    message,
    ...(env.NODE_ENV !== 'production' && { stack: err.stack }),
  });
});

// ---------------------
// Start Server
// ---------------------
const PORT = env.PORT;
const HOST = '0.0.0.0';

app.listen(PORT, HOST, () => {
  console.log(`
  =========================================
    Chhotu Genius API Server
  =========================================
    Environment : ${env.NODE_ENV}
    Port        : ${PORT}
    Health      : http://localhost:${PORT}/health
    API Base    : http://localhost:${PORT}/api
  =========================================
  `);
});

module.exports = app;
