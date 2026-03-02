const jwt = require('jsonwebtoken');
const bcrypt = require('bcryptjs');
const db = require('../config/database');
const env = require('../config/env');
const { generateOtp, verifyOtp } = require('../utils/otp');

/**
 * POST /api/auth/register
 * Register a new user with phone/email and send OTP.
 */
async function register(req, res) {
  try {
    const { phone, email, name, password } = req.body;

    // Check if user already exists by phone or email
    let existing = null;
    if (phone) {
      existing = await db('users').where({ phone }).first();
    }
    if (!existing && email) {
      existing = await db('users').where({ email }).first();
    }

    if (existing) {
      const otp = generateOtp(existing.id);
      const otpExpiresAt = new Date(Date.now() + 5 * 60 * 1000);

      await db('users').where({ id: existing.id }).update({
        otp,
        otp_expires_at: otpExpiresAt,
        updated_at: new Date(),
      });

      return res.status(200).json({
        success: true,
        message: 'OTP sent successfully',
        userId: existing.id,
      });
    }

    // Hash password if provided
    let passwordHash = null;
    if (password) {
      passwordHash = await bcrypt.hash(password, 10);
    }

    // Create new user
    const [user] = await db('users')
      .insert({
        name,
        phone: phone || null,
        email: email || null,
        password_hash: passwordHash,
        role: 'user',
      })
      .returning('*');

    // Generate and store OTP
    const otp = generateOtp(user.id);
    const otpExpiresAt = new Date(Date.now() + 5 * 60 * 1000);

    await db('users').where({ id: user.id }).update({
      otp,
      otp_expires_at: otpExpiresAt,
    });

    console.log(`[DEV] OTP for user ${user.id}: ${otp}`);

    return res.status(201).json({
      success: true,
      message: 'OTP sent successfully',
      userId: user.id,
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
    const { userId, otp } = req.body;

    const user = await db('users').where({ id: userId }).first();

    if (!user) {
      return res.status(404).json({
        success: false,
        message: 'User not found.',
      });
    }

    const isValid = verifyOtp(userId, otp);

    if (!isValid) {
      return res.status(400).json({
        success: false,
        message: 'Invalid or expired OTP.',
      });
    }

    await db('users').where({ id: userId }).update({
      otp: null,
      otp_expires_at: null,
      updated_at: new Date(),
    });

    const token = jwt.sign(
      {
        id: user.id,
        name: user.name,
        email: user.email,
        phone: user.phone,
        role: user.role,
      },
      env.JWT_SECRET,
      { expiresIn: env.JWT_EXPIRES_IN }
    );

    return res.status(200).json({
      success: true,
      token,
      user: {
        id: user.id,
        name: user.name,
        email: user.email,
        phone: user.phone,
        role: user.role,
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

    let decoded;
    try {
      decoded = jwt.verify(token, env.JWT_SECRET, { ignoreExpiration: true });
    } catch (error) {
      return res.status(401).json({
        success: false,
        message: 'Invalid token.',
      });
    }

    const user = await db('users').where({ id: decoded.id }).first();
    if (!user) {
      return res.status(404).json({
        success: false,
        message: 'User not found.',
      });
    }

    const newToken = jwt.sign(
      {
        id: user.id,
        name: user.name,
        email: user.email,
        phone: user.phone,
        role: user.role,
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
 * Set a 4-digit PIN for the authenticated user.
 */
async function setPin(req, res) {
  try {
    const { pin } = req.body;
    const userId = req.user.id;

    const pinHash = await bcrypt.hash(pin, 10);

    await db('users').where({ id: userId }).update({
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
 * Authenticate a user with email and password.
 */
async function login(req, res) {
  try {
    const { email, password } = req.body;

    const user = await db('users').where({ email }).first();

    if (!user || !user.password_hash) {
      return res.status(401).json({
        success: false,
        message: 'Invalid email or password.',
      });
    }

    const isMatch = await bcrypt.compare(password, user.password_hash);

    if (!isMatch) {
      return res.status(401).json({
        success: false,
        message: 'Invalid email or password.',
      });
    }

    const token = jwt.sign(
      {
        id: user.id,
        name: user.name,
        email: user.email,
        phone: user.phone,
        role: user.role,
      },
      env.JWT_SECRET,
      { expiresIn: env.JWT_EXPIRES_IN }
    );

    return res.status(200).json({
      success: true,
      token,
      user: {
        id: user.id,
        name: user.name,
        email: user.email,
        phone: user.phone,
        role: user.role,
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
 * Sync user data from Firebase to the local database.
 */
async function firebaseSync(req, res) {
  try {
    const { id, firebaseUid } = req.user;

    await db('users').where({ id }).update({
      name: req.user.firebaseName || req.user.name,
      email: req.user.firebaseEmail || req.user.email,
      firebase_uid: firebaseUid,
      updated_at: new Date(),
    });

    const user = await db('users').where({ id }).first();

    return res.status(200).json({
      success: true,
      user: {
        id: user.id,
        name: user.name,
        email: user.email,
        role: user.role,
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
