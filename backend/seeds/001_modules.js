const { v4: uuidv4 } = require('uuid');

const modules = [
  {
    id: uuidv4(),
    name: 'Number Land',
    slug: 'number-land',
    description: 'Learn numbers, counting, and basic number concepts through fun activities!',
    icon: '🔢',
    color: '#FF6B6B',
    display_order: 1,
    is_active: true,
  },
  {
    id: uuidv4(),
    name: 'ABC Forest',
    slug: 'abc-forest',
    description: 'Explore the alphabet forest and learn English letters with fun characters!',
    icon: '🔤',
    color: '#4CAF50',
    display_order: 2,
    is_active: true,
  },
  {
    id: uuidv4(),
    name: 'Gujarati Jungle',
    slug: 'gujarati-jungle',
    description: 'Learn Gujarati letters and words in the exciting jungle adventure!',
    icon: 'ગ',
    color: '#FF9800',
    display_order: 3,
    is_active: true,
  },
  {
    id: uuidv4(),
    name: 'Maths Kingdom',
    slug: 'maths-kingdom',
    description: 'Master addition, subtraction, and basic maths in the magical kingdom!',
    icon: '➕',
    color: '#2196F3',
    display_order: 4,
    is_active: true,
  },
];

/**
 * @param {import('knex').Knex} knex
 */
exports.seed = async function (knex) {
  // Delete existing entries
  await knex('questions').del();
  await knex('progress').del();
  await knex('lessons').del();
  await knex('modules').del();

  // Insert modules
  await knex('modules').insert(modules);
};
