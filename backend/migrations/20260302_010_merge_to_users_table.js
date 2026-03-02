/**
 * Merge parents, admin_users, children into a single users table.
 * Roles: 'admin' or 'user'
 * @param {import('knex').Knex} knex
 */
exports.up = async function (knex) {
  // 1. Create users table
  await knex.schema.createTable('users', (table) => {
    table.uuid('id').primary().defaultTo(knex.raw('uuid_generate_v4()'));
    table.string('name', 100).notNullable();
    table.string('email', 255).nullable().unique();
    table.string('phone', 20).nullable().unique();
    table.text('password_hash').nullable();
    table.text('pin_hash').nullable();
    table.string('firebase_uid', 255).nullable().unique();
    table.string('role', 20).notNullable().defaultTo('user'); // 'admin' or 'user'
    table.integer('age').nullable();
    table.string('class_level', 20).nullable();
    table.string('avatar', 50).defaultTo('lion');
    table.string('pet', 50).defaultTo('cat');
    table.string('language', 5).defaultTo('en');
    table.string('otp', 6).nullable();
    table.timestamp('otp_expires_at').nullable();
    table.boolean('is_active').defaultTo(true);
    table.timestamps(true, true);
  });

  // 2. Migrate parents → users (role='user')
  await knex.raw(`
    INSERT INTO users (id, name, email, phone, password_hash, pin_hash, firebase_uid, role, otp, otp_expires_at, is_active, created_at, updated_at)
    SELECT id, name, email, phone, password_hash, pin_hash, firebase_uid, 'user', otp, otp_expires_at, true, created_at, updated_at
    FROM parents
  `);

  // 3. Migrate admin_users → users (keep their role)
  await knex.raw(`
    INSERT INTO users (id, name, email, password_hash, role, is_active, created_at, updated_at)
    SELECT id, name, email, password_hash, role, is_active, created_at, updated_at
    FROM admin_users
  `);

  // 4. Migrate children → users (role='user') with child-specific fields
  await knex.raw(`
    INSERT INTO users (name, age, class_level, avatar, pet, language, role, is_active, created_at, updated_at)
    SELECT name, age, class_level, avatar, pet, language, 'user', is_active, created_at, updated_at
    FROM children
  `);

  // 5. Update progress table: change child_id → user_id
  // Drop old FK and index
  await knex.schema.alterTable('progress', (table) => {
    table.dropForeign('child_id');
    table.dropUnique(['child_id', 'lesson_id']);
    table.dropIndex('child_id');
  });
  await knex.schema.alterTable('progress', (table) => {
    table.renameColumn('child_id', 'user_id');
  });
  await knex.schema.alterTable('progress', (table) => {
    table.foreign('user_id').references('id').inTable('users').onDelete('CASCADE');
    table.unique(['user_id', 'lesson_id']);
    table.index('user_id');
  });

  // 6. Update settings table: change child_id → user_id
  await knex.schema.alterTable('settings', (table) => {
    table.dropForeign('child_id');
    table.dropUnique('child_id');
  });
  await knex.schema.alterTable('settings', (table) => {
    table.renameColumn('child_id', 'user_id');
  });
  await knex.schema.alterTable('settings', (table) => {
    table.foreign('user_id').references('id').inTable('users').onDelete('CASCADE');
    table.unique('user_id');
  });

  // 7. Drop old tables
  await knex.schema.dropTableIfExists('children');
  await knex.schema.dropTableIfExists('parents');
  await knex.schema.dropTableIfExists('admin_users');
};

/**
 * @param {import('knex').Knex} knex
 */
exports.down = async function (knex) {
  // Recreate old tables (simplified - data not restored)
  await knex.schema.createTable('parents', (table) => {
    table.uuid('id').primary().defaultTo(knex.raw('uuid_generate_v4()'));
    table.string('name', 100).notNullable();
    table.string('email', 255).nullable().unique();
    table.string('phone', 20).nullable().unique();
    table.text('password_hash').nullable();
    table.text('pin_hash').nullable();
    table.string('firebase_uid', 255).nullable().unique();
    table.string('otp', 6).nullable();
    table.timestamp('otp_expires_at').nullable();
    table.timestamps(true, true);
  });

  await knex.schema.createTable('admin_users', (table) => {
    table.uuid('id').primary().defaultTo(knex.raw('uuid_generate_v4()'));
    table.string('name', 100).notNullable();
    table.string('email', 255).notNullable().unique();
    table.text('password_hash').notNullable();
    table.string('role', 20).defaultTo('admin');
    table.boolean('is_active').defaultTo(true);
    table.timestamps(true, true);
  });

  await knex.schema.createTable('children', (table) => {
    table.uuid('id').primary().defaultTo(knex.raw('uuid_generate_v4()'));
    table.uuid('parent_id').notNullable().references('id').inTable('parents').onDelete('CASCADE');
    table.string('name', 100).notNullable();
    table.integer('age').notNullable();
    table.string('class_level', 20).notNullable();
    table.string('avatar', 50).defaultTo('lion');
    table.string('pet', 50).defaultTo('cat');
    table.string('language', 5).defaultTo('en');
    table.boolean('is_active').defaultTo(true);
    table.timestamps(true, true);
  });

  // Revert progress
  await knex.schema.alterTable('progress', (table) => {
    table.dropForeign('user_id');
    table.dropUnique(['user_id', 'lesson_id']);
    table.dropIndex('user_id');
  });
  await knex.schema.alterTable('progress', (table) => {
    table.renameColumn('user_id', 'child_id');
  });
  await knex.schema.alterTable('progress', (table) => {
    table.foreign('child_id').references('id').inTable('children').onDelete('CASCADE');
    table.unique(['child_id', 'lesson_id']);
    table.index('child_id');
  });

  // Revert settings
  await knex.schema.alterTable('settings', (table) => {
    table.dropForeign('user_id');
    table.dropUnique('user_id');
  });
  await knex.schema.alterTable('settings', (table) => {
    table.renameColumn('user_id', 'child_id');
  });
  await knex.schema.alterTable('settings', (table) => {
    table.foreign('child_id').references('id').inTable('children').onDelete('CASCADE');
    table.unique('child_id');
  });

  await knex.schema.dropTableIfExists('users');
};
