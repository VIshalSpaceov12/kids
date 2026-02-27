const express = require('express');
const Joi = require('joi');
const validate = require('../middleware/validate');
const { authenticate } = require('../middleware/auth');
const progressController = require('../controllers/progressController');

const router = express.Router();

// All progress routes require authentication
router.use(authenticate);

// Validation schemas
const saveProgressSchema = Joi.object({
  childId: Joi.string().uuid().required().messages({
    'string.guid': 'Child ID must be a valid UUID',
    'any.required': 'Child ID is required',
  }),
  lessonId: Joi.string().uuid().required().messages({
    'string.guid': 'Lesson ID must be a valid UUID',
    'any.required': 'Lesson ID is required',
  }),
  score: Joi.number().integer().min(0).max(100).required().messages({
    'number.min': 'Score must be at least 0',
    'number.max': 'Score must be at most 100',
    'any.required': 'Score is required',
  }),
  stars: Joi.number().integer().min(0).max(3).required().messages({
    'number.min': 'Stars must be at least 0',
    'number.max': 'Stars must be at most 3',
    'any.required': 'Stars are required',
  }),
  completed: Joi.boolean().optional().default(false),
});

const syncProgressSchema = Joi.object({
  entries: Joi.array()
    .items(
      Joi.object({
        childId: Joi.string().uuid().required(),
        lessonId: Joi.string().uuid().required(),
        score: Joi.number().integer().min(0).max(100).optional().default(0),
        stars: Joi.number().integer().min(0).max(3).optional().default(0),
        completedAt: Joi.string().isoDate().allow(null).optional(),
      })
    )
    .min(1)
    .required()
    .messages({
      'array.min': 'At least one progress entry is required',
      'any.required': 'Entries array is required',
    }),
});

// Routes
router.post('/', validate(saveProgressSchema), progressController.saveProgress);
router.get('/:childId', progressController.getChildProgress);
router.get('/:childId/module/:moduleSlug', progressController.getModuleProgress);
router.post('/sync', validate(syncProgressSchema), progressController.syncProgress);

module.exports = router;
