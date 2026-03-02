const db = require('../config/database');

/**
 * POST /api/progress
 * Save or update progress for a user on a lesson.
 */
async function saveProgress(req, res) {
  try {
    const userId = req.user.id;
    const { lessonId, score, stars, completed } = req.body;

    // Verify lesson exists
    const lesson = await db('lessons').where({ id: lessonId, is_active: true }).first();
    if (!lesson) {
      return res.status(404).json({
        success: false,
        message: 'Lesson not found.',
      });
    }

    // Check if progress already exists
    const existing = await db('progress')
      .where({ user_id: userId, lesson_id: lessonId })
      .first();

    let progress;

    if (existing) {
      const updateData = {
        score: Math.max(existing.score, score),
        stars: Math.max(existing.stars, stars),
        attempts: existing.attempts + 1,
        updated_at: new Date(),
      };

      if (completed && !existing.completed) {
        updateData.completed = true;
        updateData.completed_at = new Date();
      }

      [progress] = await db('progress')
        .where({ id: existing.id })
        .update(updateData)
        .returning('*');
    } else {
      [progress] = await db('progress')
        .insert({
          user_id: userId,
          lesson_id: lessonId,
          score,
          stars,
          completed: completed || false,
          completed_at: completed ? new Date() : null,
        })
        .returning('*');
    }

    return res.status(200).json({
      success: true,
      progress,
    });
  } catch (error) {
    console.error('Save progress error:', error);
    return res.status(500).json({
      success: false,
      message: 'Internal server error',
    });
  }
}

/**
 * GET /api/progress
 * Get all progress for the authenticated user.
 */
async function getUserProgress(req, res) {
  try {
    const userId = req.user.id;

    const progress = await db('progress')
      .where({ 'progress.user_id': userId })
      .join('lessons', 'progress.lesson_id', 'lessons.id')
      .join('modules', 'lessons.module_id', 'modules.id')
      .select(
        'progress.id',
        'progress.score',
        'progress.stars',
        'progress.completed',
        'progress.attempts',
        'progress.completed_at',
        'progress.created_at',
        'lessons.id as lesson_id',
        'lessons.title as lesson_title',
        'lessons.slug as lesson_slug',
        'modules.id as module_id',
        'modules.name as module_name',
        'modules.slug as module_slug',
        'modules.icon as module_icon',
        'modules.color as module_color'
      )
      .orderBy('progress.updated_at', 'desc');

    // Compute summary
    const totalLessons = await db('lessons').where({ is_active: true }).count('* as count').first();
    const completedCount = progress.filter((p) => p.completed).length;
    const totalStars = progress.reduce((sum, p) => sum + p.stars, 0);

    return res.status(200).json({
      success: true,
      summary: {
        totalLessons: parseInt(totalLessons.count, 10),
        completedLessons: completedCount,
        totalStars,
      },
      progress,
    });
  } catch (error) {
    console.error('Get user progress error:', error);
    return res.status(500).json({
      success: false,
      message: 'Internal server error',
    });
  }
}

/**
 * GET /api/progress/module/:moduleSlug
 * Get progress for a specific module.
 */
async function getModuleProgress(req, res) {
  try {
    const userId = req.user.id;
    const { moduleSlug } = req.params;

    const moduleRecord = await db('modules').where({ slug: moduleSlug, is_active: true }).first();
    if (!moduleRecord) {
      return res.status(404).json({
        success: false,
        message: 'Module not found.',
      });
    }

    const lessons = await db('lessons')
      .where({ module_id: moduleRecord.id, is_active: true })
      .select('id', 'title', 'slug', 'difficulty_level', 'display_order')
      .orderBy('display_order', 'asc');

    const lessonIds = lessons.map((l) => l.id);
    const progressRows = await db('progress')
      .where({ user_id: userId })
      .whereIn('lesson_id', lessonIds)
      .select('*');

    const progressMap = {};
    progressRows.forEach((p) => {
      progressMap[p.lesson_id] = p;
    });

    const lessonsWithProgress = lessons.map((l) => ({
      ...l,
      progress: progressMap[l.id] || null,
      completed: progressMap[l.id] ? progressMap[l.id].completed : false,
      stars: progressMap[l.id] ? progressMap[l.id].stars : 0,
      score: progressMap[l.id] ? progressMap[l.id].score : 0,
    }));

    const completedCount = lessonsWithProgress.filter((l) => l.completed).length;
    const totalStars = lessonsWithProgress.reduce((sum, l) => sum + l.stars, 0);
    const maxStars = lessons.length * 3;
    const completionPercentage =
      lessons.length > 0 ? Math.round((completedCount / lessons.length) * 100) : 0;

    return res.status(200).json({
      success: true,
      module: {
        id: moduleRecord.id,
        name: moduleRecord.name,
        slug: moduleRecord.slug,
        icon: moduleRecord.icon,
        color: moduleRecord.color,
      },
      stats: {
        totalLessons: lessons.length,
        completedLessons: completedCount,
        completionPercentage,
        totalStars,
        maxStars,
      },
      lessons: lessonsWithProgress,
    });
  } catch (error) {
    console.error('Get module progress error:', error);
    return res.status(500).json({
      success: false,
      message: 'Internal server error',
    });
  }
}

/**
 * POST /api/progress/sync
 * Bulk upsert progress entries (for offline sync).
 */
async function syncProgress(req, res) {
  try {
    const userId = req.user.id;
    const { entries } = req.body;

    const results = [];

    for (const entry of entries) {
      const { lessonId, score, stars, completedAt } = entry;

      const existing = await db('progress')
        .where({ user_id: userId, lesson_id: lessonId })
        .first();

      if (existing) {
        const updateData = {
          score: Math.max(existing.score, score || 0),
          stars: Math.max(existing.stars, stars || 0),
          attempts: existing.attempts + 1,
          updated_at: new Date(),
        };

        if (completedAt && !existing.completed) {
          updateData.completed = true;
          updateData.completed_at = new Date(completedAt);
        }

        await db('progress').where({ id: existing.id }).update(updateData);
        results.push({ lessonId, success: true, action: 'updated' });
      } else {
        await db('progress').insert({
          user_id: userId,
          lesson_id: lessonId,
          score: score || 0,
          stars: stars || 0,
          completed: !!completedAt,
          completed_at: completedAt ? new Date(completedAt) : null,
        });
        results.push({ lessonId, success: true, action: 'created' });
      }
    }

    return res.status(200).json({
      success: true,
      message: `Synced ${results.filter((r) => r.success).length} of ${entries.length} entries.`,
      results,
    });
  } catch (error) {
    console.error('Sync progress error:', error);
    return res.status(500).json({
      success: false,
      message: 'Internal server error',
    });
  }
}

module.exports = { saveProgress, getUserProgress, getModuleProgress, syncProgress };
