const jwt = require('jsonwebtoken');
const bcrypt = require('bcryptjs');
const db = require('../config/database');
const env = require('../config/env');

/**
 * POST /api/admin/login
 * Admin login with email and password.
 */
async function login(req, res) {
  try {
    const { email, password } = req.body;

    const user = await db('users')
      .where({ email, role: 'admin', is_active: true })
      .first();

    if (!user) {
      return res.status(401).json({
        success: false,
        message: 'Invalid email or password.',
      });
    }

    const isValidPassword = await bcrypt.compare(password, user.password_hash);
    if (!isValidPassword) {
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
        role: user.role,
        type: 'admin',
      },
      env.JWT_SECRET,
      { expiresIn: '24h' }
    );

    return res.status(200).json({
      success: true,
      token,
      admin: {
        id: user.id,
        name: user.name,
        email: user.email,
        role: user.role,
      },
    });
  } catch (error) {
    console.error('Admin login error:', error);
    return res.status(500).json({
      success: false,
      message: 'Internal server error',
    });
  }
}

/**
 * GET /api/admin/dashboard
 * Dashboard statistics.
 */
async function dashboard(req, res) {
  try {
    // Total users (non-admin)
    const totalUsersResult = await db('users').where({ role: 'user' }).count('* as count').first();
    const totalUsers = parseInt(totalUsersResult.count, 10);

    // Active today
    const today = new Date();
    today.setHours(0, 0, 0, 0);
    const activeTodayResult = await db('users')
      .where({ role: 'user' })
      .where('updated_at', '>=', today)
      .count('* as count')
      .first();
    const activeToday = parseInt(activeTodayResult.count, 10);

    // New this week
    const weekAgo = new Date();
    weekAgo.setDate(weekAgo.getDate() - 7);
    const newThisWeekResult = await db('users')
      .where({ role: 'user' })
      .where('created_at', '>=', weekAgo)
      .count('* as count')
      .first();
    const newThisWeek = parseInt(newThisWeekResult.count, 10);

    // Module engagement
    const moduleEngagement = await db('modules')
      .leftJoin('lessons', 'modules.id', 'lessons.module_id')
      .leftJoin('progress', 'lessons.id', 'progress.lesson_id')
      .where({ 'modules.is_active': true })
      .groupBy('modules.id', 'modules.name', 'modules.slug', 'modules.icon', 'modules.color')
      .select(
        'modules.id',
        'modules.name',
        'modules.slug',
        'modules.icon',
        'modules.color'
      )
      .count('progress.id as total_attempts')
      .countDistinct('progress.user_id as unique_learners')
      .orderBy('modules.display_order', 'asc');

    return res.status(200).json({
      success: true,
      stats: {
        totalUsers,
        activeToday,
        newThisWeek,
      },
      moduleEngagement: moduleEngagement.map((m) => ({
        id: m.id,
        name: m.name,
        slug: m.slug,
        icon: m.icon,
        color: m.color,
        totalAttempts: parseInt(m.total_attempts, 10),
        uniqueLearners: parseInt(m.unique_learners, 10),
      })),
    });
  } catch (error) {
    console.error('Dashboard error:', error);
    return res.status(500).json({
      success: false,
      message: 'Internal server error',
    });
  }
}

/**
 * GET /api/admin/users
 * Paginated list of users.
 */
async function getUsers(req, res) {
  try {
    const page = parseInt(req.query.page, 10) || 1;
    const limit = parseInt(req.query.limit, 10) || 20;
    const search = req.query.search || '';
    const role = req.query.role || '';
    const offset = (page - 1) * limit;

    let query = db('users').select(
      'id', 'name', 'email', 'phone', 'role', 'age', 'class_level', 'is_active', 'created_at'
    );

    if (search) {
      query = query.where(function () {
        this.where('name', 'ilike', `%${search}%`)
          .orWhere('email', 'ilike', `%${search}%`)
          .orWhere('phone', 'ilike', `%${search}%`);
      });
    }

    if (role) {
      query = query.where({ role });
    }

    const countQuery = query.clone();
    const totalResult = await countQuery.clearSelect().count('id as count').first();
    const total = parseInt(totalResult.count, 10);

    const users = await query.orderBy('created_at', 'desc').limit(limit).offset(offset);

    return res.status(200).json({
      success: true,
      users,
      pagination: {
        page,
        limit,
        total,
        totalPages: Math.ceil(total / limit),
      },
    });
  } catch (error) {
    console.error('Get users error:', error);
    return res.status(500).json({
      success: false,
      message: 'Internal server error',
    });
  }
}

/**
 * GET /api/admin/users/:id
 * Detailed user profile with progress.
 */
async function getUserDetail(req, res) {
  try {
    const { id } = req.params;

    const user = await db('users')
      .where({ id })
      .select('id', 'name', 'email', 'phone', 'role', 'age', 'class_level', 'avatar', 'pet', 'language', 'is_active', 'created_at', 'updated_at')
      .first();

    if (!user) {
      return res.status(404).json({
        success: false,
        message: 'User not found.',
      });
    }

    // Get progress
    const progress = await db('progress')
      .where({ 'progress.user_id': id })
      .join('lessons', 'progress.lesson_id', 'lessons.id')
      .join('modules', 'lessons.module_id', 'modules.id')
      .select(
        'progress.score',
        'progress.stars',
        'progress.completed',
        'progress.attempts',
        'lessons.title as lesson_title',
        'modules.name as module_name'
      );

    const totalStars = progress.reduce((sum, p) => sum + p.stars, 0);
    const completedLessons = progress.filter((p) => p.completed).length;

    return res.status(200).json({
      success: true,
      user: {
        ...user,
        stats: {
          totalStars,
          completedLessons,
          totalAttempts: progress.reduce((sum, p) => sum + p.attempts, 0),
        },
      },
      progress,
    });
  } catch (error) {
    console.error('Get user detail error:', error);
    return res.status(500).json({
      success: false,
      message: 'Internal server error',
    });
  }
}

/**
 * GET /api/admin/content/modules
 * List modules with lesson and question counts.
 */
async function getContentModules(req, res) {
  try {
    const modules = await db('modules')
      .select('*')
      .orderBy('display_order', 'asc');

    const modulesWithCounts = await Promise.all(
      modules.map(async (m) => {
        const lessonCountResult = await db('lessons')
          .where({ module_id: m.id })
          .count('* as count')
          .first();

        const questionCountResult = await db('questions')
          .join('lessons', 'questions.lesson_id', 'lessons.id')
          .where({ 'lessons.module_id': m.id })
          .count('questions.id as count')
          .first();

        return {
          ...m,
          lessonCount: parseInt(lessonCountResult.count, 10),
          questionCount: parseInt(questionCountResult.count, 10),
        };
      })
    );

    return res.status(200).json({
      success: true,
      modules: modulesWithCounts,
    });
  } catch (error) {
    console.error('Get content modules error:', error);
    return res.status(500).json({
      success: false,
      message: 'Internal server error',
    });
  }
}

/**
 * POST /api/admin/content/lessons
 */
async function createLesson(req, res) {
  try {
    const { moduleId, title, slug, description, difficultyLevel, classRangeMin, classRangeMax, contentJson, displayOrder } = req.body;

    const moduleRecord = await db('modules').where({ id: moduleId }).first();
    if (!moduleRecord) {
      return res.status(404).json({ success: false, message: 'Module not found.' });
    }

    const [lesson] = await db('lessons')
      .insert({
        module_id: moduleId, title, slug,
        description: description || null,
        difficulty_level: difficultyLevel || 1,
        class_range_min: classRangeMin || null,
        class_range_max: classRangeMax || null,
        content_json: contentJson ? JSON.stringify(contentJson) : null,
        display_order: displayOrder || 0,
      })
      .returning('*');

    return res.status(201).json({ success: true, lesson });
  } catch (error) {
    console.error('Create lesson error:', error);
    if (error.code === '23505') {
      return res.status(409).json({ success: false, message: 'A lesson with this slug already exists in this module.' });
    }
    return res.status(500).json({ success: false, message: 'Internal server error' });
  }
}

/**
 * PUT /api/admin/content/lessons/:id
 */
async function updateLesson(req, res) {
  try {
    const { id } = req.params;
    const { title, slug, description, difficultyLevel, classRangeMin, classRangeMax, contentJson, displayOrder, isActive } = req.body;

    const lesson = await db('lessons').where({ id }).first();
    if (!lesson) {
      return res.status(404).json({ success: false, message: 'Lesson not found.' });
    }

    const updateData = { updated_at: new Date() };
    if (title !== undefined) updateData.title = title;
    if (slug !== undefined) updateData.slug = slug;
    if (description !== undefined) updateData.description = description;
    if (difficultyLevel !== undefined) updateData.difficulty_level = difficultyLevel;
    if (classRangeMin !== undefined) updateData.class_range_min = classRangeMin;
    if (classRangeMax !== undefined) updateData.class_range_max = classRangeMax;
    if (contentJson !== undefined) updateData.content_json = JSON.stringify(contentJson);
    if (displayOrder !== undefined) updateData.display_order = displayOrder;
    if (isActive !== undefined) updateData.is_active = isActive;

    const [updated] = await db('lessons').where({ id }).update(updateData).returning('*');
    return res.status(200).json({ success: true, lesson: updated });
  } catch (error) {
    console.error('Update lesson error:', error);
    return res.status(500).json({ success: false, message: 'Internal server error' });
  }
}

/**
 * POST /api/admin/content/questions
 */
async function createQuestion(req, res) {
  try {
    const { lessonId, type, questionData, correctAnswer, mediaUrls, displayOrder } = req.body;

    const lesson = await db('lessons').where({ id: lessonId }).first();
    if (!lesson) {
      return res.status(404).json({ success: false, message: 'Lesson not found.' });
    }

    const [question] = await db('questions')
      .insert({
        lesson_id: lessonId, type,
        question_data: JSON.stringify(questionData),
        correct_answer: JSON.stringify(correctAnswer),
        media_urls: mediaUrls ? JSON.stringify(mediaUrls) : null,
        display_order: displayOrder || 0,
      })
      .returning('*');

    return res.status(201).json({ success: true, question });
  } catch (error) {
    console.error('Create question error:', error);
    return res.status(500).json({ success: false, message: 'Internal server error' });
  }
}

/**
 * PUT /api/admin/content/questions/:id
 */
async function updateQuestion(req, res) {
  try {
    const { id } = req.params;
    const { type, questionData, correctAnswer, mediaUrls, displayOrder, isActive } = req.body;

    const question = await db('questions').where({ id }).first();
    if (!question) {
      return res.status(404).json({ success: false, message: 'Question not found.' });
    }

    const updateData = { updated_at: new Date() };
    if (type !== undefined) updateData.type = type;
    if (questionData !== undefined) updateData.question_data = JSON.stringify(questionData);
    if (correctAnswer !== undefined) updateData.correct_answer = JSON.stringify(correctAnswer);
    if (mediaUrls !== undefined) updateData.media_urls = JSON.stringify(mediaUrls);
    if (displayOrder !== undefined) updateData.display_order = displayOrder;
    if (isActive !== undefined) updateData.is_active = isActive;

    const [updated] = await db('questions').where({ id }).update(updateData).returning('*');
    return res.status(200).json({ success: true, question: updated });
  } catch (error) {
    console.error('Update question error:', error);
    return res.status(500).json({ success: false, message: 'Internal server error' });
  }
}

/**
 * DELETE /api/admin/content/questions/:id
 */
async function deleteQuestion(req, res) {
  try {
    const { id } = req.params;
    const question = await db('questions').where({ id }).first();
    if (!question) {
      return res.status(404).json({ success: false, message: 'Question not found.' });
    }
    await db('questions').where({ id }).del();
    return res.status(200).json({ success: true, message: 'Question deleted.' });
  } catch (error) {
    console.error('Delete question error:', error);
    return res.status(500).json({ success: false, message: 'Internal server error' });
  }
}

module.exports = {
  login, dashboard, getUsers, getUserDetail,
  getContentModules, createLesson, updateLesson,
  createQuestion, updateQuestion, deleteQuestion,
};
