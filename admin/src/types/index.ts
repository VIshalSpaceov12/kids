export interface AdminUser {
  id: string;
  name: string;
  email: string;
  role: string;
}

export interface User {
  id: string;
  name: string;
  email: string | null;
  phone: string | null;
  role: string;
  age: number | null;
  class_level: string | null;
  is_active: boolean;
  created_at: string;
}

export interface UserDetail extends User {
  avatar: string;
  pet: string;
  language: string;
  updated_at: string;
  stats: {
    totalStars: number;
    completedLessons: number;
    totalAttempts: number;
  };
}

export interface UserProgress {
  score: number;
  stars: number;
  completed: boolean;
  attempts: number;
  lesson_title: string;
  module_name: string;
}

export interface Module {
  id: string;
  name: string;
  slug: string;
  description: string | null;
  icon: string | null;
  color: string | null;
  display_order: number;
  is_active: boolean;
  created_at: string;
  updated_at: string;
  lessonCount: number;
  questionCount: number;
}

export interface Lesson {
  id: string;
  module_id: string;
  title: string;
  slug: string;
  description: string | null;
  difficulty_level: number;
  class_range_min: string | null;
  class_range_max: string | null;
  content_json: Record<string, unknown> | null;
  display_order: number;
  is_active: boolean;
  created_at: string;
  updated_at: string;
}

export interface Question {
  id: string;
  lesson_id: string;
  type: 'multiple_choice' | 'fill_blank' | 'ordering' | 'tracing';
  question_data: Record<string, unknown>;
  correct_answer: Record<string, unknown>;
  media_urls: Record<string, unknown> | null;
  display_order: number;
  is_active: boolean;
  created_at: string;
  updated_at: string;
}

export interface DashboardStats {
  totalUsers: number;
  activeToday: number;
  newThisWeek: number;
}

export interface ModuleEngagement {
  id: string;
  name: string;
  slug: string;
  icon: string | null;
  color: string | null;
  totalAttempts: number;
  uniqueLearners: number;
}

export interface Pagination {
  page: number;
  limit: number;
  total: number;
  totalPages: number;
}

// Form types for creating/updating
export interface LessonFormData {
  moduleId: string;
  title: string;
  slug: string;
  description?: string;
  difficultyLevel?: number;
  classRangeMin?: string;
  classRangeMax?: string;
  contentJson?: Record<string, unknown>;
  displayOrder?: number;
  isActive?: boolean;
}

export interface QuestionFormData {
  lessonId: string;
  type: Question['type'];
  questionData: Record<string, unknown>;
  correctAnswer: Record<string, unknown>;
  mediaUrls?: Record<string, unknown>;
  displayOrder?: number;
  isActive?: boolean;
}
