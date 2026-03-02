'use client';

import { useQuery, useMutation, useQueryClient } from '@tanstack/react-query';
import { toast } from 'sonner';
import type { Module, Lesson, Question, LessonFormData, QuestionFormData } from '@/types';

// Modules
export function useModules() {
  return useQuery<Module[]>({
    queryKey: ['modules'],
    queryFn: async () => {
      const res = await fetch('/api/admin/content/modules');
      if (!res.ok) throw new Error('Failed to fetch modules');
      const data = await res.json();
      if (!data.success) throw new Error(data.message);
      return data.modules;
    },
  });
}

// Lessons for a module
export function useLessons(moduleSlug: string | null) {
  return useQuery<Lesson[]>({
    queryKey: ['lessons', moduleSlug],
    queryFn: async () => {
      const res = await fetch(`/api/admin/content/lessons?moduleSlug=${moduleSlug}`);
      if (!res.ok) throw new Error('Failed to fetch lessons');
      const data = await res.json();
      if (!data.success) throw new Error(data.message);
      return data.lessons;
    },
    enabled: !!moduleSlug,
  });
}

// Questions for a lesson
export function useQuestions(lessonId: string | null) {
  return useQuery<Question[]>({
    queryKey: ['questions', lessonId],
    queryFn: async () => {
      const res = await fetch(`/api/admin/content/questions?lessonId=${lessonId}`);
      if (!res.ok) throw new Error('Failed to fetch questions');
      const data = await res.json();
      if (!data.success) throw new Error(data.message);
      return data.questions;
    },
    enabled: !!lessonId,
  });
}

// Create lesson
export function useCreateLesson() {
  const queryClient = useQueryClient();
  return useMutation({
    mutationFn: async (data: LessonFormData) => {
      const res = await fetch('/api/admin/content/lessons', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify(data),
      });
      const result = await res.json();
      if (!res.ok || !result.success) throw new Error(result.message || 'Failed to create lesson');
      return result.lesson;
    },
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ['lessons'] });
      queryClient.invalidateQueries({ queryKey: ['modules'] });
      toast.success('Lesson created successfully');
    },
    onError: (error: Error) => {
      toast.error(error.message);
    },
  });
}

// Update lesson
export function useUpdateLesson() {
  const queryClient = useQueryClient();
  return useMutation({
    mutationFn: async ({ id, ...data }: Partial<LessonFormData> & { id: string }) => {
      const res = await fetch(`/api/admin/content/lessons/${id}`, {
        method: 'PUT',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify(data),
      });
      const result = await res.json();
      if (!res.ok || !result.success) throw new Error(result.message || 'Failed to update lesson');
      return result.lesson;
    },
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ['lessons'] });
      queryClient.invalidateQueries({ queryKey: ['modules'] });
      toast.success('Lesson updated successfully');
    },
    onError: (error: Error) => {
      toast.error(error.message);
    },
  });
}

// Create question
export function useCreateQuestion() {
  const queryClient = useQueryClient();
  return useMutation({
    mutationFn: async (data: QuestionFormData) => {
      const res = await fetch('/api/admin/content/questions', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify(data),
      });
      const result = await res.json();
      if (!res.ok || !result.success) throw new Error(result.message || 'Failed to create question');
      return result.question;
    },
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ['questions'] });
      queryClient.invalidateQueries({ queryKey: ['modules'] });
      toast.success('Question created successfully');
    },
    onError: (error: Error) => {
      toast.error(error.message);
    },
  });
}

// Update question
export function useUpdateQuestion() {
  const queryClient = useQueryClient();
  return useMutation({
    mutationFn: async ({ id, ...data }: Partial<QuestionFormData> & { id: string }) => {
      const res = await fetch(`/api/admin/content/questions/${id}`, {
        method: 'PUT',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify(data),
      });
      const result = await res.json();
      if (!res.ok || !result.success) throw new Error(result.message || 'Failed to update question');
      return result.question;
    },
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ['questions'] });
      queryClient.invalidateQueries({ queryKey: ['modules'] });
      toast.success('Question updated successfully');
    },
    onError: (error: Error) => {
      toast.error(error.message);
    },
  });
}

// Delete question
export function useDeleteQuestion() {
  const queryClient = useQueryClient();
  return useMutation({
    mutationFn: async (id: string) => {
      const res = await fetch(`/api/admin/content/questions/${id}`, {
        method: 'DELETE',
      });
      const result = await res.json();
      if (!res.ok || !result.success) throw new Error(result.message || 'Failed to delete question');
      return result;
    },
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ['questions'] });
      queryClient.invalidateQueries({ queryKey: ['modules'] });
      toast.success('Question deleted successfully');
    },
    onError: (error: Error) => {
      toast.error(error.message);
    },
  });
}
