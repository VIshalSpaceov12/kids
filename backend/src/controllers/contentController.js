const db = require('../config/database');

/**
 * GET /api/content/modules
 * List all active modules with lesson count.
 */
async function getModules(req, res) {
  try {
    const modules = await db('modules')
      .where({ 'modules.is_active': true })
      .select(
        'modules.id',
        'modules.name',
        'modules.slug',
        'modules.description',
        'modules.icon',
        'modules.color',
        'modules.display_order'
      )
      .orderBy('modules.display_order', 'asc');

    // Get lesson counts for each module
    const lessonCounts = await db('lessons')
      .where({ is_active: true })
      .groupBy('module_id')
      .select('module_id')
      .count('* as lesson_count');

    const countMap = {};
    lessonCounts.forEach((row) => {
      countMap[row.module_id] = parseInt(row.lesson_count, 10);
    });

    const result = modules.map((m) => ({
      ...m,
      lessonCount: countMap[m.id] || 0,
    }));

    return res.status(200).json({
      success: true,
      modules: result,
    });
  } catch (error) {
    console.error('Get modules error:', error);
    return res.status(500).json({
      success: false,
      message: 'Internal server error',
    });
  }
}

/**
 * GET /api/content/modules/:slug/lessons
 * Get lessons for a module, optionally filtered by classLevel.
 */
async function getModuleLessons(req, res) {
  try {
    const { slug } = req.params;
    const { classLevel } = req.query;

    // Find the module
    const moduleRecord = await db('modules').where({ slug, is_active: true }).first();

    if (!moduleRecord) {
      return res.status(404).json({
        success: false,
        message: 'Module not found.',
      });
    }

    let query = db('lessons')
      .where({ module_id: moduleRecord.id, is_active: true })
      .select(
        'id',
        'title',
        'slug',
        'description',
        'difficulty_level',
        'class_range_min',
        'class_range_max',
        'display_order'
      )
      .orderBy('display_order', 'asc');

    // Filter by class level if provided
    if (classLevel) {
      query = query.where(function () {
        this.where('class_range_min', '<=', classLevel).andWhere(
          'class_range_max',
          '>=',
          classLevel
        );
      });
    }

    const lessons = await query;

    // Get question counts for each lesson
    const lessonIds = lessons.map((l) => l.id);
    const questionCounts = await db('questions')
      .whereIn('lesson_id', lessonIds)
      .where({ is_active: true })
      .groupBy('lesson_id')
      .select('lesson_id')
      .count('* as question_count');

    const qCountMap = {};
    questionCounts.forEach((row) => {
      qCountMap[row.lesson_id] = parseInt(row.question_count, 10);
    });

    const result = lessons.map((l) => ({
      ...l,
      questionCount: qCountMap[l.id] || 0,
    }));

    return res.status(200).json({
      success: true,
      module: {
        id: moduleRecord.id,
        name: moduleRecord.name,
        slug: moduleRecord.slug,
        description: moduleRecord.description,
        icon: moduleRecord.icon,
        color: moduleRecord.color,
      },
      lessons: result,
    });
  } catch (error) {
    console.error('Get module lessons error:', error);
    return res.status(500).json({
      success: false,
      message: 'Internal server error',
    });
  }
}

/**
 * GET /api/content/lessons/:id
 * Get a single lesson with its questions.
 */
async function getLesson(req, res) {
  try {
    const { id } = req.params;

    const lesson = await db('lessons')
      .where({ 'lessons.id': id, 'lessons.is_active': true })
      .join('modules', 'lessons.module_id', 'modules.id')
      .select(
        'lessons.*',
        'modules.name as module_name',
        'modules.slug as module_slug',
        'modules.icon as module_icon',
        'modules.color as module_color'
      )
      .first();

    if (!lesson) {
      return res.status(404).json({
        success: false,
        message: 'Lesson not found.',
      });
    }

    const questions = await db('questions')
      .where({ lesson_id: id, is_active: true })
      .select('id', 'type', 'question_data', 'correct_answer', 'media_urls', 'display_order')
      .orderBy('display_order', 'asc');

    return res.status(200).json({
      success: true,
      lesson: {
        ...lesson,
        questions,
      },
    });
  } catch (error) {
    console.error('Get lesson error:', error);
    return res.status(500).json({
      success: false,
      message: 'Internal server error',
    });
  }
}

/**
 * GET /api/content/lessons/:id/questions
 * Get questions for a lesson.
 */
async function getLessonQuestions(req, res) {
  try {
    const { id } = req.params;

    // Verify lesson exists
    const lesson = await db('lessons').where({ id, is_active: true }).first();
    if (!lesson) {
      return res.status(404).json({
        success: false,
        message: 'Lesson not found.',
      });
    }

    const questions = await db('questions')
      .where({ lesson_id: id, is_active: true })
      .select('id', 'type', 'question_data', 'correct_answer', 'media_urls', 'display_order')
      .orderBy('display_order', 'asc');

    return res.status(200).json({
      success: true,
      lessonId: id,
      questions,
    });
  } catch (error) {
    console.error('Get lesson questions error:', error);
    return res.status(500).json({
      success: false,
      message: 'Internal server error',
    });
  }
}

module.exports = { getModules, getModuleLessons, getLesson, getLessonQuestions };
