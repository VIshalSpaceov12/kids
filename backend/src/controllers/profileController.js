const db = require('../config/database');

/**
 * GET /api/profiles/me
 * Return the authenticated parent's profile.
 */
async function getProfile(req, res) {
  try {
    const parentId = req.user.id;

    const parent = await db('parents')
      .where({ id: parentId })
      .select('id', 'name', 'email', 'phone', 'created_at', 'updated_at')
      .first();

    if (!parent) {
      return res.status(404).json({
        success: false,
        message: 'Parent not found.',
      });
    }

    return res.status(200).json({
      success: true,
      parent,
    });
  } catch (error) {
    console.error('Get profile error:', error);
    return res.status(500).json({
      success: false,
      message: 'Internal server error',
    });
  }
}

/**
 * PUT /api/profiles/me
 * Update the authenticated parent's name, email, or phone.
 */
async function updateProfile(req, res) {
  try {
    const parentId = req.user.id;
    const { name, email, phone } = req.body;

    const updateData = { updated_at: new Date() };
    if (name !== undefined) updateData.name = name;
    if (email !== undefined) updateData.email = email;
    if (phone !== undefined) updateData.phone = phone;

    const [updated] = await db('parents')
      .where({ id: parentId })
      .update(updateData)
      .returning(['id', 'name', 'email', 'phone', 'created_at', 'updated_at']);

    if (!updated) {
      return res.status(404).json({
        success: false,
        message: 'Parent not found.',
      });
    }

    return res.status(200).json({
      success: true,
      parent: updated,
    });
  } catch (error) {
    console.error('Update profile error:', error);

    if (error.code === '23505') {
      return res.status(409).json({
        success: false,
        message: 'Email or phone already in use by another account.',
      });
    }

    return res.status(500).json({
      success: false,
      message: 'Internal server error',
    });
  }
}

/**
 * POST /api/profiles/children
 * Create a child profile for the authenticated parent.
 */
async function createChild(req, res) {
  try {
    const parentId = req.user.id;
    const { name, age, classLevel, avatar, pet, language } = req.body;

    const [child] = await db('children')
      .insert({
        parent_id: parentId,
        name,
        age,
        class_level: classLevel,
        avatar: avatar || 'lion',
        pet: pet || 'cat',
        language: language || 'en',
      })
      .returning('*');

    // Also create default settings for the child
    await db('settings').insert({
      child_id: child.id,
      language: child.language,
    });

    return res.status(201).json({
      success: true,
      child,
    });
  } catch (error) {
    console.error('Create child error:', error);
    return res.status(500).json({
      success: false,
      message: 'Internal server error',
    });
  }
}

/**
 * GET /api/profiles/children
 * List all children for the authenticated parent.
 */
async function getChildren(req, res) {
  try {
    const parentId = req.user.id;

    const children = await db('children')
      .where({ parent_id: parentId, is_active: true })
      .select('*')
      .orderBy('created_at', 'asc');

    return res.status(200).json({
      success: true,
      children,
    });
  } catch (error) {
    console.error('Get children error:', error);
    return res.status(500).json({
      success: false,
      message: 'Internal server error',
    });
  }
}

/**
 * PUT /api/profiles/children/:id
 * Update a child profile (must belong to the authenticated parent).
 */
async function updateChild(req, res) {
  try {
    const parentId = req.user.id;
    const childId = req.params.id;
    const { name, age, classLevel, avatar, pet, language } = req.body;

    // Verify the child belongs to the parent
    const child = await db('children')
      .where({ id: childId, parent_id: parentId })
      .first();

    if (!child) {
      return res.status(404).json({
        success: false,
        message: 'Child not found or does not belong to this parent.',
      });
    }

    const updateData = { updated_at: new Date() };
    if (name !== undefined) updateData.name = name;
    if (age !== undefined) updateData.age = age;
    if (classLevel !== undefined) updateData.class_level = classLevel;
    if (avatar !== undefined) updateData.avatar = avatar;
    if (pet !== undefined) updateData.pet = pet;
    if (language !== undefined) updateData.language = language;

    const [updated] = await db('children')
      .where({ id: childId })
      .update(updateData)
      .returning('*');

    return res.status(200).json({
      success: true,
      child: updated,
    });
  } catch (error) {
    console.error('Update child error:', error);
    return res.status(500).json({
      success: false,
      message: 'Internal server error',
    });
  }
}

/**
 * DELETE /api/profiles/children/:id
 * Soft-delete a child profile (set is_active to false).
 */
async function deleteChild(req, res) {
  try {
    const parentId = req.user.id;
    const childId = req.params.id;

    // Verify the child belongs to the parent
    const child = await db('children')
      .where({ id: childId, parent_id: parentId })
      .first();

    if (!child) {
      return res.status(404).json({
        success: false,
        message: 'Child not found or does not belong to this parent.',
      });
    }

    await db('children').where({ id: childId }).update({
      is_active: false,
      updated_at: new Date(),
    });

    return res.status(200).json({
      success: true,
      message: 'Child profile deactivated.',
    });
  } catch (error) {
    console.error('Delete child error:', error);
    return res.status(500).json({
      success: false,
      message: 'Internal server error',
    });
  }
}

module.exports = {
  getProfile,
  updateProfile,
  createChild,
  getChildren,
  updateChild,
  deleteChild,
};
