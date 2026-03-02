const admin = require('../config/firebase');
const db = require('../config/database');
const jwt = require('jsonwebtoken');
const env = require('../config/env');

/**
 * Firebase authentication middleware for parent users.
 * Extracts Firebase ID token from Authorization: Bearer <token> header.
 * Verifies the token with Firebase Admin SDK.
 * Looks up or auto-creates the parent in the database.
 * Attaches user payload to req.user with DB UUID as id.
 */
async function authenticate(req, res, next) {
  const authHeader = req.headers.authorization;

  if (!authHeader || !authHeader.startsWith('Bearer ')) {
    return res.status(401).json({
      success: false,
      message: 'Access denied. No token provided.',
    });
  }

  const token = authHeader.split(' ')[1];

  try {
    // Verify Firebase ID token
    const decodedToken = await admin.auth().verifyIdToken(token);
    const firebaseUid = decodedToken.uid;

    // Look up parent by firebase_uid
    let parent = await db('parents').where({ firebase_uid: firebaseUid }).first();

    if (!parent) {
      const name = decodedToken.name || decodedToken.email || 'Parent';
      const email = decodedToken.email || null;

      // Check if existing parent has this email (migration from old auth)
      if (email) {
        parent = await db('parents').where({ email }).first();
        if (parent) {
          await db('parents').where({ id: parent.id }).update({ firebase_uid: firebaseUid });
        }
      }

      if (!parent) {
        try {
          const [newParent] = await db('parents')
            .insert({ name, email, firebase_uid: firebaseUid })
            .returning('*');
          parent = newParent;
        } catch (err) {
          if (err.code === '23505') {
            // Race condition: another request just created it
            parent = await db('parents').where({ firebase_uid: firebaseUid }).first();
          }
          if (!parent) throw err;
        }
      }
    }

    // Set req.user with DB UUID so downstream controllers work unchanged
    // Include Firebase token claims for firebaseSync to use
    req.user = {
      id: parent.id,
      firebaseUid: decodedToken.uid,
      firebaseName: decodedToken.name || null,
      firebaseEmail: decodedToken.email || null,
      name: parent.name,
      email: parent.email,
      type: 'parent',
    };

    next();
  } catch (error) {
    console.error('Firebase auth error:', error.message);
    return res.status(401).json({
      success: false,
      message: 'Invalid or expired Firebase token.',
    });
  }
}

/**
 * JWT authentication middleware for admin users.
 * Same as before - still JWT based for admin routes.
 */
function authenticateAdmin(req, res, next) {
  const authHeader = req.headers.authorization;

  if (!authHeader || !authHeader.startsWith('Bearer ')) {
    return res.status(401).json({
      success: false,
      message: 'Access denied. No token provided.',
    });
  }

  const token = authHeader.split(' ')[1];

  try {
    const decoded = jwt.verify(token, env.JWT_SECRET);

    if (decoded.role !== 'admin') {
      return res.status(403).json({
        success: false,
        message: 'Access denied. Admin privileges required.',
      });
    }

    req.admin = decoded;
    next();
  } catch (error) {
    return res.status(401).json({
      success: false,
      message: 'Invalid or expired token.',
    });
  }
}

module.exports = { authenticate, authenticateAdmin };
