/**
 * @param {import('knex').Knex} knex
 */
exports.up = async function (knex) {
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

    table.index('parent_id');
  });
};

/**
 * @param {import('knex').Knex} knex
 */
exports.down = async function (knex) {
  await knex.schema.dropTableIfExists('children');
};
