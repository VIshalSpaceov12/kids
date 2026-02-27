/**
 * @param {import('knex').Knex} knex
 */
exports.up = async function (knex) {
  await knex.schema.createTable('lessons', (table) => {
    table.uuid('id').primary().defaultTo(knex.raw('uuid_generate_v4()'));
    table.uuid('module_id').notNullable().references('id').inTable('modules').onDelete('CASCADE');
    table.string('title', 200).notNullable();
    table.string('slug', 100).notNullable();
    table.text('description').nullable();
    table.integer('difficulty_level').defaultTo(1);
    table.string('class_range_min', 20).nullable();
    table.string('class_range_max', 20).nullable();
    table.jsonb('content_json').nullable();
    table.integer('display_order').defaultTo(0);
    table.boolean('is_active').defaultTo(true);
    table.timestamps(true, true);

    table.index('module_id');
    table.unique(['module_id', 'slug']);
  });
};

/**
 * @param {import('knex').Knex} knex
 */
exports.down = async function (knex) {
  await knex.schema.dropTableIfExists('lessons');
};
