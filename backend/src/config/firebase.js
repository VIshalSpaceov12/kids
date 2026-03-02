const admin = require('firebase-admin');
const path = require('path');
const fs = require('fs');

let initialized = false;

// Option 1: FIREBASE_SERVICE_ACCOUNT env var (JSON string) - used on Render/production
if (process.env.FIREBASE_SERVICE_ACCOUNT) {
  try {
    const serviceAccount = JSON.parse(process.env.FIREBASE_SERVICE_ACCOUNT);
    admin.initializeApp({
      credential: admin.credential.cert(serviceAccount),
    });
    initialized = true;
    console.log('Firebase Admin SDK initialized from environment variable.');
  } catch (err) {
    console.error('Failed to parse FIREBASE_SERVICE_ACCOUNT env var:', err.message);
  }
}

// Option 2: Local file - used in development
if (!initialized) {
  const serviceAccountPath = path.join(__dirname, '../../firebase-service-account.json');

  if (fs.existsSync(serviceAccountPath)) {
    const serviceAccount = require(serviceAccountPath);
    admin.initializeApp({
      credential: admin.credential.cert(serviceAccount),
    });
    initialized = true;
    console.log('Firebase Admin SDK initialized from local file.');
  }
}

if (!initialized) {
  console.warn('WARNING: Firebase Admin SDK is NOT initialized.');
  console.warn('Set FIREBASE_SERVICE_ACCOUNT env var or place firebase-service-account.json in backend/');
}

module.exports = admin;
