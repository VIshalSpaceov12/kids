const express = require('express');
const Joi = require('joi');
const validate = require('../middleware/validate');
const { authenticate } = require('../middleware/auth');
const profileController = require('../controllers/profileController');

const router = express.Router();

// All profile routes require authentication
router.use(authenticate);

// Validation schemas
const updateProfileSchema = Joi.object({
  name: Joi.string().min(2).max(100).optional(),
  email: Joi.string().email().allow(null, '').optional(),
  phone: Joi.string()
    .pattern(/^[+]?[\d\s-]{7,20}$/)
    .allow(null, '')
    .optional(),
  age: Joi.number().integer().min(2).max(100).optional(),
  classLevel: Joi.string()
    .valid('nursery', 'lkg', 'ukg', 'kg', 'class1', 'class2', 'class3', 'class4', 'class5')
    .optional(),
  avatar: Joi.string().max(50).optional(),
  pet: Joi.string().max(50).optional(),
  language: Joi.string().max(5).optional(),
}).min(1).messages({
  'object.min': 'At least one field must be provided for update',
});

// Routes
router.get('/me', profileController.getProfile);
router.put('/me', validate(updateProfileSchema), profileController.updateProfile);

module.exports = router;
