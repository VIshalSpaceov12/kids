/**
 * OTP utility for MVP.
 * Uses a fixed OTP "1234" for development/testing.
 * Stores OTPs in an in-memory Map with expiry tracking.
 */

// In-memory OTP store: parentId -> { otp, expiresAt }
const otpStore = new Map();

// OTP validity duration in milliseconds (5 minutes)
const OTP_VALIDITY_MS = 5 * 60 * 1000;

/**
 * Generate an OTP for the given parent ID.
 * For MVP, always returns "1234".
 * Stores in memory with expiry.
 *
 * @param {string} parentId - The parent's UUID
 * @returns {string} The generated OTP
 */
function generateOtp(parentId) {
  const otp = '1234'; // Fixed for MVP
  const expiresAt = new Date(Date.now() + OTP_VALIDITY_MS);

  otpStore.set(parentId, { otp, expiresAt });

  return otp;
}

/**
 * Verify an OTP for the given parent ID.
 *
 * @param {string} parentId - The parent's UUID
 * @param {string} input - The OTP to verify
 * @returns {boolean} Whether the OTP is valid
 */
function verifyOtp(parentId, input) {
  const stored = otpStore.get(parentId);

  if (!stored) {
    // Fallback: accept "1234" for MVP even if not in store
    return input === '1234';
  }

  // Check expiry
  if (new Date() > stored.expiresAt) {
    otpStore.delete(parentId);
    return false;
  }

  const isValid = stored.otp === input;

  // Remove OTP after successful verification
  if (isValid) {
    otpStore.delete(parentId);
  }

  return isValid;
}

/**
 * Clear expired OTPs from the store.
 * Should be called periodically in production.
 */
function clearExpiredOtps() {
  const now = new Date();
  for (const [key, value] of otpStore.entries()) {
    if (now > value.expiresAt) {
      otpStore.delete(key);
    }
  }
}

// Clean up expired OTPs every 10 minutes
setInterval(clearExpiredOtps, 10 * 60 * 1000).unref();

module.exports = { generateOtp, verifyOtp, clearExpiredOtps };
