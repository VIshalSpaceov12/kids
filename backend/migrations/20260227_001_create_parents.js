/**
 * @param {import('knex').Knex} knex
 */
exports.up = async function (knex) {
  await knex.raw('CREATE EXTENSION IF NOT EXISTS "uuid-ossp"');

  await knex.schema.createTable('parents', (table) => {
    table.uuid('id').primary().defaultTo(knex.raw('uuid_generate_v4()'));
    table.string('name', 100).notNullable();
    table.string('email', 255).nullable().unique();
    table.string('phone', 20).nullable().unique();
    table.text('password_hash').nullable();
    table.text('pin_hash').nullable();
    table.string('otp', 6).nullable();
    table.timestamp('otp_expires_at').nullable();
    table.timestamps(true, true);
  });
};

/**
 * @param {import('knex').Knex} knex
 */
exports.down = async function (knex) {
  await knex.schema.dropTableIfExists('parents');
};
