const express = require('express');
const Joi = require('joi');
const validate = require('../middleware/validate');
const { authenticateAdmin } = require('../middleware/auth');
const adminController = require('../controllers/adminController');

const router = express.Router();

// Validation schemas
const loginSchema = Joi.object({
  email: Joi.string().email().required().messages({
    'string.email': 'Email must be a valid email address',
    'any.required': 'Email is required',
  }),
  password: Joi.string().min(4).required().messages({
    'string.min': 'Password must be at least 4 characters',
    'any.required': 'Password is required',
  }),
});

const createLessonSchema = Joi.object({
  moduleId: Joi.string().uuid().required().messages({
    'string.guid': 'Module ID must be a valid UUID',
    'any.required': 'Module ID is required',
  }),
  title: Joi.string().min(1).max(200).required().messages({
    'any.required': 'Title is required',
  }),
  slug: Joi.string().min(1).max(100).required().messages({
    'any.required': 'Slug is required',
  }),
  description: Joi.string().allow(null, '').optional(),
  difficultyLevel: Joi.number().integer().min(1).max(5).optional().default(1),
  classRangeMin: Joi.string().max(20).allow(null, '').optional(),
  classRangeMax: Joi.string().max(20).allow(null, '').optional(),
  contentJson: Joi.object().allow(null).optional(),
  displayOrder: Joi.number().integer().optional().default(0),
});

const updateLessonSchema = Joi.object({
  title: Joi.string().min(1).max(200).optional(),
  slug: Joi.string().min(1).max(100).optional(),
  description: Joi.string().allow(null, '').optional(),
  difficultyLevel: Joi.number().integer().min(1).max(5).optional(),
  classRangeMin: Joi.string().max(20).allow(null, '').optional(),
  classRangeMax: Joi.string().max(20).allow(null, '').optional(),
  contentJson: Joi.object().allow(null).optional(),
  displayOrder: Joi.number().integer().optional(),
  isActive: Joi.boolean().optional(),
}).min(1);

const createQuestionSchema = Joi.object({
  lessonId: Joi.string().uuid().required().messages({
    'string.guid': 'Lesson ID must be a valid UUID',
    'any.required': 'Lesson ID is required',
  }),
  type: Joi.string()
    .valid('multiple_choice', 'fill_blank', 'ordering', 'tracing')
    .required()
    .messages({
      'any.only': 'Type must be one of: multiple_choice, fill_blank, ordering, tracing',
      'any.required': 'Question type is required',
    }),
  questionData: Joi.object().required().messages({
    'any.required': 'Question data is required',
  }),
  correctAnswer: Joi.object().required().messages({
    'any.required': 'Correct answer is required',
  }),
  mediaUrls: Joi.object().allow(null).optional(),
  displayOrder: Joi.number().integer().optional().default(0),
});

const updateQuestionSchema = Joi.object({
  type: Joi.string()
    .valid('multiple_choice', 'fill_blank', 'ordering', 'tracing')
    .optional(),
  questionData: Joi.object().optional(),
  correctAnswer: Joi.object().optional(),
  mediaUrls: Joi.object().allow(null).optional(),
  displayOrder: Joi.number().integer().optional(),
  isActive: Joi.boolean().optional(),
}).min(1);

// Public admin route
router.post('/login', validate(loginSchema), adminController.login);

// Protected admin routes
router.get('/dashboard', authenticateAdmin, adminController.dashboard);
router.get('/users', authenticateAdmin, adminController.getUsers);
router.get('/users/:id', authenticateAdmin, adminController.getUserDetail);
router.get('/content/modules', authenticateAdmin, adminController.getContentModules);
router.post(
  '/content/lessons',
  authenticateAdmin,
  validate(createLessonSchema),
  adminController.createLesson
);
router.put(
  '/content/lessons/:id',
  authenticateAdmin,
  validate(updateLessonSchema),
  adminController.updateLesson
);
router.post(
  '/content/questions',
  authenticateAdmin,
  validate(createQuestionSchema),
  adminController.createQuestion
);
router.put(
  '/content/questions/:id',
  authenticateAdmin,
  validate(updateQuestionSchema),
  adminController.updateQuestion
);
router.delete('/content/questions/:id', authenticateAdmin, adminController.deleteQuestion);

module.exports = router;
