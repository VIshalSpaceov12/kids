const db = require('../config/database');

/**
 * GET /api/profiles/me
 * Return the authenticated user's profile.
 */
async function getProfile(req, res) {
  try {
    const userId = req.user.id;

    const user = await db('users')
      .where({ id: userId })
      .select('id', 'name', 'email', 'phone', 'role', 'age', 'class_level', 'avatar', 'pet', 'language', 'created_at', 'updated_at')
      .first();

    if (!user) {
      return res.status(404).json({
        success: false,
        message: 'User not found.',
      });
    }

    return res.status(200).json({
      success: true,
      user,
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
 * Update the authenticated user's profile.
 */
async function updateProfile(req, res) {
  try {
    const userId = req.user.id;
    const { name, email, phone, age, classLevel, avatar, pet, language } = req.body;

    const updateData = { updated_at: new Date() };
    if (name !== undefined) updateData.name = name;
    if (email !== undefined) updateData.email = email;
    if (phone !== undefined) updateData.phone = phone;
    if (age !== undefined) updateData.age = age;
    if (classLevel !== undefined) updateData.class_level = classLevel;
    if (avatar !== undefined) updateData.avatar = avatar;
    if (pet !== undefined) updateData.pet = pet;
    if (language !== undefined) updateData.language = language;

    const [updated] = await db('users')
      .where({ id: userId })
      .update(updateData)
      .returning(['id', 'name', 'email', 'phone', 'role', 'age', 'class_level', 'avatar', 'pet', 'language', 'created_at', 'updated_at']);

    if (!updated) {
      return res.status(404).json({
        success: false,
        message: 'User not found.',
      });
    }

    return res.status(200).json({
      success: true,
      user: updated,
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

module.exports = {
  getProfile,
  updateProfile,
};
