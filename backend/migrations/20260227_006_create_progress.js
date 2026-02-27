/**
 * @param {import('knex').Knex} knex
 */
exports.up = async function (knex) {
  await knex.schema.createTable('progress', (table) => {
    table.uuid('id').primary().defaultTo(knex.raw('uuid_generate_v4()'));
    table.uuid('child_id').notNullable().references('id').inTable('children').onDelete('CASCADE');
    table.uuid('lesson_id').notNullable().references('id').inTable('lessons').onDelete('CASCADE');
    table.integer('score').defaultTo(0);
    table.integer('stars').defaultTo(0);
    table.boolean('completed').defaultTo(false);
    table.integer('attempts').defaultTo(1);
    table.timestamp('completed_at').nullable();
    table.timestamps(true, true);

    table.unique(['child_id', 'lesson_id']);
    table.index('child_id');
    table.index('lesson_id');
  });
};

/**
 * @param {import('knex').Knex} knex
 */
exports.down = async function (knex) {
  await knex.schema.dropTableIfExists('progress');
};
