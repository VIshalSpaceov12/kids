const { v4: uuidv4 } = require('uuid');

/**
 * @param {import('knex').Knex} knex
 */
exports.seed = async function (knex) {
  // Find the ABC Forest module
  const abcForest = await knex('modules').where({ slug: 'abc-forest' }).first();
  if (!abcForest) {
    console.log('ABC Forest module not found. Run 001_modules seed first.');
    return;
  }

  const moduleId = abcForest.id;

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

  const lessons = [
    {
      id: lesson1Id,
      module_id: moduleId,
      title: 'Learn A-Z Letters',
      slug: 'learn-a-z-letters',
      description: 'Learn all 26 English letters with fun mythology characters!',
      difficulty_level: 1,
      class_range_min: 'nursery',
      class_range_max: 'kg',
      content_json: JSON.stringify({
        type: 'letter_recognition',
        range: ['A', 'Z'],
        instructions: 'Tap on the correct letter!',
        mythologyMapping: {
          A: { character: 'Arjuna', description: 'A is for Arjuna, the great archer!' },
          B: { character: 'Bheem', description: 'B is for Bheem, the strongest warrior!' },
          C: { character: 'Chandra', description: 'C is for Chandra, the Moon God!' },
          D: { character: 'Durga', description: 'D is for Durga, the fierce goddess!' },
          E: { character: 'Eklavya', description: 'E is for Eklavya, the devoted student!' },
        },
      }),
      display_order: 1,
      is_active: true,
    },
    {
      id: lesson2Id,
      module_id: moduleId,
      title: 'Trace Letters',
      slug: 'trace-letters',
      description: 'Practice writing letters by tracing them with your finger!',
      difficulty_level: 1,
      class_range_min: 'nursery',
      class_range_max: 'kg',
      content_json: JSON.stringify({
        type: 'tracing',
        instructions: 'Trace the letter with your finger!',
      }),
      display_order: 2,
      is_active: true,
    },
    {
      id: lesson3Id,
      module_id: moduleId,
      title: 'Letter Match',
      slug: 'letter-match',
      description: 'Match uppercase letters with their lowercase pair!',
      difficulty_level: 2,
      class_range_min: 'kg',
      class_range_max: 'class1',
      content_json: JSON.stringify({
        type: 'matching',
        instructions: 'Match the big letter with the small letter!',
      }),
      display_order: 3,
      is_active: true,
    },
  ];

  await knex('lessons').insert(lessons);

  // Questions for Lesson 1: Learn A-Z Letters
  const lesson1Questions = [
    {
      id: uuidv4(),
      lesson_id: lesson1Id,
      type: 'multiple_choice',
      question_data: JSON.stringify({
        prompt: 'Which letter is this?',
        display: 'A',
        mythologyHint: 'A is for Arjuna, the great archer!',
        options: ['A', 'B', 'C', 'D'],
      }),
      correct_answer: JSON.stringify({ answer: 'A' }),
      media_urls: null,
      display_order: 1,
      is_active: true,
    },
    {
      id: uuidv4(),
      lesson_id: lesson1Id,
      type: 'multiple_choice',
      question_data: JSON.stringify({
        prompt: 'Which letter is this?',
        display: 'D',
        mythologyHint: 'D is for Durga, the fierce goddess!',
        options: ['B', 'C', 'D', 'E'],
      }),
      correct_answer: JSON.stringify({ answer: 'D' }),
      media_urls: null,
      display_order: 2,
      is_active: true,
    },
    {
      id: uuidv4(),
      lesson_id: lesson1Id,
      type: 'multiple_choice',
      question_data: JSON.stringify({
        prompt: 'Which letter comes after B?',
        mythologyHint: 'C is for Chandra, the Moon God!',
        options: ['A', 'C', 'D', 'E'],
      }),
      correct_answer: JSON.stringify({ answer: 'C' }),
      media_urls: null,
      display_order: 3,
      is_active: true,
    },
    {
      id: uuidv4(),
      lesson_id: lesson1Id,
      type: 'ordering',
      question_data: JSON.stringify({
        prompt: 'Put the letters in order A to E',
        items: ['D', 'A', 'E', 'B', 'C'],
      }),
      correct_answer: JSON.stringify({ order: ['A', 'B', 'C', 'D', 'E'] }),
      media_urls: null,
      display_order: 4,
      is_active: true,
    },
    {
      id: uuidv4(),
      lesson_id: lesson1Id,
      type: 'multiple_choice',
      question_data: JSON.stringify({
        prompt: 'Which letter starts the word "Elephant"?',
        mythologyHint: 'E is for Eklavya, the devoted student!',
        options: ['A', 'D', 'E', 'F'],
      }),
      correct_answer: JSON.stringify({ answer: 'E' }),
      media_urls: null,
      display_order: 5,
      is_active: true,
    },
  ];

  // Questions for Lesson 2: Trace Letters
  const lesson2Questions = [
    {
      id: uuidv4(),
      lesson_id: lesson2Id,
      type: 'tracing',
      question_data: JSON.stringify({
        prompt: 'Trace the letter A',
        traceLetter: 'A',
        strokePath: 'M25,80 L50,10 L75,80 M35,55 L65,55',
        mythologyHint: 'A is for Arjuna!',
      }),
      correct_answer: JSON.stringify({ traced: true }),
      media_urls: null,
      display_order: 1,
      is_active: true,
    },
    {
      id: uuidv4(),
      lesson_id: lesson2Id,
      type: 'tracing',
      question_data: JSON.stringify({
        prompt: 'Trace the letter B',
        traceLetter: 'B',
        strokePath: 'M25,10 L25,80 M25,10 C60,10 60,45 25,45 C60,45 60,80 25,80',
        mythologyHint: 'B is for Bheem!',
      }),
      correct_answer: JSON.stringify({ traced: true }),
      media_urls: null,
      display_order: 2,
      is_active: true,
    },
    {
      id: uuidv4(),
      lesson_id: lesson2Id,
      type: 'tracing',
      question_data: JSON.stringify({
        prompt: 'Trace the letter C',
        traceLetter: 'C',
        strokePath: 'M70,20 C20,20 20,70 70,70',
        mythologyHint: 'C is for Chandra!',
      }),
      correct_answer: JSON.stringify({ traced: true }),
      media_urls: null,
      display_order: 3,
      is_active: true,
    },
    {
      id: uuidv4(),
      lesson_id: lesson2Id,
      type: 'tracing',
      question_data: JSON.stringify({
        prompt: 'Trace the letter D',
        traceLetter: 'D',
        strokePath: 'M25,10 L25,80 M25,10 C75,10 75,80 25,80',
        mythologyHint: 'D is for Durga!',
      }),
      correct_answer: JSON.stringify({ traced: true }),
      media_urls: null,
      display_order: 4,
      is_active: true,
    },
    {
      id: uuidv4(),
      lesson_id: lesson2Id,
      type: 'tracing',
      question_data: JSON.stringify({
        prompt: 'Trace the letter E',
        traceLetter: 'E',
        strokePath: 'M60,10 L25,10 L25,80 L60,80 M25,45 L55,45',
        mythologyHint: 'E is for Eklavya!',
      }),
      correct_answer: JSON.stringify({ traced: true }),
      media_urls: null,
      display_order: 5,
      is_active: true,
    },
  ];

  // Questions for Lesson 3: Letter Match
  const lesson3Questions = [
    {
      id: uuidv4(),
      lesson_id: lesson3Id,
      type: 'multiple_choice',
      question_data: JSON.stringify({
        prompt: 'Match the uppercase letter A with its lowercase:',
        display: 'A',
        options: ['a', 'b', 'c', 'd'],
      }),
      correct_answer: JSON.stringify({ answer: 'a' }),
      media_urls: null,
      display_order: 1,
      is_active: true,
    },
    {
      id: uuidv4(),
      lesson_id: lesson3Id,
      type: 'multiple_choice',
      question_data: JSON.stringify({
        prompt: 'Match the uppercase letter G with its lowercase:',
        display: 'G',
        options: ['f', 'g', 'h', 'j'],
      }),
      correct_answer: JSON.stringify({ answer: 'g' }),
      media_urls: null,
      display_order: 2,
      is_active: true,
    },
    {
      id: uuidv4(),
      lesson_id: lesson3Id,
      type: 'multiple_choice',
      question_data: JSON.stringify({
        prompt: 'Match the uppercase letter M with its lowercase:',
        display: 'M',
        options: ['n', 'l', 'm', 'k'],
      }),
      correct_answer: JSON.stringify({ answer: 'm' }),
      media_urls: null,
      display_order: 3,
      is_active: true,
    },
    {
      id: uuidv4(),
      lesson_id: lesson3Id,
      type: 'multiple_choice',
      question_data: JSON.stringify({
        prompt: 'Match the uppercase letter R with its lowercase:',
        display: 'R',
        options: ['p', 'q', 'r', 's'],
      }),
      correct_answer: JSON.stringify({ answer: 'r' }),
      media_urls: null,
      display_order: 4,
      is_active: true,
    },
    {
      id: uuidv4(),
      lesson_id: lesson3Id,
      type: 'multiple_choice',
      question_data: JSON.stringify({
        prompt: 'Match the uppercase letter Z with its lowercase:',
        display: 'Z',
        options: ['x', 'y', 'z', 'w'],
      }),
      correct_answer: JSON.stringify({ answer: 'z' }),
      media_urls: null,
      display_order: 5,
      is_active: true,
    },
  ];

  const allQuestions = [...lesson1Questions, ...lesson2Questions, ...lesson3Questions];

  await knex('questions').insert(allQuestions);
};
