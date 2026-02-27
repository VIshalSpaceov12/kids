const db = require('../config/database');

/**
 * Helper: verify that a child belongs to the authenticated parent.
 */
async function verifyChildOwnership(parentId, childId) {
  const child = await db('children')
    .where({ id: childId, parent_id: parentId, is_active: true })
    .first();
  return child;
}

/**
 * POST /api/progress
 * Save or update progress for a child on a lesson.
 */
async function saveProgress(req, res) {
  try {
    const parentId = req.user.id;
    const { childId, lessonId, score, stars, completed } = req.body;

    // Verify child belongs to parent
    const child = await verifyChildOwnership(parentId, childId);
    if (!child) {
      return res.status(403).json({
        success: false,
        message: 'Child does not belong to this parent.',
      });
    }

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
      .where({ child_id: childId, lesson_id: lessonId })
      .first();

    let progress;

    if (existing) {
      // Update existing progress (keep best score)
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
      // Create new progress
      [progress] = await db('progress')
        .insert({
          child_id: childId,
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
 * GET /api/progress/:childId
 * Get all progress for a child.
 */
async function getChildProgress(req, res) {
  try {
    const parentId = req.user.id;
    const { childId } = req.params;

    // Verify child belongs to parent
    const child = await verifyChildOwnership(parentId, childId);
    if (!child) {
      return res.status(403).json({
        success: false,
        message: 'Child does not belong to this parent.',
      });
    }

    const progress = await db('progress')
      .where({ 'progress.child_id': childId })
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
      child: {
        id: child.id,
        name: child.name,
      },
      summary: {
        totalLessons: parseInt(totalLessons.count, 10),
        completedLessons: completedCount,
        totalStars,
      },
      progress,
    });
  } catch (error) {
    console.error('Get child progress error:', error);
    return res.status(500).json({
      success: false,
      message: 'Internal server error',
    });
  }
}

/**
 * GET /api/progress/:childId/module/:moduleSlug
 * Get progress for a specific module with stats.
 */
async function getModuleProgress(req, res) {
  try {
    const parentId = req.user.id;
    const { childId, moduleSlug } = req.params;

    // Verify child belongs to parent
    const child = await verifyChildOwnership(parentId, childId);
    if (!child) {
      return res.status(403).json({
        success: false,
        message: 'Child does not belong to this parent.',
      });
    }

    // Find module
    const moduleRecord = await db('modules').where({ slug: moduleSlug, is_active: true }).first();
    if (!moduleRecord) {
      return res.status(404).json({
        success: false,
        message: 'Module not found.',
      });
    }

    // Get all lessons in module
    const lessons = await db('lessons')
      .where({ module_id: moduleRecord.id, is_active: true })
      .select('id', 'title', 'slug', 'difficulty_level', 'display_order')
      .orderBy('display_order', 'asc');

    // Get progress for these lessons
    const lessonIds = lessons.map((l) => l.id);
    const progressRows = await db('progress')
      .where({ child_id: childId })
      .whereIn('lesson_id', lessonIds)
      .select('*');

    const progressMap = {};
    progressRows.forEach((p) => {
      progressMap[p.lesson_id] = p;
    });

    // Combine lessons with progress
    const lessonsWithProgress = lessons.map((l) => ({
      ...l,
      progress: progressMap[l.id] || null,
      completed: progressMap[l.id] ? progressMap[l.id].completed : false,
      stars: progressMap[l.id] ? progressMap[l.id].stars : 0,
      score: progressMap[l.id] ? progressMap[l.id].score : 0,
    }));

    // Stats
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
    const parentId = req.user.id;
    const { entries } = req.body;

    const results = [];

    for (const entry of entries) {
      const { childId, lessonId, score, stars, completedAt } = entry;

      // Verify child belongs to parent
      const child = await verifyChildOwnership(parentId, childId);
      if (!child) {
        results.push({
          childId,
          lessonId,
          success: false,
          message: 'Child does not belong to this parent.',
        });
        continue;
      }

      // Check if progress exists
      const existing = await db('progress')
        .where({ child_id: childId, lesson_id: lessonId })
        .first();

      if (existing) {
        // Update with best scores
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

        results.push({ childId, lessonId, success: true, action: 'updated' });
      } else {
        // Insert new
        await db('progress').insert({
          child_id: childId,
          lesson_id: lessonId,
          score: score || 0,
          stars: stars || 0,
          completed: !!completedAt,
          completed_at: completedAt ? new Date(completedAt) : null,
        });

        results.push({ childId, lessonId, success: true, action: 'created' });
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

module.exports = { saveProgress, getChildProgress, getModuleProgress, syncProgress };
