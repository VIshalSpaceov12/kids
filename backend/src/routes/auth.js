const express = require('express');
const Joi = require('joi');
const validate = require('../middleware/validate');
const { authenticate } = require('../middleware/auth');
const authController = require('../controllers/authController');

const router = express.Router();

// Validation schemas
const registerSchema = Joi.object({
  name: Joi.string().min(2).max(100).required().messages({
    'string.min': 'Name must be at least 2 characters',
    'string.max': 'Name must be at most 100 characters',
    'any.required': 'Name is required',
  }),
  phone: Joi.string()
    .pattern(/^[+]?[\d\s-]{7,20}$/)
    .allow(null, '')
    .optional()
    .messages({
      'string.pattern.base': 'Phone must be a valid phone number',
    }),
  email: Joi.string().email().allow(null, '').optional().messages({
    'string.email': 'Email must be a valid email address',
  }),
  password: Joi.string().min(6).optional(),
}).custom((value, helpers) => {
  if (!value.phone && !value.email) {
    return helpers.error('any.custom', { message: 'Either phone or email is required' });
  }
  return value;
}).messages({
  'any.custom': '{{#message}}',
});

const loginSchema = Joi.object({
  email: Joi.string().email().required().messages({
    'string.email': 'Email must be a valid email address',
    'any.required': 'Email is required',
  }),
  password: Joi.string().min(6).required().messages({
    'string.min': 'Password must be at least 6 characters',
    'any.required': 'Password is required',
  }),
});

const verifyOtpSchema = Joi.object({
  parentId: Joi.string().uuid().required().messages({
    'string.guid': 'Parent ID must be a valid UUID',
    'any.required': 'Parent ID is required',
  }),
  otp: Joi.string().length(4).required().messages({
    'string.length': 'OTP must be exactly 4 digits',
    'any.required': 'OTP is required',
  }),
});

const refreshSchema = Joi.object({
  token: Joi.string().required().messages({
    'any.required': 'Token is required',
  }),
});

const setPinSchema = Joi.object({
  pin: Joi.string()
    .pattern(/^\d{4}$/)
    .required()
    .messages({
      'string.pattern.base': 'PIN must be exactly 4 digits',
      'any.required': 'PIN is required',
    }),
});

// Routes
router.post('/register', validate(registerSchema), authController.register);
router.post('/login', validate(loginSchema), authController.login);
router.post('/verify-otp', validate(verifyOtpSchema), authController.verifyOtpHandler);
router.post('/refresh', validate(refreshSchema), authController.refresh);
router.post('/set-pin', authenticate, validate(setPinSchema), authController.setPin);
router.post('/firebase-sync', authenticate, authController.firebaseSync);

module.exports = router;
