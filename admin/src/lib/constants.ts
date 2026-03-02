export const BACKEND_URL = process.env.BACKEND_URL || 'http://localhost:3000';

export const CLASS_LEVELS = [
  { value: 'nursery', label: 'Nursery' },
  { value: 'lkg', label: 'LKG' },
  { value: 'ukg', label: 'UKG' },
  { value: 'class1', label: 'Class 1' },
  { value: 'class2', label: 'Class 2' },
  { value: 'class3', label: 'Class 3' },
  { value: 'class4', label: 'Class 4' },
  { value: 'class5', label: 'Class 5' },
];

export const QUESTION_TYPES = [
  { value: 'multiple_choice', label: 'Multiple Choice' },
  { value: 'fill_blank', label: 'Fill in the Blank' },
  { value: 'ordering', label: 'Ordering' },
  { value: 'tracing', label: 'Tracing' },
] as const;

export const DIFFICULTY_LEVELS = [
  { value: 1, label: 'Very Easy' },
  { value: 2, label: 'Easy' },
  { value: 3, label: 'Medium' },
  { value: 4, label: 'Hard' },
  { value: 5, label: 'Very Hard' },
];
