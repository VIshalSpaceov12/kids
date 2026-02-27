const { v4: uuidv4 } = require('uuid');

/**
 * @param {import('knex').Knex} knex
 */
exports.seed = async function (knex) {
  // Find the Number Land module
  const numberLand = await knex('modules').where({ slug: 'number-land' }).first();
  if (!numberLand) {
    console.log('Number Land module not found. Run 001_modules seed first.');
    return;
  }

  const moduleId = numberLand.id;

  // Delete existing lessons for this module
  const existingLessons = await knex('lessons').where({ module_id: moduleId }).select('id');
  const lessonIds = existingLessons.map((l) => l.id);
  if (lessonIds.length > 0) {
    await knex('questions').whereIn('lesson_id', lessonIds).del();
    await knex('lessons').where({ module_id: moduleId }).del();
  }

  // Create lessons
  const lesson1Id = uuidv4();
  const lesson2Id = uuidv4();
  const lesson3Id = uuidv4();
  const lesson4Id = uuidv4();

  const lessons = [
    {
      id: lesson1Id,
      module_id: moduleId,
      title: 'Learn Numbers 1-10',
      slug: 'learn-numbers-1-10',
      description: 'Learn to recognize and count numbers from 1 to 10',
      difficulty_level: 1,
      class_range_min: 'nursery',
      class_range_max: 'kg',
      content_json: JSON.stringify({
        type: 'number_recognition',
        range: [1, 10],
        instructions: 'Tap on the correct number!',
      }),
      display_order: 1,
      is_active: true,
    },
    {
      id: lesson2Id,
      module_id: moduleId,
      title: 'Learn Numbers 1-20',
      slug: 'learn-numbers-1-20',
      description: 'Expand your number knowledge from 1 to 20',
      difficulty_level: 2,
      class_range_min: 'kg',
      class_range_max: 'class1',
      content_json: JSON.stringify({
        type: 'number_recognition',
        range: [1, 20],
        instructions: 'Find and tap the right number!',
      }),
      display_order: 2,
      is_active: true,
    },
    {
      id: lesson3Id,
      module_id: moduleId,
      title: 'Count Objects',
      slug: 'count-objects',
      description: 'Count the objects and pick the right number',
      difficulty_level: 1,
      class_range_min: 'nursery',
      class_range_max: 'kg',
      content_json: JSON.stringify({
        type: 'counting',
        instructions: 'Count the objects and choose the correct number!',
      }),
      display_order: 3,
      is_active: true,
    },
    {
      id: lesson4Id,
      module_id: moduleId,
      title: 'Missing Numbers',
      slug: 'missing-numbers',
      description: 'Find the missing number in the sequence',
      difficulty_level: 2,
      class_range_min: 'kg',
      class_range_max: 'class1',
      content_json: JSON.stringify({
        type: 'sequence',
        instructions: 'Which number is missing? Fill in the blank!',
      }),
      display_order: 4,
      is_active: true,
    },
  ];

  await knex('lessons').insert(lessons);

  // Questions for Lesson 1: Learn Numbers 1-10
  const lesson1Questions = [
    {
      id: uuidv4(),
      lesson_id: lesson1Id,
      type: 'multiple_choice',
      question_data: JSON.stringify({
        prompt: 'Which number is this?',
        display: '3',
        options: ['1', '2', '3', '4'],
      }),
      correct_answer: JSON.stringify({ answer: '3' }),
      media_urls: null,
      display_order: 1,
      is_active: true,
    },
    {
      id: uuidv4(),
      lesson_id: lesson1Id,
      type: 'multiple_choice',
      question_data: JSON.stringify({
        prompt: 'Which number is this?',
        display: '7',
        options: ['5', '6', '7', '8'],
      }),
      correct_answer: JSON.stringify({ answer: '7' }),
      media_urls: null,
      display_order: 2,
      is_active: true,
    },
    {
      id: uuidv4(),
      lesson_id: lesson1Id,
      type: 'multiple_choice',
      question_data: JSON.stringify({
        prompt: 'How many apples are there?',
        objectEmoji: '🍎',
        objectCount: 5,
        options: ['3', '4', '5', '6'],
      }),
      correct_answer: JSON.stringify({ answer: '5' }),
      media_urls: null,
      display_order: 3,
      is_active: true,
    },
    {
      id: uuidv4(),
      lesson_id: lesson1Id,
      type: 'tracing',
      question_data: JSON.stringify({
        prompt: 'Trace the number 4',
        traceNumber: 4,
        strokePath: 'M10,10 L10,50 M10,30 L30,30 M30,10 L30,50',
      }),
      correct_answer: JSON.stringify({ traced: true }),
      media_urls: null,
      display_order: 4,
      is_active: true,
    },
    {
      id: uuidv4(),
      lesson_id: lesson1Id,
      type: 'ordering',
      question_data: JSON.stringify({
        prompt: 'Put the numbers in order from smallest to largest',
        items: ['5', '2', '8', '1', '4'],
      }),
      correct_answer: JSON.stringify({ order: ['1', '2', '4', '5', '8'] }),
      media_urls: null,
      display_order: 5,
      is_active: true,
    },
  ];

  // Questions for Lesson 2: Learn Numbers 1-20
  const lesson2Questions = [
    {
      id: uuidv4(),
      lesson_id: lesson2Id,
      type: 'multiple_choice',
      question_data: JSON.stringify({
        prompt: 'Which number is this?',
        display: '14',
        options: ['12', '13', '14', '15'],
      }),
      correct_answer: JSON.stringify({ answer: '14' }),
      media_urls: null,
      display_order: 1,
      is_active: true,
    },
    {
      id: uuidv4(),
      lesson_id: lesson2Id,
      type: 'multiple_choice',
      question_data: JSON.stringify({
        prompt: 'What comes after 17?',
        options: ['15', '16', '18', '19'],
      }),
      correct_answer: JSON.stringify({ answer: '18' }),
      media_urls: null,
      display_order: 2,
      is_active: true,
    },
    {
      id: uuidv4(),
      lesson_id: lesson2Id,
      type: 'fill_blank',
      question_data: JSON.stringify({
        prompt: 'Fill in the missing number: 10, 11, __, 13',
        blank_position: 2,
      }),
      correct_answer: JSON.stringify({ answer: '12' }),
      media_urls: null,
      display_order: 3,
      is_active: true,
    },
    {
      id: uuidv4(),
      lesson_id: lesson2Id,
      type: 'ordering',
      question_data: JSON.stringify({
        prompt: 'Put the numbers in order from smallest to largest',
        items: ['18', '11', '15', '20', '13'],
      }),
      correct_answer: JSON.stringify({ order: ['11', '13', '15', '18', '20'] }),
      media_urls: null,
      display_order: 4,
      is_active: true,
    },
    {
      id: uuidv4(),
      lesson_id: lesson2Id,
      type: 'tracing',
      question_data: JSON.stringify({
        prompt: 'Trace the number 16',
        traceNumber: 16,
      }),
      correct_answer: JSON.stringify({ traced: true }),
      media_urls: null,
      display_order: 5,
      is_active: true,
    },
  ];

  // Questions for Lesson 3: Count Objects
  const lesson3Questions = [
    {
      id: uuidv4(),
      lesson_id: lesson3Id,
      type: 'multiple_choice',
      question_data: JSON.stringify({
        prompt: 'How many stars are there?',
        objectEmoji: '⭐',
        objectCount: 3,
        options: ['2', '3', '4', '5'],
      }),
      correct_answer: JSON.stringify({ answer: '3' }),
      media_urls: null,
      display_order: 1,
      is_active: true,
    },
    {
      id: uuidv4(),
      lesson_id: lesson3Id,
      type: 'multiple_choice',
      question_data: JSON.stringify({
        prompt: 'How many bananas are there?',
        objectEmoji: '🍌',
        objectCount: 7,
        options: ['5', '6', '7', '8'],
      }),
      correct_answer: JSON.stringify({ answer: '7' }),
      media_urls: null,
      display_order: 2,
      is_active: true,
    },
    {
      id: uuidv4(),
      lesson_id: lesson3Id,
      type: 'multiple_choice',
      question_data: JSON.stringify({
        prompt: 'How many balls are there?',
        objectEmoji: '🏀',
        objectCount: 9,
        options: ['7', '8', '9', '10'],
      }),
      correct_answer: JSON.stringify({ answer: '9' }),
      media_urls: null,
      display_order: 3,
      is_active: true,
    },
    {
      id: uuidv4(),
      lesson_id: lesson3Id,
      type: 'multiple_choice',
      question_data: JSON.stringify({
        prompt: 'How many flowers are there?',
        objectEmoji: '🌸',
        objectCount: 2,
        options: ['1', '2', '3', '4'],
      }),
      correct_answer: JSON.stringify({ answer: '2' }),
      media_urls: null,
      display_order: 4,
      is_active: true,
    },
    {
      id: uuidv4(),
      lesson_id: lesson3Id,
      type: 'multiple_choice',
      question_data: JSON.stringify({
        prompt: 'How many fish are there?',
        objectEmoji: '🐟',
        objectCount: 6,
        options: ['4', '5', '6', '7'],
      }),
      correct_answer: JSON.stringify({ answer: '6' }),
      media_urls: null,
      display_order: 5,
      is_active: true,
    },
  ];

  // Questions for Lesson 4: Missing Numbers
  const lesson4Questions = [
    {
      id: uuidv4(),
      lesson_id: lesson4Id,
      type: 'fill_blank',
      question_data: JSON.stringify({
        prompt: 'Fill in the missing number: 1, 2, __, 4, 5',
        sequence: [1, 2, null, 4, 5],
        blank_position: 2,
      }),
      correct_answer: JSON.stringify({ answer: '3' }),
      media_urls: null,
      display_order: 1,
      is_active: true,
    },
    {
      id: uuidv4(),
      lesson_id: lesson4Id,
      type: 'fill_blank',
      question_data: JSON.stringify({
        prompt: 'Fill in the missing number: 5, __, 7, 8, 9',
        sequence: [5, null, 7, 8, 9],
        blank_position: 1,
      }),
      correct_answer: JSON.stringify({ answer: '6' }),
      media_urls: null,
      display_order: 2,
      is_active: true,
    },
    {
      id: uuidv4(),
      lesson_id: lesson4Id,
      type: 'fill_blank',
      question_data: JSON.stringify({
        prompt: 'Fill in the missing number: 3, 4, 5, __, 7',
        sequence: [3, 4, 5, null, 7],
        blank_position: 3,
      }),
      correct_answer: JSON.stringify({ answer: '6' }),
      media_urls: null,
      display_order: 3,
      is_active: true,
    },
    {
      id: uuidv4(),
      lesson_id: lesson4Id,
      type: 'multiple_choice',
      question_data: JSON.stringify({
        prompt: 'What number comes after 8?',
        options: ['6', '7', '9', '10'],
      }),
      correct_answer: JSON.stringify({ answer: '9' }),
      media_urls: null,
      display_order: 4,
      is_active: true,
    },
    {
      id: uuidv4(),
      lesson_id: lesson4Id,
      type: 'ordering',
      question_data: JSON.stringify({
        prompt: 'Put the numbers in order: 10, 7, 9, 6, 8',
        items: ['10', '7', '9', '6', '8'],
      }),
      correct_answer: JSON.stringify({ order: ['6', '7', '8', '9', '10'] }),
      media_urls: null,
      display_order: 5,
      is_active: true,
    },
  ];

  const allQuestions = [
    ...lesson1Questions,
    ...lesson2Questions,
    ...lesson3Questions,
    ...lesson4Questions,
  ];

  await knex('questions').insert(allQuestions);
};
