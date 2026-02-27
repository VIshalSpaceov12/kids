const express = require('express');
const contentController = require('../controllers/contentController');

const router = express.Router();

// All content routes are public (no auth required)
router.get('/modules', contentController.getModules);
router.get('/modules/:slug/lessons', contentController.getModuleLessons);
router.get('/lessons/:id', contentController.getLesson);
router.get('/lessons/:id/questions', contentController.getLessonQuestions);

module.exports = router;
