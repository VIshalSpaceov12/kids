/**
 * @param {import('knex').Knex} knex
 */
exports.up = async function (knex) {
  await knex.schema.createTable('settings', (table) => {
    table.uuid('id').primary().defaultTo(knex.raw('uuid_generate_v4()'));
    table.uuid('child_id').notNullable().references('id').inTable('children').onDelete('CASCADE').unique();
    table.string('language', 5).defaultTo('en');
    table.boolean('sound_enabled').defaultTo(true);
    table.string('font_size', 10).defaultTo('medium');
    table.integer('screen_time_limit').nullable();
    table.timestamps(true, true);
  });
};

/**
 * @param {import('knex').Knex} knex
 */
exports.down = async function (knex) {
  await knex.schema.dropTableIfExists('settings');
};
