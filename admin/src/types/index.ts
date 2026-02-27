export interface Parent {
  id: string;
  name: string;
  email: string | null;
  phone: string | null;
  childrenCount: number;
  lastActive: string;
  createdAt: string;
}

export interface Child {
  id: string;
  parentId: string;
  name: string;
  age: number;
  classLevel: string;
  avatar: string;
  language: string;
  createdAt: string;
}

export interface Module {
  id: string;
  name: string;
  slug: string;
  description: string;
  icon: string;
  color: string;
  lessonCount: number;
  questionCount: number;
}

export interface Lesson {
  id: string;
  moduleId: string;
  title: string;
  slug: string;
  description: string;
  difficultyLevel: number;
  classRangeMin: string;
  classRangeMax: string;
  questionCount: number;
  displayOrder: number;
  isActive: boolean;
}

export interface Question {
  id: string;
  lessonId: string;
  type: 'multiple_choice' | 'fill_blank' | 'ordering' | 'tracing';
  questionData: Record<string, unknown>;
  correctAnswer: Record<string, unknown>;
  displayOrder: number;
  isActive: boolean;
}

export interface Progress {
  lessonId: string;
  lessonTitle: string;
  score: number;
  stars: number;
  completed: boolean;
  completedAt: string | null;
}

export interface DashboardStats {
  totalUsers: number;
  activeToday: number;
  newThisWeek: number;
  totalChildren: number;
  moduleEngagement: { name: string; value: number; color: string }[];
  dailyActiveUsers: { date: string; count: number }[];
  recentRegistrations: { id: string; name: string; createdAt: string }[];
}

export interface AdminUser {
  id: string;
  name: string;
  email: string;
  role: string;
}

export interface AuthState {
  user: AdminUser | null;
  token: string | null;
  isAuthenticated: boolean;
  login: (email: string, password: string) => Promise<void>;
  logout: () => void;
}
