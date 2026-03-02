const admin = require('../config/firebase');
const db = require('../config/database');
const jwt = require('jsonwebtoken');
const env = require('../config/env');

/**
 * Firebase authentication middleware for app users.
 * Extracts Firebase ID token from Authorization: Bearer <token> header.
 * Verifies the token with Firebase Admin SDK.
 * Looks up or auto-creates the user in the database.
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

    // Look up user by firebase_uid
    let user = await db('users').where({ firebase_uid: firebaseUid }).first();

    if (!user) {
      const name = decodedToken.name || decodedToken.email || 'User';
      const email = decodedToken.email || null;

      // Check if existing user has this email (migration from old auth)
      if (email) {
        user = await db('users').where({ email }).first();
        if (user) {
          await db('users').where({ id: user.id }).update({ firebase_uid: firebaseUid });
        }
      }

      if (!user) {
        try {
          const [newUser] = await db('users')
            .insert({ name, email, firebase_uid: firebaseUid, role: 'user' })
            .returning('*');
          user = newUser;
        } catch (err) {
          if (err.code === '23505') {
            // Race condition: another request just created it
            user = await db('users').where({ firebase_uid: firebaseUid }).first();
          }
          if (!user) throw err;
        }
      }
    }

    req.user = {
      id: user.id,
      firebaseUid: decodedToken.uid,
      firebaseName: decodedToken.name || null,
      firebaseEmail: decodedToken.email || null,
      name: user.name,
      email: user.email,
      role: user.role,
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
