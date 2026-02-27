import type { Parent, Child, Module, Lesson, Question, Progress, DashboardStats } from '../types';

// --- Helpers ---
function daysAgo(n: number): string {
  const d = new Date();
  d.setDate(d.getDate() - n);
  return d.toISOString();
}

function randomBetween(min: number, max: number): number {
  return Math.floor(Math.random() * (max - min + 1)) + min;
}

// --- Parents ---
export const mockParents: Parent[] = [
  { id: 'p1', name: 'Raj Patel', email: 'raj.patel@gmail.com', phone: '+91 98765 43210', childrenCount: 2, lastActive: daysAgo(0), createdAt: daysAgo(90) },
  { id: 'p2', name: 'Priya Shah', email: 'priya.shah@gmail.com', phone: '+91 98765 43211', childrenCount: 1, lastActive: daysAgo(1), createdAt: daysAgo(85) },
  { id: 'p3', name: 'Amit Desai', email: 'amit.desai@yahoo.com', phone: '+91 98765 43212', childrenCount: 3, lastActive: daysAgo(0), createdAt: daysAgo(78) },
  { id: 'p4', name: 'Neha Sharma', email: null, phone: '+91 98765 43213', childrenCount: 1, lastActive: daysAgo(2), createdAt: daysAgo(70) },
  { id: 'p5', name: 'Vikram Mehta', email: 'vikram.m@outlook.com', phone: '+91 98765 43214', childrenCount: 2, lastActive: daysAgo(0), createdAt: daysAgo(65) },
  { id: 'p6', name: 'Sunita Joshi', email: 'sunita.j@gmail.com', phone: null, childrenCount: 2, lastActive: daysAgo(3), createdAt: daysAgo(60) },
  { id: 'p7', name: 'Rahul Gupta', email: 'rahul.gupta@gmail.com', phone: '+91 98765 43216', childrenCount: 1, lastActive: daysAgo(1), createdAt: daysAgo(55) },
  { id: 'p8', name: 'Kavita Rao', email: 'kavita.rao@gmail.com', phone: '+91 98765 43217', childrenCount: 2, lastActive: daysAgo(0), createdAt: daysAgo(50) },
  { id: 'p9', name: 'Deepak Iyer', email: null, phone: '+91 98765 43218', childrenCount: 1, lastActive: daysAgo(4), createdAt: daysAgo(45) },
  { id: 'p10', name: 'Anita Verma', email: 'anita.verma@yahoo.com', phone: '+91 98765 43219', childrenCount: 3, lastActive: daysAgo(0), createdAt: daysAgo(42) },
  { id: 'p11', name: 'Sanjay Tiwari', email: 'sanjay.t@gmail.com', phone: '+91 98765 43220', childrenCount: 1, lastActive: daysAgo(1), createdAt: daysAgo(38) },
  { id: 'p12', name: 'Meena Reddy', email: 'meena.r@outlook.com', phone: '+91 98765 43221', childrenCount: 2, lastActive: daysAgo(0), createdAt: daysAgo(35) },
  { id: 'p13', name: 'Kiran Bhat', email: 'kiran.bhat@gmail.com', phone: null, childrenCount: 1, lastActive: daysAgo(5), createdAt: daysAgo(30) },
  { id: 'p14', name: 'Pooja Nair', email: null, phone: '+91 98765 43223', childrenCount: 2, lastActive: daysAgo(0), createdAt: daysAgo(25) },
  { id: 'p15', name: 'Manish Kulkarni', email: 'manish.k@gmail.com', phone: '+91 98765 43224', childrenCount: 1, lastActive: daysAgo(2), createdAt: daysAgo(20) },
  { id: 'p16', name: 'Ritu Pandey', email: 'ritu.p@gmail.com', phone: '+91 98765 43225', childrenCount: 2, lastActive: daysAgo(1), createdAt: daysAgo(15) },
  { id: 'p17', name: 'Ashok Mishra', email: 'ashok.mishra@yahoo.com', phone: '+91 98765 43226', childrenCount: 3, lastActive: daysAgo(0), createdAt: daysAgo(12) },
  { id: 'p18', name: 'Geeta Saxena', email: null, phone: '+91 98765 43227', childrenCount: 1, lastActive: daysAgo(3), createdAt: daysAgo(8) },
  { id: 'p19', name: 'Nikhil Chauhan', email: 'nikhil.c@gmail.com', phone: '+91 98765 43228', childrenCount: 2, lastActive: daysAgo(0), createdAt: daysAgo(5) },
  { id: 'p20', name: 'Divya Agarwal', email: 'divya.a@outlook.com', phone: '+91 98765 43229', childrenCount: 1, lastActive: daysAgo(1), createdAt: daysAgo(2) },
];

// --- Children ---
const childNames = [
  'Aarav', 'Vivaan', 'Aditya', 'Vihaan', 'Arjun',
  'Saanvi', 'Aadhya', 'Anaya', 'Pari', 'Myra',
  'Reyansh', 'Ishaan', 'Kabir', 'Dhruv', 'Riya',
  'Kiara', 'Avni', 'Diya', 'Nisha', 'Siya',
  'Yash', 'Krish', 'Lakshya', 'Arnav', 'Mihir',
  'Tara', 'Navya', 'Kavya', 'Aanya', 'Zara',
  'Rohan', 'Om', 'Atharv', 'Rudra', 'Pranav',
];
const avatars = ['\uD83D\uDE03', '\uD83D\uDE04', '\uD83D\uDE0A', '\uD83E\uDD29', '\uD83E\uDD13', '\uD83E\uDD17', '\uD83D\uDE0E', '\uD83E\uDD70', '\uD83D\uDE07', '\uD83E\uDDD1\u200D\uD83C\uDF93'];
const classLevels = ['Nursery', 'LKG', 'UKG', 'Class 1', 'Class 2', 'Class 3'];
const languages = ['English', 'Gujarati', 'Hindi'];

let childIdx = 0;
export const mockChildren: Child[] = mockParents.flatMap((parent) => {
  const count = parent.childrenCount;
  const children: Child[] = [];
  for (let i = 0; i < count; i++) {
    const name = childNames[childIdx % childNames.length];
    children.push({
      id: `c${childIdx + 1}`,
      parentId: parent.id,
      name,
      age: randomBetween(3, 10),
      classLevel: classLevels[randomBetween(0, classLevels.length - 1)],
      avatar: avatars[childIdx % avatars.length],
      language: languages[randomBetween(0, languages.length - 1)],
      createdAt: parent.createdAt,
    });
    childIdx++;
  }
  return children;
});

// --- Modules ---
export const mockModules: Module[] = [
  { id: 'mod1', name: 'Number Land', slug: 'number-land', description: 'Learn counting, number recognition, and basic arithmetic', icon: '\uD83D\uDD22', color: '#EF4444', lessonCount: 12, questionCount: 60 },
  { id: 'mod2', name: 'ABC Forest', slug: 'abc-forest', description: 'Master the English alphabet, phonics, and early reading', icon: '\uD83C\uDF33', color: '#22C55E', lessonCount: 10, questionCount: 50 },
  { id: 'mod3', name: 'Gujarati Jungle', slug: 'gujarati-jungle', description: 'Learn Gujarati script, vocabulary, and pronunciation', icon: '\uD83C\uDF34', color: '#F97316', lessonCount: 8, questionCount: 40 },
  { id: 'mod4', name: 'Maths Kingdom', slug: 'maths-kingdom', description: 'Addition, subtraction, shapes, and patterns', icon: '\uD83D\uDC51', color: '#3B82F6', lessonCount: 14, questionCount: 70 },
];

// --- Lessons ---
export const mockLessons: Record<string, Lesson[]> = {
  'mod1': [
    { id: 'l1', moduleId: 'mod1', title: 'Counting 1-10', slug: 'counting-1-10', description: 'Learn to count from 1 to 10 with fun activities', difficultyLevel: 1, classRangeMin: 'Nursery', classRangeMax: 'LKG', questionCount: 5, displayOrder: 1, isActive: true },
    { id: 'l2', moduleId: 'mod1', title: 'Counting 11-20', slug: 'counting-11-20', description: 'Extend counting skills from 11 to 20', difficultyLevel: 1, classRangeMin: 'Nursery', classRangeMax: 'LKG', questionCount: 5, displayOrder: 2, isActive: true },
    { id: 'l3', moduleId: 'mod1', title: 'Number Recognition', slug: 'number-recognition', description: 'Identify and match numbers in different formats', difficultyLevel: 2, classRangeMin: 'LKG', classRangeMax: 'UKG', questionCount: 6, displayOrder: 3, isActive: true },
    { id: 'l4', moduleId: 'mod1', title: 'Greater & Smaller', slug: 'greater-smaller', description: 'Compare numbers and understand greater than / less than', difficultyLevel: 2, classRangeMin: 'LKG', classRangeMax: 'Class 1', questionCount: 5, displayOrder: 4, isActive: true },
    { id: 'l5', moduleId: 'mod1', title: 'Skip Counting', slug: 'skip-counting', description: 'Count by 2s, 5s, and 10s', difficultyLevel: 3, classRangeMin: 'UKG', classRangeMax: 'Class 2', questionCount: 5, displayOrder: 5, isActive: false },
  ],
  'mod2': [
    { id: 'l6', moduleId: 'mod2', title: 'Alphabet A-M', slug: 'alphabet-a-m', description: 'Learn letters A through M with sounds and words', difficultyLevel: 1, classRangeMin: 'Nursery', classRangeMax: 'LKG', questionCount: 5, displayOrder: 1, isActive: true },
    { id: 'l7', moduleId: 'mod2', title: 'Alphabet N-Z', slug: 'alphabet-n-z', description: 'Learn letters N through Z with sounds and words', difficultyLevel: 1, classRangeMin: 'Nursery', classRangeMax: 'LKG', questionCount: 5, displayOrder: 2, isActive: true },
    { id: 'l8', moduleId: 'mod2', title: 'Phonics Basics', slug: 'phonics-basics', description: 'Understand letter sounds and simple blending', difficultyLevel: 2, classRangeMin: 'LKG', classRangeMax: 'UKG', questionCount: 6, displayOrder: 3, isActive: true },
    { id: 'l9', moduleId: 'mod2', title: 'Simple Words', slug: 'simple-words', description: 'Read and spell three-letter words', difficultyLevel: 3, classRangeMin: 'UKG', classRangeMax: 'Class 1', questionCount: 5, displayOrder: 4, isActive: true },
  ],
  'mod3': [
    { id: 'l10', moduleId: 'mod3', title: 'Gujarati Vowels', slug: 'gujarati-vowels', description: 'Learn Gujarati swar (vowels) with pronunciation', difficultyLevel: 1, classRangeMin: 'Nursery', classRangeMax: 'LKG', questionCount: 5, displayOrder: 1, isActive: true },
    { id: 'l11', moduleId: 'mod3', title: 'Gujarati Consonants', slug: 'gujarati-consonants', description: 'Learn Gujarati vyanjan (consonants)', difficultyLevel: 2, classRangeMin: 'LKG', classRangeMax: 'UKG', questionCount: 6, displayOrder: 2, isActive: true },
    { id: 'l12', moduleId: 'mod3', title: 'Simple Gujarati Words', slug: 'simple-gujarati-words', description: 'Read and write basic Gujarati words', difficultyLevel: 3, classRangeMin: 'UKG', classRangeMax: 'Class 1', questionCount: 5, displayOrder: 3, isActive: true },
  ],
  'mod4': [
    { id: 'l13', moduleId: 'mod4', title: 'Basic Addition', slug: 'basic-addition', description: 'Add single-digit numbers with visual aids', difficultyLevel: 1, classRangeMin: 'LKG', classRangeMax: 'UKG', questionCount: 5, displayOrder: 1, isActive: true },
    { id: 'l14', moduleId: 'mod4', title: 'Basic Subtraction', slug: 'basic-subtraction', description: 'Subtract single-digit numbers with visual aids', difficultyLevel: 1, classRangeMin: 'LKG', classRangeMax: 'UKG', questionCount: 5, displayOrder: 2, isActive: true },
    { id: 'l15', moduleId: 'mod4', title: 'Shapes & Colors', slug: 'shapes-colors', description: 'Identify basic shapes and their properties', difficultyLevel: 1, classRangeMin: 'Nursery', classRangeMax: 'LKG', questionCount: 6, displayOrder: 3, isActive: true },
    { id: 'l16', moduleId: 'mod4', title: 'Patterns', slug: 'patterns', description: 'Recognize and extend simple patterns', difficultyLevel: 2, classRangeMin: 'UKG', classRangeMax: 'Class 1', questionCount: 5, displayOrder: 4, isActive: true },
    { id: 'l17', moduleId: 'mod4', title: 'Word Problems', slug: 'word-problems', description: 'Solve simple word problems using addition and subtraction', difficultyLevel: 3, classRangeMin: 'Class 1', classRangeMax: 'Class 2', questionCount: 5, displayOrder: 5, isActive: false },
  ],
};

// --- Questions ---
export const mockQuestions: Record<string, Question[]> = {
  'l1': [
    { id: 'q1', lessonId: 'l1', type: 'multiple_choice', questionData: { question: 'How many apples are there?', image: 'apples_3.png', options: ['2', '3', '4', '5'] }, correctAnswer: { answer: '3' }, displayOrder: 1, isActive: true },
    { id: 'q2', lessonId: 'l1', type: 'multiple_choice', questionData: { question: 'What number comes after 5?', options: ['4', '5', '6', '7'] }, correctAnswer: { answer: '6' }, displayOrder: 2, isActive: true },
    { id: 'q3', lessonId: 'l1', type: 'ordering', questionData: { instruction: 'Arrange numbers in order', items: ['3', '1', '4', '2'] }, correctAnswer: { order: ['1', '2', '3', '4'] }, displayOrder: 3, isActive: true },
    { id: 'q4', lessonId: 'l1', type: 'fill_blank', questionData: { sentence: 'The number after 7 is ___' }, correctAnswer: { answer: '8' }, displayOrder: 4, isActive: true },
    { id: 'q5', lessonId: 'l1', type: 'tracing', questionData: { character: '5', guidePoints: [[10, 0], [0, 20], [10, 20], [0, 40], [10, 40]] }, correctAnswer: { tolerance: 15 }, displayOrder: 5, isActive: true },
  ],
  'l6': [
    { id: 'q6', lessonId: 'l6', type: 'multiple_choice', questionData: { question: 'Which letter is this? A', options: ['A', 'B', 'C', 'D'] }, correctAnswer: { answer: 'A' }, displayOrder: 1, isActive: true },
    { id: 'q7', lessonId: 'l6', type: 'tracing', questionData: { character: 'B', guidePoints: [[0, 0], [0, 40], [10, 10], [10, 30]] }, correctAnswer: { tolerance: 15 }, displayOrder: 2, isActive: true },
    { id: 'q8', lessonId: 'l6', type: 'fill_blank', questionData: { sentence: '___ is for Apple' }, correctAnswer: { answer: 'A' }, displayOrder: 3, isActive: true },
  ],
};

// --- Progress ---
export const mockProgress: Record<string, Progress[]> = {};
mockChildren.forEach((child) => {
  const lessons = ['Counting 1-10', 'Alphabet A-M', 'Gujarati Vowels', 'Basic Addition', 'Shapes & Colors'];
  const prog: Progress[] = lessons.slice(0, randomBetween(2, 5)).map((title, idx) => ({
    lessonId: `l${idx + 1}`,
    lessonTitle: title,
    score: randomBetween(40, 100),
    stars: randomBetween(1, 3),
    completed: Math.random() > 0.3,
    completedAt: Math.random() > 0.3 ? daysAgo(randomBetween(0, 30)) : null,
  }));
  mockProgress[child.id] = prog;
});

// --- Dashboard Stats ---
function generateDailyActiveUsers(): { date: string; count: number }[] {
  const data: { date: string; count: number }[] = [];
  for (let i = 29; i >= 0; i--) {
    const d = new Date();
    d.setDate(d.getDate() - i);
    const base = 80 + Math.floor(i < 10 ? (30 - i) * 3 : (30 - i) * 1.5);
    const noise = randomBetween(-15, 15);
    data.push({
      date: d.toISOString().split('T')[0],
      count: Math.max(50, Math.min(200, base + noise)),
    });
  }
  return data;
}

export const mockDashboardStats: DashboardStats = {
  totalUsers: 1247,
  activeToday: 183,
  newThisWeek: 42,
  totalChildren: 1893,
  moduleEngagement: [
    { name: 'Number Land', value: 35, color: '#EF4444' },
    { name: 'ABC Forest', value: 30, color: '#22C55E' },
    { name: 'Gujarati Jungle', value: 20, color: '#F97316' },
    { name: 'Maths Kingdom', value: 15, color: '#3B82F6' },
  ],
  dailyActiveUsers: generateDailyActiveUsers(),
  recentRegistrations: [
    { id: 'p20', name: 'Divya Agarwal', createdAt: daysAgo(2) },
    { id: 'p19', name: 'Nikhil Chauhan', createdAt: daysAgo(5) },
    { id: 'p18', name: 'Geeta Saxena', createdAt: daysAgo(8) },
    { id: 'p17', name: 'Ashok Mishra', createdAt: daysAgo(12) },
    { id: 'p16', name: 'Ritu Pandey', createdAt: daysAgo(15) },
  ],
};
