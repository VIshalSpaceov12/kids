const jwt = require('jsonwebtoken');
const bcrypt = require('bcryptjs');
const db = require('../config/database');
const env = require('../config/env');
const { generateOtp, verifyOtp } = require('../utils/otp');

/**
 * POST /api/auth/register
 * Register a new parent with phone/email and send OTP.
 */
async function register(req, res) {
  try {
    const { phone, email, name, password } = req.body;

    // Check if parent already exists by phone or email
    let existing = null;
    if (phone) {
      existing = await db('parents').where({ phone }).first();
    }
    if (!existing && email) {
      existing = await db('parents').where({ email }).first();
    }

    if (existing) {
      // Parent exists, re-send OTP
      const otp = generateOtp(existing.id);
      const otpExpiresAt = new Date(Date.now() + 5 * 60 * 1000);

      await db('parents').where({ id: existing.id }).update({
        otp,
        otp_expires_at: otpExpiresAt,
        updated_at: new Date(),
      });

      return res.status(200).json({
        success: true,
        message: 'OTP sent successfully',
        parentId: existing.id,
      });
    }

    // Hash password if provided
    let passwordHash = null;
    if (password) {
      passwordHash = await bcrypt.hash(password, 10);
    }

    // Create new parent
    const [parent] = await db('parents')
      .insert({
        name,
        phone: phone || null,
        email: email || null,
        password_hash: passwordHash,
      })
      .returning('*');

    // Generate and store OTP
    const otp = generateOtp(parent.id);
    const otpExpiresAt = new Date(Date.now() + 5 * 60 * 1000);

    await db('parents').where({ id: parent.id }).update({
      otp,
      otp_expires_at: otpExpiresAt,
    });

    // In production, send OTP via SMS/email here
    console.log(`[DEV] OTP for parent ${parent.id}: ${otp}`);

    return res.status(201).json({
      success: true,
      message: 'OTP sent successfully',
      parentId: parent.id,
    });
  } catch (error) {
    console.error('Register error:', error);

    if (error.code === '23505') {
      return res.status(409).json({
        success: false,
        message: 'An account with this phone or email already exists.',
      });
    }

    return res.status(500).json({
      success: false,
      message: 'Internal server error',
    });
  }
}

/**
 * POST /api/auth/verify-otp
 * Verify OTP and return JWT token.
 */
async function verifyOtpHandler(req, res) {
  try {
    const { parentId, otp } = req.body;

    const parent = await db('parents').where({ id: parentId }).first();

    if (!parent) {
      return res.status(404).json({
        success: false,
        message: 'Parent not found.',
      });
    }

    // Verify OTP
    const isValid = verifyOtp(parentId, otp);

    if (!isValid) {
      return res.status(400).json({
        success: false,
        message: 'Invalid or expired OTP.',
      });
    }

    // Clear OTP from database
    await db('parents').where({ id: parentId }).update({
      otp: null,
      otp_expires_at: null,
      updated_at: new Date(),
    });

    // Generate JWT
    const token = jwt.sign(
      {
        id: parent.id,
        name: parent.name,
        email: parent.email,
        phone: parent.phone,
        type: 'parent',
      },
      env.JWT_SECRET,
      { expiresIn: env.JWT_EXPIRES_IN }
    );

    return res.status(200).json({
      success: true,
      token,
      parent: {
        id: parent.id,
        name: parent.name,
        email: parent.email,
        phone: parent.phone,
      },
    });
  } catch (error) {
    console.error('Verify OTP error:', error);
    return res.status(500).json({
      success: false,
      message: 'Internal server error',
    });
  }
}

/**
 * POST /api/auth/refresh
 * Refresh a JWT token.
 */
async function refresh(req, res) {
  try {
    const { token } = req.body;

    // Verify existing token (allow expired tokens to be refreshed)
    let decoded;
    try {
      decoded = jwt.verify(token, env.JWT_SECRET, { ignoreExpiration: true });
    } catch (error) {
      return res.status(401).json({
        success: false,
        message: 'Invalid token.',
      });
    }

    // Verify parent still exists
    const parent = await db('parents').where({ id: decoded.id }).first();
    if (!parent) {
      return res.status(404).json({
        success: false,
        message: 'User not found.',
      });
    }

    // Generate new token
    const newToken = jwt.sign(
      {
        id: parent.id,
        name: parent.name,
        email: parent.email,
        phone: parent.phone,
        type: 'parent',
      },
      env.JWT_SECRET,
      { expiresIn: env.JWT_EXPIRES_IN }
    );

    return res.status(200).json({
      success: true,
      token: newToken,
    });
  } catch (error) {
    console.error('Refresh token error:', error);
    return res.status(500).json({
      success: false,
      message: 'Internal server error',
    });
  }
}

/**
 * POST /api/auth/set-pin
 * Set a 4-digit PIN for the authenticated parent.
 */
async function setPin(req, res) {
  try {
    const { pin } = req.body;
    const parentId = req.user.id;

    // Hash the PIN
    const pinHash = await bcrypt.hash(pin, 10);

    await db('parents').where({ id: parentId }).update({
      pin_hash: pinHash,
      updated_at: new Date(),
    });

    return res.status(200).json({
      success: true,
      message: 'PIN set successfully',
    });
  } catch (error) {
    console.error('Set PIN error:', error);
    return res.status(500).json({
      success: false,
      message: 'Internal server error',
    });
  }
}

/**
 * POST /api/auth/login
 * Authenticate a parent with email and password.
 */
async function login(req, res) {
  try {
    const { email, password } = req.body;

    // Look up parent by email
    const parent = await db('parents').where({ email }).first();

    if (!parent || !parent.password_hash) {
      return res.status(401).json({
        success: false,
        message: 'Invalid email or password.',
      });
    }

    // Verify password
    const isMatch = await bcrypt.compare(password, parent.password_hash);

    if (!isMatch) {
      return res.status(401).json({
        success: false,
        message: 'Invalid email or password.',
      });
    }

    // Generate JWT
    const token = jwt.sign(
      {
        id: parent.id,
        name: parent.name,
        email: parent.email,
        phone: parent.phone,
        type: 'parent',
      },
      env.JWT_SECRET,
      { expiresIn: env.JWT_EXPIRES_IN }
    );

    return res.status(200).json({
      success: true,
      token,
      parent: {
        id: parent.id,
        name: parent.name,
        email: parent.email,
        phone: parent.phone,
      },
    });
  } catch (error) {
    console.error('Login error:', error);
    return res.status(500).json({
      success: false,
      message: 'Internal server error',
    });
  }
}

/**
 * POST /api/auth/firebase-sync
 * Sync parent data from Firebase to the local database.
 * Protected by authenticate middleware (req.user exists).
 * Updates the parent's name and email from Firebase data.
 */
async function firebaseSync(req, res) {
  try {
    const { id, firebaseUid } = req.user;

    // Update parent with latest Firebase info
    await db('parents').where({ id }).update({
      name: req.user.name,
      email: req.user.email,
      firebase_uid: firebaseUid,
      updated_at: new Date(),
    });

    const parent = await db('parents').where({ id }).first();

    return res.status(200).json({
      success: true,
      parent: {
        id: parent.id,
        name: parent.name,
        email: parent.email,
      },
    });
  } catch (error) {
    console.error('Firebase sync error:', error);
    return res.status(500).json({
      success: false,
      message: 'Internal server error',
    });
  }
}

module.exports = { register, verifyOtpHandler, refresh, setPin, login, firebaseSync };
