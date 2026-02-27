const bcrypt = require('bcryptjs');
const { v4: uuidv4 } = require('uuid');

/**
 * @param {import('knex').Knex} knex
 */
exports.seed = async function (knex) {
  // Check if admin already exists
  const existing = await knex('admin_users').where({ email: 'admin@chhotugenius.com' }).first();
  if (existing) {
    return;
  }

  const passwordHash = await bcrypt.hash('admin123', 12);

  await knex('admin_users').insert({
    id: uuidv4(),
    name: 'Admin',
    email: 'admin@chhotugenius.com',
    password_hash: passwordHash,
    role: 'admin',
    is_active: true,
  });
};
