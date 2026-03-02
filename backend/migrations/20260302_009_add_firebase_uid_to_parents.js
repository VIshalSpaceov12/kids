/**
 * @param {import('knex').Knex} knex
 */
exports.up = async function (knex) {
  await knex.schema.alterTable('parents', (table) => {
    table.string('firebase_uid', 255).nullable().unique();
  });
};

/**
 * @param {import('knex').Knex} knex
 */
exports.down = async function (knex) {
  await knex.schema.alterTable('parents', (table) => {
    table.dropColumn('firebase_uid');
  });
};
