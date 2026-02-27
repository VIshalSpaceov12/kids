import api from './api';

export const contentService = {
  async getModules() {
    const response = await api.get('/admin/content/modules');
    return response.data;
  },

  async getLessons(moduleSlug: string) {
    const response = await api.get(`/content/modules/${moduleSlug}/lessons`);
    return response.data;
  },

  async createLesson(data: Record<string, unknown>) {
    const response = await api.post('/admin/content/lessons', data);
    return response.data;
  },

  async updateLesson(id: string, data: Record<string, unknown>) {
    const response = await api.put(`/admin/content/lessons/${id}`, data);
    return response.data;
  },

  async getQuestions(lessonId: string) {
    const response = await api.get(`/content/lessons/${lessonId}/questions`);
    return response.data;
  },

  async createQuestion(data: Record<string, unknown>) {
    const response = await api.post('/admin/content/questions', data);
    return response.data;
  },

  async updateQuestion(id: string, data: Record<string, unknown>) {
    const response = await api.put(`/admin/content/questions/${id}`, data);
    return response.data;
  },

  async deleteQuestion(id: string) {
    const response = await api.delete(`/admin/content/questions/${id}`);
    return response.data;
  },
};
