const admin = require('firebase-admin');
const path = require('path');
const fs = require('fs');

const serviceAccountPath = path.join(__dirname, '../../firebase-service-account.json');

if (fs.existsSync(serviceAccountPath)) {
  const serviceAccount = require(serviceAccountPath);

  admin.initializeApp({
    credential: admin.credential.cert(serviceAccount),
  });

  console.log('Firebase Admin SDK initialized successfully.');
} else {
  console.warn(
    'WARNING: firebase-service-account.json not found at',
    serviceAccountPath
  );
  console.warn(
    'Firebase Admin SDK is NOT initialized. Firebase auth features will not work.'
  );
  console.warn(
    'Download the service account key from Firebase Console and place it at:',
    serviceAccountPath
  );
}

module.exports = admin;
